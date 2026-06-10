import 'dart:typed_data';

import 'package:magicepaperapp/waveshare/models/waveshare_nfc_exception.dart';
import 'package:magicepaperapp/waveshare/models/waveshare_nfc_profile.dart';
import 'package:magicepaperapp/waveshare/services/waveshare_image_codec.dart';

typedef WaveshareTransceive = Future<Uint8List> Function(
  Uint8List command,
  Duration timeout,
);

typedef WaveshareProgressCallback = void Function(int progress);

class WaveshareNfcProtocol {
  static const _transceiveTimeout = Duration(milliseconds: 2000);
  static const _maxBusyPolls = 240;
  static const _androidPackageRecord = [
    3,
    39,
    212,
    15,
    21,
    97,
    110,
    100,
    114,
    111,
    105,
    100,
    46,
    99,
    111,
    109,
    58,
    112,
    107,
    103,
    119,
    97,
    118,
    101,
    115,
    104,
    97,
    114,
    101,
    46,
    102,
    101,
    110,
    103,
    46,
    110,
    102,
    99,
    116,
    97,
    103,
    254,
    0,
    0,
    0,
    0,
    0,
    0,
  ];

  final WaveshareTransceive _transceive;

  const WaveshareNfcProtocol({
    required WaveshareTransceive transceive,
  }) : _transceive = transceive;

  Future<bool> writeDisplay(
      WaveshareNfcProfile profile,
      WaveshareImageData imageData, {
        WaveshareProgressCallback? onProgress,
        bool isIsoDep = true,
      }) async {
    if (isIsoDep) {
      return _writeIsoDepDisplay(profile, imageData, onProgress: onProgress);
    }

    if (profile.isHdDisplay) {
      return _writeHdDisplay(profile, imageData, onProgress: onProgress);
    }

    await _ensureAndroidPackageRecord();
    return _writeStandardDisplay(profile, imageData, onProgress: onProgress);
  }

  Future<void> _ensureAndroidPackageRecord() async {
    final current = Uint8List(48);

    try {
      final page4 = await _send([0x30, 0x04]);
      current.setRange(0, 16, page4.take(16));
      final page8 = await _send([0x30, 0x08]);
      current.setRange(16, 32, page8.take(16));
      final page12 = await _send([0x30, 0x0c]);
      current.setRange(32, 48, page12.take(16));
    } catch (_) {
      // The vendor code still writes the expected record if the read fails.
    }

    if (_listEquals(current, _androidPackageRecord)) {
      return;
    }

    for (var page = 0; page < 11; page++) {
      try {
        await _send([
          0xa2,
          page + 4,
          _androidPackageRecord[page * 4],
          _androidPackageRecord[page * 4 + 1],
          _androidPackageRecord[page * 4 + 2],
          _androidPackageRecord[page * 4 + 3],
        ]);
      } catch (_) {
        // The original library ignored failures while updating this optional AAR.
      }
    }
  }

  Future<bool> _writeStandardDisplay(
    WaveshareNfcProfile profile,
    WaveshareImageData imageData, {
    WaveshareProgressCallback? onProgress,
  }) async {
    if (!await _sendOk([0xcd, 0x0d])) return false;
    if (!await _sendOk([0xcd, 0x00, profile.panelInitCode])) return false;
    await _sleep(50);
    if (!await _sendOk([0xcd, 0x01])) return false;
    await _sleep(20);
    if (!await _sendOk([0xcd, 0x02])) return false;
    await _sleep(20);
    if (!await _sendOk([0xcd, 0x03])) return false;
    await _sleep(20);
    if (!await _sendOk([0xcd, 0x05])) return false;
    await _sleep(20);
    if (!await _sendOk([0xcd, 0x06])) return false;
    await _sleep(10);

    if (!await _sendOk([0xcd, 0x07, 0x00])) return false;

    var response = Uint8List.fromList([0, 0]);
    for (var chunk = 0; chunk < profile.packetCount; chunk++) {
      final command = _packet(
        0x08,
        profile.payloadLength,
        imageData.primary,
        chunk * profile.payloadLength,
        profile.payloadLength,
      );

      if (profile.type != 6) {
        response = await _send(command);
      }

      if (!_isOk(response)) return false;

      if (profile.type != 6 && profile.type != 7) {
        onProgress?.call(chunk * 100 ~/ profile.packetCount);
      } else {
        onProgress?.call(chunk * 50 ~/ profile.packetCount);
      }

      await _sleep(2);
    }

    if (profile.type == 5) {
      await _send([0xcd, 0x08, 120, ...List<int>.filled(110, 0xff)]);
    }

    if (!await _sendOk([0xcd, 0x18])) return false;

    if (profile.type == 7) {
      for (var chunk = 0; chunk < profile.packetCount; chunk++) {
        final command = _packet(
          0x08,
          profile.payloadLength,
          imageData.secondary,
          chunk * profile.payloadLength,
          profile.payloadLength,
        );
        final secondaryResponse = await _send(command);
        if (!_isOk(secondaryResponse)) return false;

        onProgress?.call(chunk * 50 ~/ profile.packetCount + 50);
        await _sleep(2);
      }
    } else if (profile.type == 6) {
      await _sleep(100);

      for (var chunk = 0; chunk < 48; chunk++) {
        final command = _packet(
          0x19,
          121,
          imageData.primary,
          chunk * 121,
          121,
        );

        onProgress?.call(chunk * 50 ~/ 48 + 51);
        final chunkResponse = await _send(command);
        if (!_isOk(chunkResponse)) return false;
        await _sleep(2);
      }

      await _sleep(100);
    }

    await _sleep(200);
    if (!await _sendOk([0xcd, 0x09])) return false;
    await _sleep(300);

    for (var attempt = 0; attempt < _maxBusyPolls; attempt++) {
      final busyResponse = await _send([0xcd, 0x0a]);
      if (_isDone(busyResponse)) {
        if (await _sendOk([0xcd, 0x04])) {
          onProgress?.call(100);
          return true;
        }
        return false;
      }

      await _sleep(25);
    }

    return false;
  }

