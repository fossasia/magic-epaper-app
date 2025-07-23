import 'package:flutter/material.dart';

/// A utility class for color-related operations and mappings.
class ColorUtils {
  /// A mapping from [Color] objects to their display names.
  static final Map<Color, String> _colorMap = {
    Colors.black: 'Black',
    Colors.white: 'White',
    Colors.red: 'Red',
    Colors.yellow: 'Yellow',
    Colors.orange: 'Orange',
    Colors.green: 'Green',
    Colors.blue: 'Blue',
  };

  /// Compares two [Color] objects for equality based on their ARGB values.
  ///
  /// Returns `true` if both colors have the same ARGB value, otherwise `false`.
  static bool colorsEqual(Color a, Color b) {
    return a.toARGB32() == b.toARGB32();
  }

  /// Checks if a given [color] exists within the provided [colorList].
  ///
  /// Returns `true` if the color is found in the list, otherwise `false`.
  static bool colorExistsInList(Color color, List<Color> colorList) {
    return colorList.any((c) => colorsEqual(c, color));
  }

  /// Returns a user-friendly display name for the given [color].
  ///
  /// If the color is not found in the predefined color map, returns 'Color'.
  static String getColorDisplayName(Color color) {
    for (final entry in _colorMap.entries) {
      if (colorsEqual(entry.key, color)) {
        return entry.value;
      }
    }
    return 'Color';
  }

  /// Returns a file-friendly name for the given [color], used in exports.
  ///
  /// If the color is not a predefined one, returns its ARGB value as a hex string.
  static String getColorFileName(Color color) {
    if (colorsEqual(color, Colors.black)) return 'black';
    if (colorsEqual(color, Colors.red)) return 'red';
    if (colorsEqual(color, Colors.yellow)) return 'yellow';
    if (colorsEqual(color, Colors.blue)) return 'blue';
    if (colorsEqual(color, Colors.green)) return 'green';
    if (colorsEqual(color, Colors.orange)) return 'orange';
    return color.toARGB32().toRadixString(16);
  }

  /// Returns a label for the given [color], using available color choices as fallback.
  ///
  /// If the color is not a predefined one, checks [availableColorChoices] for a matching label.
  /// If no match is found, returns 'Color'.
  static String getColorLabel(
      Color color, List<dynamic> availableColorChoices) {
    final displayName = getColorDisplayName(color);
    if (displayName != 'Color') return displayName;

    for (final choice in availableColorChoices) {
      if (colorsEqual(choice.color, color)) {
        return choice.label;
      }
    }

    return 'Color';
  }

  static bool colorListsEqual(List<Color> a, List<Color> b) {
    if (a.length != b.length) return false;
    final aValues = a.map((c) => c.value).toSet();
    final bValues = b.map((c) => c.value).toSet();
    return aValues.difference(bValues).isEmpty;
  }
}
