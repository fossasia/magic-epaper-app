import 'dart:math';
import 'package:flutter/material.dart';
import 'package:magic_epaper_app/util/epd/edp.dart';

class DisplayModel {
  final String id;
  final String name;
  final String ModelName; // For future use
  final double size; // Inches
  final int width, height; // Pixels
  final List<Color> colors;
  final String driver;
  final String imagePath;
  final Epd epd;

  // Constructor
  DisplayModel({
    required this.id,
    required this.name,
    required this.size,
    required this.width,
    required this.height,
    required this.colors,
    required this.ModelName,
    required this.driver,
    required this.imagePath,
    required this.epd,
  });

  // Computed properties
  bool get isColor => colors.length > 2; // More than black and white
  bool get isHd => width >= 1280 && height >= 720;
  double get ppi => sqrt(pow(width, 2) + pow(height, 2)) / size;

  // Format aspect ratio
  String get aspectRatio {
    int gcd = _findGCD(width, height);
    return '${width ~/ gcd}:${height ~/ gcd}';
  }

  // Helper method to find GCD for aspect ratio calculation
  int _findGCD(int a, int b) {
    while (b != 0) {
      int t = b;
      b = a % b;
      a = t;
    }
    return a;
  }

  // Get color names as a formatted string
  String get colorNames {
    final List<String> colorNames = [];

    if (colors.contains(Colors.black)) colorNames.add('Black');
    if (colors.contains(Colors.white)) colorNames.add('White');
    if (colors.contains(Colors.red)) colorNames.add('Red');
    if (colors.contains(Colors.yellow)) colorNames.add('Yellow');

    return colorNames.join(', ');
  }

  // Format resolution as a string
  String get resolution => '$width × $height';
}