  Future<bool> _writeHdDisplay(
    WaveshareNfcProfile profile,
    WaveshareImageData imageData, {
    WaveshareProgressCallback? onProgress,
  }) async {
    await _sleep(10);
    if (!await _sendOk([0xcd, 0x0d])) return false;
    await _sleep(10);
    if (!await _sendOk([0xcd, 0x00])) return false;
    await _sleep(10);
    if (!await _sendOk([0xcd, 0x01])) return false;
    await _sleep(10);
    if (!await _sendOk([0xcd, 0x02])) return false;
    await _sleep(100);
    if (!await _sendOk([0xcd, 0x03])) return false;
    await _sleep(100);

    for (var chunk = 0; chunk < 50; chunk++) {
      final command = _packet(0x05, 100, imageData.primary, chunk * 100, 100);
      onProgress?.call(chunk);
      final response = await _send(command);
      if (!_isOk(response)) return false;
      await _sleep(5);
    }

    if (!await _sendOk([0xcd, 0x04])) return false;
    await _sleep(30);

    for (var chunk = 0; chunk < 50; chunk++) {
      final command = _packet(0x05, 100, imageData.secondary, chunk * 100, 100);
      onProgress?.call(chunk + 50);
      final response = await _send(command);
      if (!_isOk(response)) return false;
      await _sleep(5);
    }

    await _sleep(100);
    if (!await _sendOk([0xcd, 0x06])) return false;
    await _sleep(1000);

    for (var attempt = 0; attempt < _maxBusyPolls; attempt++) {
      final busyResponse = await _send([0xcd, 0x08]);
      if (_isDone(busyResponse)) {
        onProgress?.call(100);
        return true;
      }

      await _sleep(500);
    }

    return false;
  }

  List<int> _packet(
    int command,
    int payloadLength,
    Uint8List source,
    int sourceOffset,
    int count,
  ) {
    final packet = <int>[0xcd, command, payloadLength];
    for (var i = 0; i < count; i++) {
      final index = sourceOffset + i;
      packet.add(index < source.length ? source[index] : 0);
    }
    return packet;
  }

  Future<bool> _sendOk(List<int> command) async {
    return _isOk(await _send(command));
  }

  Future<Uint8List> _send(List<int> command) async {
    final normalized = Uint8List.fromList(
      command.map((byte) => byte & 0xff).toList(growable: false),
    );

    try {
      return await _transceive(normalized, _transceiveTimeout);
    } catch (error) {
      throw WaveshareNfcException(
        'NFC_COMMUNICATION',
        'A communication error occurred: $error',
      );
    }
  }

  bool _isOk(Uint8List response) {
    return response.length >= 2 && response[0] == 0 && response[1] == 0;
  }

  bool _isDone(Uint8List response) {
    return response.length >= 2 && response[0] == 0xff && response[1] == 0;
  }

  bool _listEquals(List<int> left, List<int> right) {
    if (left.length != right.length) return false;
    for (var i = 0; i < left.length; i++) {
      if (left[i] != right[i]) return false;
    }
    return true;
  }

