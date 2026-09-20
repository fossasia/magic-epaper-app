import 'dart:math';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

class SantekImageCodec {
  static const int _black = 0;
  static const int _white = 1;
  static const int _yellow = 2;
  static const int _red = 3;

  static const Map<int, List<int>> _palette = {
    _black: [0, 0, 0],
    _white: [255, 255, 255],
    _yellow: [255, 255, 0],
    _red: [255, 0, 0],
  };

  // Returns LZO1X-literal-encoded blocks ready for the protocol to send.
  // rowsPerBlock comes from the device-info APDU; defaults to 4.
  List<Uint8List> encodeBlocks(img.Image image, {int rowsPerBlock = 4}) {
    final width = image.width;
    final height = image.height;
    final bytesPerRow = (width * 2 + 7) >> 3;

    final blocks = <Uint8List>[];
    var y = 0;
    while (y < height) {
      final rows = min(rowsPerBlock, height - y);
      final raw = Uint8List(rows * bytesPerRow);
      for (var row = 0; row < rows; row++) {
        final base = row * bytesPerRow;
        // Right-to-left packing: pixel[width-1] → MSBs of byte[0].
        for (var x = width - 1; x >= 0; x--) {
          final p = image.getPixel(x, y + row);
          final idx = _nearest(p.r.toInt(), p.g.toInt(), p.b.toInt());
          final bit = (width - 1 - x) * 2;
          raw[base + bit ~/ 8] |= (idx & 0x03) << (6 - bit % 8);
        }
      }
      blocks.add(_lzo(raw));
      y += rows;
    }
    return blocks;
  }

  // LZO1X literal-only encoding (no actual compression).
  Uint8List _lzo(Uint8List src) {
    final len = src.length;
    final out = BytesBuilder();
    if (len <= 238) {
      out.addByte(17 + len);
    } else {
      out.addByte(0);
      var remaining = len - 18;
      while (remaining >= 255) {
        out.addByte(0);
        remaining -= 255;
      }
      out.addByte(remaining);
    }
    out.add(src);
    out.addByte(17);
    out.addByte(0);
    out.addByte(0);
    return out.toBytes();
  }

  int _nearest(int r, int g, int b) {
    var best = _white;
    var bestDist = 1 << 30;
    for (final e in _palette.entries) {
      final pr = e.value[0], pg = e.value[1], pb = e.value[2];
      final d = (r - pr) * (r - pr) + (g - pg) * (g - pg) + (b - pb) * (b - pb);
      if (d < bestDist) {
        bestDist = d;
        best = e.key;
      }
    }
    return best;
  }
}
