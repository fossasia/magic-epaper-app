import 'package:image/image.dart' as img;
import 'dart:typed_data';

class RemapQuantizer extends img.Quantizer {
  @override
  final img.Palette palette;

  final List<img.Color> _colorLut = [];

  late final Uint8List _paletteR;
  late final Uint8List _paletteG;
  late final Uint8List _paletteB;

  final Map<int, int> _colorCache = {};
  static const int _maxCacheSize = 1024;

  RemapQuantizer({required this.palette}) {
    final numColors = palette.numColors;

    _paletteR = Uint8List(numColors);
    _paletteG = Uint8List(numColors);
    _paletteB = Uint8List(numColors);

    for (int i = 0; i < numColors; i++) {
      final r = palette.getRed(i) as int;
      final g = palette.getGreen(i) as int;
      final b = palette.getBlue(i) as int;

      _colorLut.add(img.ColorRgb8(r, g, b));
      _paletteR[i] = r;
      _paletteG[i] = g;
      _paletteB[i] = b;
    }
  }

  @override
  img.Color getQuantizedColor(img.Color c) {
    final index = _getColorIndexInternal(c.r.toInt(), c.g.toInt(), c.b.toInt());
    return _colorLut[index];
  }

  @override
  int getColorIndex(img.Color c) {
    return _getColorIndexInternal(c.r.toInt(), c.g.toInt(), c.b.toInt());
  }

  @override
  int getColorIndexRgb(int r, int g, int b) {
    return _getColorIndexInternal(r, g, b);
  }

  int _getColorIndexInternal(int r, int g, int b) {
    final cacheKey = ((r & 0xFF) << 16) | ((g & 0xFF) << 8) | (b & 0xFF);

    final cachedResult = _colorCache[cacheKey];
    if (cachedResult != null) {
      return cachedResult;
    }

    final numColors = _paletteR.length;

    int bestIndex = 0;
    int minDistance = _fastDistanceSquared(r, g, b, 0);

    if (minDistance == 0) {
      _addToCache(cacheKey, 0);
      return 0;
    }

    for (int i = 1; i < numColors; i++) {
      final distance = _fastDistanceSquared(r, g, b, i);
      if (distance == 0) {
        _addToCache(cacheKey, i);
        return i;
      }
      if (distance < minDistance) {
        minDistance = distance;
        bestIndex = i;
      }
    }

    _addToCache(cacheKey, bestIndex);
    return bestIndex;
  }

  @pragma('vm:prefer-inline')
  int _fastDistanceSquared(int r, int g, int b, int paletteIndex) {
    final dr = r - _paletteR[paletteIndex];
    final dg = g - _paletteG[paletteIndex];
    final db = b - _paletteB[paletteIndex];
    return dr * dr + dg * dg + db * db;
  }

  void _addToCache(int key, int value) {
    if (_colorCache.length >= _maxCacheSize) {
      final keysToRemove = _colorCache.keys.take(_maxCacheSize ~/ 4).toList();
      for (final k in keysToRemove) {
        _colorCache.remove(k);
      }
    }
    _colorCache[key] = value;
  }
}