  Future<void> _sleep(int milliseconds) {
    return Future<void>.delayed(Duration(milliseconds: milliseconds));
  }

  Future<bool> _writeIsoDepDisplay(
      WaveshareNfcProfile profile,
      WaveshareImageData imageData, {
        WaveshareProgressCallback? onProgress,
      }) async {

    final initResp = await _send([116, 177, 0, 0, 8, 0, 17, 34, 51, 68, 85, 102, 119]);
    if (!_isIsoDepOk(initResp)) return false;

    if (!_isIsoDepOk(await _send([116, 151, 0, 8, 0]))) return false;
    await _sleep(150);

    if (!_isIsoDepOk(await _send([116, 151, 1, 8, 0]))) return false;
    await _sleep(150);

    if (!_isIsoDepOk(await _send([116, 153, 0, 13, 1, 1]))) return false;
    if (!_isIsoDepOk(await _send([116, 154, 0, 14, 3, 199, 0, 1]))) return false;
    if (!_isIsoDepOk(await _send([116, 153, 0, 13, 1, 17]))) return false;
    if (!_isIsoDepOk(await _send([116, 154, 0, 14, 1, 1]))) return false;
    if (!_isIsoDepOk(await _send([116, 153, 0, 13, 1, 68]))) return false;
    if (!_isIsoDepOk(await _send([116, 154, 0, 14, 2, 0, 24]))) return false;
    if (!_isIsoDepOk(await _send([116, 153, 0, 13, 1, 69]))) return false;
    if (!_isIsoDepOk(await _send([116, 154, 0, 14, 4, 199, 0, 0, 0]))) return false;
    if (!_isIsoDepOk(await _send([116, 153, 0, 13, 1, 60]))) return false;
    if (!_isIsoDepOk(await _send([116, 154, 0, 14, 1, 5]))) return false;
    if (!_isIsoDepOk(await _send([116, 153, 0, 13, 1, 24]))) return false;
    if (!_isIsoDepOk(await _send([116, 154, 0, 14, 1, 128]))) return false;
    if (!_isIsoDepOk(await _send([116, 153, 0, 13, 1, 78]))) return false;
    if (!_isIsoDepOk(await _send([116, 154, 0, 14, 1, 0]))) return false;
    if (!_isIsoDepOk(await _send([116, 153, 0, 13, 1, 79]))) return false;
    if (!_isIsoDepOk(await _send([116, 154, 0, 14, 2, 199, 0]))) return false;
    await _sleep(100);

    if (!_isIsoDepOk(await _send([116, 153, 0, 13, 1, 36]))) return false;

    var chunkHeader = [116, 154, 0, 14, 250];
    for (var i = 0; i < 20; i++) {
      final offset = i * 250;
      final payload = imageData.primary.sublist(offset, offset + 250);
      final txBuffer = Uint8List.fromList([...chunkHeader, ...payload]);

      onProgress?.call((i * 100) ~/ 40);
      if (!_isIsoDepOk(await _send(txBuffer))) return false;
    }

    if (!_isIsoDepOk(await _send([116, 153, 0, 13, 1, 38]))) return false;

    for (var i = 0; i < 20; i++) {
      final offset = i * 250;
      final payload = imageData.secondary.length > offset
          ? imageData.secondary.sublist(offset, offset + 250)
          : imageData.primary.sublist(offset, offset + 250);

      final txBuffer = Uint8List.fromList([...chunkHeader, ...payload]);

      onProgress?.call(((i + 20) * 100) ~/ 40);
      if (!_isIsoDepOk(await _send(txBuffer))) return false;
    }

    onProgress?.call(99);

    if (!_isIsoDepOk(await _send([116, 153, 0, 13, 1, 34]))) return false;
    if (!_isIsoDepOk(await _send([116, 154, 0, 14, 1, 247]))) return false;
    if (!_isIsoDepOk(await _send([116, 153, 0, 13, 1, 32]))) return false;

    await _sleep(4000);
    for (var attempt = 0; attempt < _maxBusyPolls; attempt++) {
      final busyResponse = await _send([116, 155, 0, 15, 1]);
      if (busyResponse.isNotEmpty && busyResponse[0] != 1) {
        onProgress?.call(100);
        return true;
      }
      await _sleep(200);
    }

    return false;
  }

  bool _isIsoDepOk(Uint8List response) {
    return response.length >= 2 &&
        response[response.length - 2] == 144 &&
        response[response.length - 1] == 0;
  }
}
