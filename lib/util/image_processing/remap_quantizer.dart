import 'dart:math';
import 'package:image/image.dart' as img;

class RemapQuantizer extends img.Quantizer {
  @override
  final img.Palette palette;
  final _colorLut = <img.Color>[];

  RemapQuantizer({required this.palette}) {
    for (int i = 0; i < palette.numColors; i++) {
      _colorLut.add(img.ColorRgb8(palette.getRed(i) as int,
          palette.getGreen(i) as int, palette.getBlue(i) as int));
    }
  }

  @override
  img.Color getQuantizedColor(img.Color c) {
    return _map(c).$1;
  }

  @override
  int getColorIndex(img.Color c) {
    return _map(c).$2;
  }

  @override
  int getColorIndexRgb(int r, int g, int b) {
    return _map(img.ColorRgb8(r, g, b)).$2;
  }

  num _distance(img.Color a, img.Color b) {
    return (a.r - b.r) * (a.r - b.r) +
        (a.g - b.g) * (a.g - b.g) +
        (a.b - b.b) * (a.b - b.b);
  }

  (img.Color, int) _map(img.Color c) {
    final ds = <num>[];
    for (int i = 0; i < palette.numColors; i++) {
      ds.add(_distance(c, _colorLut[i]));
    }
    final nearestIndex = ds.indexOf(ds.reduce(min));
    return (_colorLut[nearestIndex], nearestIndex);
  }
}
