import 'dart:typed_data';

import 'package:image/image.dart' as img;

class SantekImageCodec {
  static const int _black = 0;
  static const int _white = 1;
  static const int _yellow = 2;
  static const int _red = 3;

  static const int width = 250;
  static const int height = 128;

  static const Map<int, List<int>> _palette = {
    _black: [0, 0, 0],
    _white: [255, 255, 255],
    _yellow: [255, 255, 0],
    _red: [255, 0, 0],
  };

  Uint8List encode(img.Image image) {
    final resized = img.copyResize(
      image,
      width: width,
      height: height,
      interpolation: img.Interpolation.average,
    );
    final data = Uint8List(width * height * 2 ~/ 8);
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final p = resized.getPixel(x, y);
        final idx = _nearest(p.r.toInt(), p.g.toInt(), p.b.toInt());
        final bitPos = (x * height + y) * 2;
        data[bitPos >> 3] |= (idx & 0x03) << (6 - (bitPos & 7));
      }
    }
    return data;
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
