import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:magicepaperapp/santek/models/santek_nfc_exception.dart';
import 'package:magicepaperapp/santek/services/santek_image_codec.dart';

typedef SantekTransceive = Future<Uint8List> Function(Uint8List command, Duration timeout);
typedef SantekProgressCallback = void Function(int progress);

class SantekNfcProtocol {
  static const _timeout = Duration(milliseconds: 5000);
  static const _maxFragmentData = 248; // 250 payload - 2 bytes (block_no, frag_no)
  static const _maxBusyPolls = 600;

  // Fixed password from the EZ Sign protocol.
  static final _auth = _hex('002000010420091210');
  // Self-describing device-info: returns TLV with resolution + rowsPerBlock.
  static final _deviceInfo = _hex('00D100000100');
  static final _refresh = _hex('F0D4858000');
  static final _poll = _hex('F0DE000001');

  final SantekTransceive _transceive;

  const SantekNfcProtocol({required SantekTransceive transceive})
      : _transceive = transceive;

  Future<bool> writeDisplay(
    img.Image image, {
    SantekProgressCallback? onProgress,
  }) async {
    // Authenticate.
    final authResp = await _send(_auth);
    if (!_isSw9000(authResp)) {
      throw SantekNfcException('AUTH_FAILED', 'Auth rejected: ${_hex2(authResp)}');
    }

    // Read device info to get rowsPerBlock and actual display dimensions.
    final infoResp = await _send(_deviceInfo);
    final rowsPerBlock = _parseRowsPerBlock(infoResp);

    onProgress?.call(0);

    // Encode image into LZO-wrapped blocks.
    final codec = SantekImageCodec();
    final oriented = image.width < image.height
        ? img.copyRotate(image, angle: 90)
        : image;
    final blocks = codec.encodeBlocks(oriented, rowsPerBlock: rowsPerBlock);

    // Send all blocks as F0D3 APDUs.
    var sent = 0;
    final totalApdus = _countApdus(blocks);

    for (var blockNo = 0; blockNo < blocks.length; blockNo++) {
      final block = blocks[blockNo];
      var offset = 0;
      var fragNo = 0;
      while (offset < block.length) {
        final remaining = block.length - offset;
        final fragLen = remaining < _maxFragmentData ? remaining : _maxFragmentData;
        final isLast = (blockNo == blocks.length - 1) && (offset + fragLen >= block.length);

        final apdu = Uint8List(5 + 2 + fragLen);
        apdu[0] = 0xF0;
        apdu[1] = 0xD3;
        apdu[2] = 0x00;
        apdu[3] = isLast ? 0x01 : 0x00;
        apdu[4] = 2 + fragLen;
        apdu[5] = blockNo & 0xFF;
        apdu[6] = fragNo & 0xFF;
        apdu.setRange(7, 7 + fragLen, block, offset);

        final resp = await _send(apdu);
        if (!_isSw9000(resp)) {
          throw SantekNfcException(
            'WRITE_FAILED',
            'Block $blockNo frag $fragNo rejected: ${_hex2(resp)}',
          );
        }

        offset += fragLen;
        fragNo++;
        sent++;
        onProgress?.call(sent * 90 ~/ totalApdus);
      }
    }

    // Trigger display refresh.
    final refreshResp = await _send(_refresh);
    if (!_isSw9000(refreshResp)) {
      throw SantekNfcException('REFRESH_FAILED', 'Refresh rejected: ${_hex2(refreshResp)}');
    }

    // Poll until display finishes updating.
    for (var attempt = 0; attempt < _maxBusyPolls; attempt++) {
      final pollResp = await _send(_poll);
      if (pollResp.isNotEmpty && pollResp[0] == 0x00) {
        onProgress?.call(100);
        return true;
      }
      await Future<void>.delayed(const Duration(milliseconds: 200));
    }

    return false;
  }

  int _parseRowsPerBlock(Uint8List response) {
    // TLV: tag A0 → [color_mode, rows_per_block, height_hi, height_lo, width_hi, width_lo]
    for (var i = 0; i + 1 < response.length; i++) {
      if (response[i] == 0xA0) {
        final len = response[i + 1];
        if (len >= 2 && i + 2 < response.length) {
          return response[i + 2 + 1]; // index 1 = rows_per_block
        }
      }
    }
    return 4; // safe default
  }

  int _countApdus(List<Uint8List> blocks) {
    var count = 0;
    for (final b in blocks) {
      count += (b.length + _maxFragmentData - 1) ~/ _maxFragmentData;
    }
    return count;
  }

  Future<Uint8List> _send(Uint8List command) async {
    try {
      return await _transceive(command, _timeout);
    } catch (e) {
      throw SantekNfcException('NFC_COMMUNICATION', 'Communication error: $e');
    }
  }

  bool _isSw9000(Uint8List r) =>
      r.length >= 2 && r[r.length - 2] == 0x90 && r[r.length - 1] == 0x00;

  String _hex2(Uint8List bytes) {
    final b = StringBuffer();
    for (final x in bytes) {
      b.write(x.toRadixString(16).padLeft(2, '0'));
    }
    return b.toString();
  }

  static Uint8List _hex(String s) {
    final r = Uint8List(s.length ~/ 2);
    for (var i = 0; i < r.length; i++) {
      r[i] = int.parse(s.substring(i * 2, i * 2 + 2), radix: 16);
    }
    return r;
  }
}
