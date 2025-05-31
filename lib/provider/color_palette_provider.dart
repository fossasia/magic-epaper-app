import 'package:flutter/material.dart';

class ColorPaletteProvider extends ChangeNotifier {
  List<Color> _colors = [];

  List<Color> get colors => _colors;

  void updateColors(List<Color> newColors) {
    _colors = newColors;
    notifyListeners();
  }
}
