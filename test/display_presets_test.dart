// Tests for the GxEPD/Arduino export display presets.
//
// These lock in the data integrity of lib/util/epd/display_presets.dart,
// which is the hardware preset list backing the "Arduino / GxEPD Export"
// feature that addresses
// https://github.com/fossasia/magic-epaper-app/issues/183.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magicepaperapp/theme/colors.dart';
import 'package:magicepaperapp/util/epd/display_presets.dart';

void main() {
  group('displayPresets', () {
    test('is not empty and always ends with the custom sentinel', () {
      expect(displayPresets, isNotEmpty);
      expect(displayPresets.last, same(DisplayPreset.custom));
    });

    test('every non-custom preset has positive dimensions', () {
      for (final preset in displayPresets) {
        if (preset == DisplayPreset.custom) continue;
        expect(preset.width, greaterThan(0),
            reason: '${preset.name} must have a positive width');
        expect(preset.height, greaterThan(0),
            reason: '${preset.name} must have a positive height');
      }
    });

    test('every non-custom preset defines at least black and white', () {
      for (final preset in displayPresets) {
        if (preset == DisplayPreset.custom) continue;
        expect(preset.colors.length, greaterThanOrEqualTo(2),
            reason: '${preset.name} must have at least 2 colors');
        expect(preset.colors, contains(colorWhite),
            reason: '${preset.name} must include white');
        expect(preset.colors, contains(colorBlack),
            reason: '${preset.name} must include black');
      }
    });

    test('every non-custom preset has a non-empty, unique name', () {
      final names = <String>{};
      for (final preset in displayPresets) {
        if (preset == DisplayPreset.custom) continue;
        expect(preset.name, isNotEmpty);
        expect(names.add(preset.name), isTrue,
            reason: 'Duplicate preset name: ${preset.name}');
      }
    });

    test('DisplayPreset equality and hashing are based on name only', () {
      final a = DisplayPreset(
        name: 'Test Panel',
        width: 100,
        height: 100,
        colors: const [Colors.white, Colors.black],
      );
      final b = DisplayPreset(
        name: 'Test Panel',
        width: 999,
        height: 999,
        colors: const [Colors.white],
      );
      final c = DisplayPreset(
        name: 'Different Panel',
        width: 100,
        height: 100,
        colors: const [Colors.white, Colors.black],
      );

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
      expect(a, isNot(equals(c)));
    });

    test('custom sentinel is a zero-size, colorless placeholder', () {
      expect(DisplayPreset.custom.width, 0);
      expect(DisplayPreset.custom.height, 0);
      expect(DisplayPreset.custom.colors, isEmpty);
    });

    test('includes coverage for monochrome and multi-color panels', () {
      final hasMonochrome =
          displayPresets.any((p) => p != DisplayPreset.custom && p.colors.length == 2);
      final hasThreeColor =
          displayPresets.any((p) => p.colors.length == 3);
      final hasMultiColor =
          displayPresets.any((p) => p.colors.length > 3);

      expect(hasMonochrome, isTrue,
          reason: 'Expected at least one 2-color (B/W) preset');
      expect(hasThreeColor, isTrue,
          reason: 'Expected at least one 3-color (B/W/R) preset');
      expect(hasMultiColor, isTrue,
          reason: 'Expected at least one multi-color (Spectra-style) preset');
    });
  });
}
