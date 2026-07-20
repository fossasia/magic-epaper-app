import 'dart:typed_data';

import 'package:magicepaperapp/waveshare/models/waveshare_nfc_exception.dart';

typedef WaveshareGTransceive = Future<Uint8List> Function(
  Uint8List command,
  Duration timeout,
);

typedef WaveshareGProgressCallback = void Function(int progress);

class WaveshareGNfcProtocol {
  static const _timeout = Duration(milliseconds: 3000);
  static const _packetPayload = 250;
  static const _maxBusyPolls = 1000;

  static final _selectApplet = _hex('00A4040007D2760000850101');
  static final _initSession = _hex('F0D801FE050000000000');
  static final _readTag = _hex('00D1000000');
  static final _getDeviceInfo = _hex('F0D8000005000000000E');
  static final _refresh = _hex('F0D4058000');
  static final _pollResult = _hex('F0DE00000001');

  final WaveshareGTransceive _transceive;

  const WaveshareGNfcProtocol({required WaveshareGTransceive transceive})
      : _transceive = transceive;

  Future<bool> writeDisplay(
    Uint8List imageData,
    int packetCount, {
    WaveshareGProgressCallback? onProgress,
  }) async {
    await _send(_selectApplet);
    await _send(_initSession);
    await _send(_readTag);

    final info = await _send(_getDeviceInfo);
    if (!_isSw9000(info)) {
      throw WaveshareNfcException(
        'DEVICE_INFO_FAILED',
        'Unexpected device-info response: ${_toHex(info)}',
      );
    }

    onProgress?.call(0);

    final command = Uint8List(5 + _packetPayload);
    command[0] = 0xf0;
    command[1] = 0xd2;
    command[2] = 0x00;
    command[4] = 0xfa;

    for (var packet = 0; packet < packetCount; packet++) {
      command[3] = packet & 0xff;
      final base = packet * _packetPayload;
      for (var i = 0; i < _packetPayload; i++) {
        final index = base + i;
        command[5 + i] = index < imageData.length ? imageData[index] : 0;
      }

      final response = await _send(command);
      if (!_isSw9000(response)) {
        throw WaveshareNfcException(
          'FLASH_FAILED',
          'Packet $packet rejected: ${_toHex(response)}',
        );
      }
      onProgress?.call((packet + 1) * 95 ~/ packetCount);
    }

    await _send(_refresh);

    for (var attempt = 0; attempt < _maxBusyPolls; attempt++) {
      final status = _toHex(await _send(_pollResult));
      if (status == '009000') {
        onProgress?.call(100);
        return true;
      }
      if (status == '019000') {
        await _sleep(100);
        continue;
      }
      throw WaveshareNfcException(
        'REFRESH_FAILED',
        'Refresh reported error status: $status',
      );
    }

    return false;
  }

  Future<Uint8List> _send(Uint8List command) async {
    try {
      return await _transceive(command, _timeout);
    } catch (error) {
      throw WaveshareNfcException(
        'NFC_COMMUNICATION',
        'A communication error occurred: $error',
      );
    }
  }

  bool _isSw9000(Uint8List response) {
    return response.length >= 2 &&
        response[response.length - 2] == 0x90 &&
        response[response.length - 1] == 0x00;
  }

  String _toHex(Uint8List bytes) {
    final buffer = StringBuffer();
    for (final b in bytes) {
      buffer.write((b & 0xff).toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }

  Future<void> _sleep(int milliseconds) {
    return Future<void>.delayed(Duration(milliseconds: milliseconds));
  }

  static Uint8List _hex(String value) {
    final result = Uint8List(value.length ~/ 2);
    for (var i = 0; i < result.length; i++) {
      result[i] = int.parse(value.substring(i * 2, i * 2 + 2), radix: 16);
    }
    return result;
  }
}
