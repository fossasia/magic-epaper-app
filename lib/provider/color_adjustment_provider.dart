import 'package:flutter/material.dart';

class ColorAdjustmentProvider extends ChangeNotifier {
  Map<Color, double> _weights = {};

  Map<Color, double> get weights => _weights;

  void resetWeights(List<Color> colors) {
    _weights = {for (var color in colors) color: 1.0};
  }

  void updateWeights(Map<Color, double> newWeights) {
    _weights = newWeights;
    notifyListeners();
  }
}
