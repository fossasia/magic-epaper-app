// Image codec and command payloads for VidaBay NFC e-paper displays
// (Fudan ISO 14443-4 tag; see vidabay_protocol.dart for the sequence).

import 'dart:typed_data';

import 'package:image/image.dart' as img;

class VidabayCodec {
  /// Pixel codes on the wire (2 bits per pixel, first pixel in the MSBs).
  static const int black = 0, white = 1, yellow = 2, red = 3;

  static const int chunkData = 180; // image bytes per chunk (+1 checksum)

  /// Classifies an (already dithered) pixel into the panel's 4 colours.
  static int pixelCode(int r, int g, int b) {
    if (r > 128 && g > 128 && b < 128) return yellow;
    if (r > 128 && g < 128 && b < 128) return red;
    if (r < 128 && g < 128 && b < 128) return black; // max(R,G,B) < 128
    return white;
  }

  /// 400 x 400 panels (Snap): the panel expects the image rotated
  /// by 270 degrees (clockwise) and scanned column by column, 4 pixels per
  /// byte, each column starting on a new byte. Equivalent: for every
  /// source row, emit its pixels from right to left.
  static Uint8List encode(img.Image image,
      {int width = 400, int height = 400}) {
    if (width != height) {
      throw ArgumentError('Only square VidaBay panels are supported so far');
    }
    if (image.width != width || image.height != height) {
      image = img.copyResize(image, width: width, height: height);
    }
    final bytesPerLine = (width + 3) ~/ 4;
    final out = Uint8List(height * bytesPerLine);
    for (int row = 0; row < height; row++) {
      for (int i = 0; i < width; i++) {
        final p = image.getPixel(width - 1 - i, row);
        final code = pixelCode(p.r.toInt(), p.g.toInt(), p.b.toInt());
        out[row * bytesPerLine + (i >> 2)] |= code << (6 - 2 * (i & 3));
      }
    }
    return out;
  }

  /// Splits the encoded image into 181-byte chunks (180 data bytes + sum8).
  /// The last chunk is padded with 0xFF to 180 bytes before its sum.
  static List<Uint8List> chunks(Uint8List data) {
    final out = <Uint8List>[];
    for (int start = 0; start < data.length; start += chunkData) {
      final end =
          start + chunkData < data.length ? start + chunkData : data.length;
      final body = Uint8List(chunkData)
        ..fillRange(0, chunkData, 0xFF)
        ..setAll(0, data.sublist(start, end));
      out.add(_withSum(body));
    }
    return out;
  }

  static Uint8List _withSum(Uint8List body) {
    int sum = 0;
    for (final b in body) {
      sum = (sum + b) & 0xFF;
    }
    return Uint8List(body.length + 1)
      ..setAll(0, body)
      ..[body.length] = sum;
  }

  // ---- command payloads (each sent as APDU 00 4A 00 00 Lc <payload>) -----

  static Uint8List _cmd(List<int> head, int totalLength,
      [List<int> tail = const []]) {
    final p = Uint8List(totalLength);
    p.setAll(0, head);
    p.setAll(totalLength - tail.length, tail);
    return p;
  }

  static Uint8List probe() => _cmd([0x00, 0x00, 0x00, 0x00, 0x01], 32);
  static Uint8List getToken() => _cmd([0x00, 0x4A, 0x01, 0x00], 32);
  static Uint8List hwInfo(List<int> token) =>
      _cmd([0x00, 0x4A, 0x01, 0x09, 0x00], 32, token);
  static Uint8List startSession(List<int> token) =>
      _cmd([0x00, 0x4A, 0x09, 0x00, 0x00, 0xFF], 32, token);
  static Uint8List startTransfer(int chunkCount, List<int> token) => _cmd(
      [0x00, 0x4A, 0x09, 0x01, 0x02, chunkCount >> 8, chunkCount & 0xFF],
      32,
      token);
  static Uint8List chunkFrame(int index, Uint8List chunk) {
    final p = Uint8List(4 + 2 + chunk.length + 1);
    p.setAll(0, [0x00, 0x4A, 0x09, 0x02, index >> 8, index & 0xFF]);
    p.setAll(6, chunk);
    return p; // trailing 0x00
  }

  /// End marker
  static Uint8List endMarker(int chunkCount) {
    final i = chunkCount + 1;
    final p = Uint8List(4 + 2 + 180 + 2);
    p.setAll(0, [0x00, 0x4A, 0x09, 0x02, i >> 8, i & 0xFF]);
    return p;
  }

  static Uint8List pollRefresh(List<int> token) =>
      _cmd([0x00, 0x4A, 0x05, 0x00], 32, token);

  /// Wraps a payload into the APDU that is sent over IsoDep.
  static Uint8List apdu(Uint8List payload) =>
      Uint8List.fromList([0x00, 0x4A, 0x00, 0x00, payload.length, ...payload]);
}
