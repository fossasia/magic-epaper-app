import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class ExtractQuantizer extends img.Quantizer {
  final img.Palette _palette;
  late final HSVColor _toBeExtract;
  final double hThres, sThres, vThres;

  ExtractQuantizer({
    Color toBeExtract = Colors.red,
    this.hThres = 40,
    this.sThres = 0.5,
    this.vThres = 0.5,
  }) : _palette = img.PaletteUint8(2, 3) {
    _palette.setRgb(0, toBeExtract.red, toBeExtract.green, toBeExtract.blue);
    _palette.setRgb(1, 255, 255, 255);
    _toBeExtract = HSVColor.fromColor(toBeExtract);
  }

  @override
  img.Palette get palette => _palette;

  @override
  img.Color getQuantizedColor(img.Color c) {
    return _isIt(c)
    ? img.ColorRgb8(_palette.getRed(0) as int, _palette.getGreen(0) as int, _palette.getBlue(0) as int)
    : img.ColorRgb8(_palette.getRed(1) as int, _palette.getGreen(1) as int, _palette.getBlue(1) as int);
  } 

  @override
  int getColorIndex(img.Color c) => _isIt(c) ? 0 : 1;

  @override
  int getColorIndexRgb(int r, int g, int b) {
    return _isIt(img.ColorRgb8(r, g, b)) ? 0 : 1;
  }

  bool _inLinearRange(double v, double a, double b) {
    return a <= v && v <= b;
  }

  bool _inAngularRange(double v, double a, double b) {
    return cos((v - a) * (pi / 180)) > cos((b - a) * (pi / 180));
  }

  bool _hsvInRange(HSVColor v, HSVColor a, HSVColor b) {
    return _inAngularRange(v.hue, a.hue, b.hue)
      && _inLinearRange(v.saturation, a.saturation, b.saturation)
      && _inLinearRange(v.value, a.value, b.value);
  }

  bool _hsvColorThreshold(HSVColor v, HSVColor p) {
    final hHalfThres = hThres / 2;
    final sHalfThres = sThres / 2;
    final vHalfThres = vThres / 2;

    final sLower = p.saturation - sHalfThres < 0.0 ? 0.0 : p.saturation - sHalfThres;
    final vLower = p.value - vHalfThres < 0.0 ? 0.0 : p.value - vHalfThres;
    final sUpper = p.saturation + sHalfThres > 1.0 ? 1.0 : p.saturation + sHalfThres;
    final vUpper = p.value + vHalfThres > 1.0 ? 1.0 : p.value + vHalfThres;

    final rangeA = HSVColor.fromAHSV(1, (p.hue - hHalfThres) % 360, sLower, vLower);
    final rangeB = HSVColor.fromAHSV(1, (p.hue + hHalfThres) % 360, sUpper, vUpper);

    return _hsvInRange(v, rangeA, rangeB);

  }

  bool _isIt(img.Color c) {
    final dartColor = Color.fromRGBO(c.r as int, c.g as int, c.b as int, c.aNormalized as double);
    final hsvColor = HSVColor.fromColor(dartColor);

    return _hsvColorThreshold(hsvColor, _toBeExtract);
  }
}