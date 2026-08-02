import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:logger/logger.dart';

/// BLE protocol for Gicisky / Picksmart ESL tags.
///
/// GATT characteristics (16-bit UUIDs under the standard base):
/// - Request / notify: 0xFEF1
/// - Image data:       0xFEF2
///
/// Protocol flow (from reverse engineering):
/// 1. Request block size (0x01)
/// 2. Request write screen with image size (0x02 + 4-byte LE size)
/// 3. Request start transfer (0x03)
/// 4. On notify 0x05 + part index, send image block
/// 5. On notify 0x05 0x08, transfer complete
class GiciskyBleProtocol {
  static final Guid requestCharacteristicUuid =
      Guid('0000fef1-0000-1000-8000-00805f9b34fb');
  static final Guid imageCharacteristicUuid =
      Guid('0000fef2-0000-1000-8000-00805f9b34fb');

  static final Logger _log = Logger();

  final BluetoothDevice device;
  final Uint8List imageData;
  final void Function(double progress, String status)? onProgress;

  int? _blockSize;
  StreamSubscription<List<int>>? _notifySub;
  final _transferCompleter = Completer<void>();
  final _blockRequestController = StreamController<int?>.broadcast();

  GiciskyBleProtocol({
    required this.device,
    required this.imageData,
    this.onProgress,
  });

  Future<void> transfer() async {
    onProgress?.call(0.0, 'Connecting...');
    await device.connect(timeout: const Duration(seconds: 15));
    try {
      onProgress?.call(0.05, 'Discovering services...');
      final services = await device.discoverServices();

      BluetoothCharacteristic? requestChar;
      BluetoothCharacteristic? imageChar;

      for (final service in services) {
        for (final c in service.characteristics) {
          if (c.uuid == requestCharacteristicUuid) requestChar = c;
          if (c.uuid == imageCharacteristicUuid) imageChar = c;
        }
      }

      if (requestChar == null || imageChar == null) {
        throw Exception(
          'Gicisky characteristics (0xFEF1 / 0xFEF2) not found. '
          'Is this a supported Picksmart / Gicisky ESL?',
        );
      }

      onProgress?.call(0.1, 'Subscribing to notifications...');
      await requestChar.setNotifyValue(true);
      _notifySub = requestChar.onValueReceived.listen((data) {
        _handleNotify(data, imageChar!);
      });

      onProgress?.call(0.15, 'Requesting block size...');
      await _writeRequest(requestChar, [0x01]);
      await _waitForBlockSize();

      onProgress?.call(0.2, 'Requesting screen write...');
      final sizeBytes = _intToLe(imageData.length, 4);
      await _writeRequest(requestChar, [0x02, ...sizeBytes]);

      onProgress?.call(0.25, 'Starting transfer...');
      await _writeRequest(requestChar, [0x03]);

      // Drive the transfer via notify-driven block requests
      await _transferCompleter.future.timeout(
        const Duration(minutes: 3),
        onTimeout: () => throw TimeoutException('Image transfer timed out'),
      );

      onProgress?.call(1.0, 'Transfer complete');
    } finally {
      await _notifySub?.cancel();
      try {
        await device.disconnect();
      } catch (_) {}
    }
  }

  Future<void> _writeRequest(
    BluetoothCharacteristic char,
    List<int> data,
  ) async {
    await char.write(data, withoutResponse: false);
  }

  Future<void> _waitForBlockSize() async {
    // Block size arrives via notify 0x01
    final completer = Completer<void>();
    late StreamSubscription sub;
    sub = _blockRequestController.stream.listen((_) {
      if (_blockSize != null && !completer.isCompleted) {
        completer.complete();
        sub.cancel();
      }
    });
    // Also poll briefly in case notify already arrived
    for (var i = 0; i < 50 && _blockSize == null; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    if (_blockSize == null) {
      await completer.future.timeout(const Duration(seconds: 10));
    }
  }

  void _handleNotify(List<int> data, BluetoothCharacteristic imageChar) {
    if (data.isEmpty) return;
    _log.d('Gicisky notify: $data');

    switch (data[0]) {
      case 0x01:
        if (data.length >= 3) {
          _blockSize = data[1] | (data[2] << 8);
          _log.i('Block size: $_blockSize');
          _blockRequestController.add(null);
        }
        break;
      case 0x02:
        if (data.length > 1 && data[1] != 0x00) {
          _fail('Write screen rejected: ${data[1]}');
        }
        break;
      case 0x05:
        if (data.length < 2) break;
        if (data[1] == 0x00 && data.length >= 6) {
          final part = data[2] |
              (data[3] << 8) |
              (data[4] << 16) |
              (data[5] << 24);
          _sendImageBlock(imageChar, part);
        } else if (data[1] == 0x08) {
          if (!_transferCompleter.isCompleted) {
            _transferCompleter.complete();
          }
        } else {
          _fail('Image transfer error: ${data[1]}');
        }
        break;
      default:
        _log.w('Unknown notify opcode: ${data[0]}');
    }
  }

  Future<void> _sendImageBlock(
    BluetoothCharacteristic imageChar,
    int part,
  ) async {
    final blockSize = _blockSize;
    if (blockSize == null || blockSize <= 4) {
      _fail('Invalid block size');
      return;
    }
    final imgBlockSize = blockSize - 4;
    final numParts = (imageData.length + imgBlockSize - 1) ~/ imgBlockSize;
    if (part >= numParts) {
      _fail('Part $part out of range (max $numParts)');
      return;
    }

    final start = part * imgBlockSize;
    final end = (start + imgBlockSize).clamp(0, imageData.length);
    final slice = imageData.sublist(start, end);

    final message = BytesBuilder();
    message.add(_intToLe(part, 4));
    message.add(slice);

    final progress = 0.25 + 0.7 * ((part + 1) / numParts);
    onProgress?.call(
      progress.clamp(0.0, 0.95),
      'Sending part ${part + 1}/$numParts',
    );

    await imageChar.write(message.toBytes(), withoutResponse: false);
  }

  void _fail(String message) {
    if (!_transferCompleter.isCompleted) {
      _transferCompleter.completeError(Exception(message));
    }
  }

  List<int> _intToLe(int value, int byteCount) {
    final bytes = <int>[];
    for (var i = 0; i < byteCount; i++) {
      bytes.add((value >> (8 * i)) & 0xff);
    }
    return bytes;
  }
}
