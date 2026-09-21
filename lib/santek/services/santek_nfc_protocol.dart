import 'dart:typed_data';

import 'package:magicepaperapp/santek/models/santek_nfc_exception.dart';

typedef SantekTransceive = Future<Uint8List> Function(Uint8List command, Duration timeout);
typedef SantekProgressCallback = void Function(int progress);

class SantekNfcProtocol {
  static const _chunkSize = 250;
  static const _totalChunks = 32;
  static const _writeTimeout = Duration(milliseconds: 5000);
  static const _refreshTimeout = Duration(milliseconds: 30000);

  static final _select = _hex('00A4040007D2760000850101');
  static final _auth = _hex('002000010420091210');
  static final _init = _hex('00D1000000');
  static final _refresh = _hex('F0D4858000');
  static final _poll = _hex('F0DE000001');

  final SantekTransceive _transceive;

  const SantekNfcProtocol({required SantekTransceive transceive})
      : _transceive = transceive;

  Future<void> writeAndRefresh(
    Uint8List data, {
    SantekProgressCallback? onProgress,
  }) async {
    await _send(_select, _writeTimeout);

    Uint8List authResp = await _send(_auth, _writeTimeout);
    if (!_isSw9000(authResp)) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      authResp = await _send(_auth, _writeTimeout);
      if (!_isSw9000(authResp)) {
        throw SantekNfcException('AUTH_FAILED', 'Auth rejected: ${authResp.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}');
      }
    }

    await _send(_select, _writeTimeout);
    await _send(_init, _writeTimeout);

    onProgress?.call(0);

    for (var seq = 0; seq < _totalChunks; seq++) {
      final apdu = Uint8List(5 + _chunkSize);
      apdu[0] = 0xF0;
      apdu[1] = 0xD2;
      apdu[2] = (seq >> 8) & 0xFF;
      apdu[3] = seq & 0xFF;
      apdu[4] = _chunkSize;
      apdu.setRange(5, 5 + _chunkSize, data, seq * _chunkSize);

      await _send(apdu, _writeTimeout);
      onProgress?.call(seq * 85 ~/ _totalChunks);
    }

    onProgress?.call(87);

    final refreshResp = await _send(_refresh, _refreshTimeout);
    if (!_isSw9000(refreshResp)) {
      throw SantekNfcException('REFRESH_FAILED', 'Refresh rejected: ${refreshResp.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}');
    }

    onProgress?.call(90);

    await Future<void>.delayed(const Duration(milliseconds: 1500));

    for (var attempt = 0; attempt < 80; attempt++) {
      final pollResp = await _send(_poll, _writeTimeout);
      final status = pollResp.isNotEmpty ? pollResp[0] : 0x00;
      if (status == 0x00) break;
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }

    onProgress?.call(100);
  }

  Future<Uint8List> _send(Uint8List command, Duration timeout) async {
    try {
      return await _transceive(command, timeout);
    } catch (e) {
      throw SantekNfcException('NFC_COMMUNICATION', 'Communication error: $e');
    }
  }

  bool _isSw9000(Uint8List r) =>
      r.length >= 2 && r[r.length - 2] == 0x90 && r[r.length - 1] == 0x00;

  static Uint8List _hex(String s) {
    final r = Uint8List(s.length ~/ 2);
    for (var i = 0; i < r.length; i++) {
      r[i] = int.parse(s.substring(i * 2, i * 2 + 2), radix: 16);
    }
    return r;
  }
}
