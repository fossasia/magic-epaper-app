import 'package:flutter/material.dart';

class ColorUtils {
  // Define color mapping
  static final Map<Color, String> _colorMap = {
    Colors.black: 'Black',
    Colors.white: 'White',
    Colors.red: 'Red',
    Colors.yellow: 'Yellow',
    Colors.orange: 'Orange',
    Colors.green: 'Green',
    Colors.blue: 'Blue',
  };

  // Helper method to compare colors without toARGB32
  static bool colorsEqual(Color a, Color b) {
    return a.toARGB32() == b.toARGB32();
  }

  // Helper method to check if a color exists in a list
  static bool colorExistsInList(Color color, List<Color> colorList) {
    return colorList.any((c) => colorsEqual(c, color));
  }

  // Get display name for color (used in UI)
  static String getColorDisplayName(Color color) {
    for (final entry in _colorMap.entries) {
      if (colorsEqual(entry.key, color)) {
        return entry.value;
      }
    }
    return 'Color';
  }

  // Get file name for color (used in exports)
  static String getColorFileName(Color color) {
    if (colorsEqual(color, Colors.black)) return 'black';
    if (colorsEqual(color, Colors.red)) return 'red';
    if (colorsEqual(color, Colors.yellow)) return 'yellow';
    if (colorsEqual(color, Colors.blue)) return 'blue';
    if (colorsEqual(color, Colors.green)) return 'green';
    // Fallback for other colors
    return color.toARGB32().toRadixString(16);
  }

  // Get color label with fallback to available choices
  static String getColorLabel(
      Color color, List<dynamic> availableColorChoices) {
    // Check predefined colors first
    final displayName = getColorDisplayName(color);
    if (displayName != 'Color') return displayName;

    // Check available color choices
    for (final choice in availableColorChoices) {
      if (colorsEqual(choice.color, color)) {
        return choice.label;
      }
    }

    return 'Color';
  }
}
