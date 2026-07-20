import 'dart:typed_data';

import 'package:image/image.dart' as img;

class WaveshareGImageCodec {
  static const int black = 0;
  static const int white = 1;
  static const int yellow = 2;
  static const int red = 3;

  Uint8List encodeVertical(img.Image image) {
    final width = image.width;
    final height = image.height;

    final indices = _toColorIndices(image);

    final pad = height % 8 == 0 ? 0 : 8 - (height % 8);
    final paddedHeight = height + pad;
    final scanned = Uint8List(width * paddedHeight);

    var t = 0;
    for (var x = 0; x < width; x++) {
      for (var y = 0; y < height; y++) {
        scanned[t++] = indices[y * width + x];
        if (y == height - 1) {
          for (var k = 0; k < pad; k++) {
            scanned[t++] = black;
          }
        }
      }
    }

    final out = Uint8List((width * paddedHeight) ~/ 4);
    var oi = 0;
    for (var i = 0; i < scanned.length; i += 4) {
      out[oi++] = ((scanned[i] << 6) |
              (scanned[i + 1] << 4) |
              (scanned[i + 2] << 2) |
              scanned[i + 3]) &
          0xff;
    }
    return out;
  }

  int packetCount(int width, int height) {
    final base = (width * height) ~/ 250;
    return (base + 1) ~/ 2;
  }

  Uint8List _toColorIndices(img.Image image) {
    final width = image.width;
    final height = image.height;
    final indices = Uint8List(width * height);

    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final p = image.getPixel(x, y);
        indices[y * width + x] = _nearestCode(
          p.r.toInt(),
          p.g.toInt(),
          p.b.toInt(),
        );
      }
    }
    return indices;
  }

  int _nearestCode(int r, int g, int b) {
    var best = white;
    var bestDist = 1 << 30;
    for (final entry in _palette.entries) {
      final pr = entry.value[0];
      final pg = entry.value[1];
      final pb = entry.value[2];
      final dr = r - pr;
      final dg = g - pg;
      final db = b - pb;
      final dist = dr * dr + dg * dg + db * db;
      if (dist < bestDist) {
        bestDist = dist;
        best = entry.key;
      }
    }
    return best;
  }

  static const Map<int, List<int>> _palette = {
    black: [0, 0, 0],
    white: [255, 255, 255],
    yellow: [255, 255, 0],
    red: [255, 0, 0],
  };
}
