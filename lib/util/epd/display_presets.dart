import 'package:flutter/material.dart';
import 'package:magicepaperapp/theme/colors.dart';

/// A named e-paper display configuration (resolution + color palette) that can
/// be selected in the "Arduino / GxEPD Export" flow (see [ConfigurableEpd]).
///
/// This is the single source of truth for the hardware presets offered to
/// users who want to design an image for a display that isn't natively wired
/// to the Magic ePaper NFC bridge board, but that they intend to drive
/// themselves (for example via the GxEPD/GxEPD2 Arduino library:
/// https://github.com/ZinggJM/GxEPD2). Addresses
/// https://github.com/fossasia/magic-epaper-app/issues/183.
class DisplayPreset {
  final String name;
  final int width;
  final int height;
  final List<Color> colors;

  DisplayPreset({
    required this.name,
    required this.width,
    required this.height,
    required this.colors,
  });

  /// Sentinel preset representing a fully user-defined (non-preset) display.
  static final DisplayPreset custom = DisplayPreset(
    name: 'Custom',
    width: 0,
    height: 0,
    colors: [],
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DisplayPreset &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

/// Known e-paper panels supported by the GxEPD/GxEPD2 Arduino library and
/// commonly available from Waveshare and Good Display, offered as quick-start
/// presets for the Arduino/GxEPD export flow.
///
/// Keep this list as the single place hardware presets are defined so it can
/// be unit tested (see test/display_presets_test.dart) and reused outside of
/// the selection dialog.
final List<DisplayPreset> displayPresets = [
    // --- Waveshare ---
    DisplayPreset(
        name: 'Waveshare 1.54" B/W',
        width: 200,
        height: 200,
        colors: [colorWhite, colorBlack]),
    DisplayPreset(
        name: 'Waveshare 1.54" B/W/R',
        width: 200,
        height: 200,
        colors: [colorWhite, colorBlack, Colors.red]),
    DisplayPreset(
        name: 'Waveshare 2.13" B/W',
        width: 122,
        height: 250,
        colors: [colorWhite, colorBlack]),
    DisplayPreset(
        name: 'Waveshare 2.13" B/W/R',
        width: 104,
        height: 212,
        colors: [colorWhite, colorBlack, Colors.red]),
    DisplayPreset(
        name: 'Waveshare 2.7" B/W',
        width: 176,
        height: 264,
        colors: [colorWhite, colorBlack]),
    DisplayPreset(
        name: 'Waveshare 2.7" B/W/R',
        width: 176,
        height: 264,
        colors: [colorWhite, colorBlack, Colors.red]),
    DisplayPreset(
        name: 'Waveshare 2.9" B/W',
        width: 128,
        height: 296,
        colors: [colorWhite, colorBlack]),
    DisplayPreset(
        name: 'Waveshare 2.9" B/W/Y',
        width: 128,
        height: 296,
        colors: [colorWhite, colorBlack, Colors.yellow]),
    DisplayPreset(
        name: 'Waveshare 4.2" B/W',
        width: 300,
        height: 400,
        colors: [colorWhite, colorBlack]),
    DisplayPreset(
        name: 'Waveshare 4.2" B/W/R',
        width: 300,
        height: 400,
        colors: [colorWhite, colorBlack, Colors.red]),
    DisplayPreset(
        name: 'Waveshare 5.83" B/W',
        width: 480,
        height: 648,
        colors: [colorWhite, colorBlack]),
    DisplayPreset(
        name: 'Waveshare 5.83" B/W/R',
        width: 480,
        height: 648,
        colors: [colorWhite, colorBlack, Colors.red]),
    DisplayPreset(
        name: 'Waveshare 7.5" B/W',
        width: 480,
        height: 800,
        colors: [colorWhite, colorBlack]),
    DisplayPreset(
        name: 'Waveshare 7.5" B/W/R',
        width: 480,
        height: 800,
        colors: [colorWhite, colorBlack, Colors.red]),
    // --- Good Display ---
    DisplayPreset(
        name: 'Good Display 0.97" B/W',
        width: 88,
        height: 184,
        colors: [colorWhite, colorBlack]),
    DisplayPreset(
        name: 'Good Display 0.97" B/W/R',
        width: 88,
        height: 184,
        colors: [colorWhite, colorBlack, Colors.red]),
    DisplayPreset(
        name: 'Good Display 1.54" B/W',
        width: 152,
        height: 152,
        colors: [colorWhite, colorBlack]),
    DisplayPreset(
        name: 'Good Display 1.54" B/W/R/Y',
        width: 152,
        height: 152,
        colors: [colorWhite, colorBlack, Colors.red, Colors.yellow]),
    DisplayPreset(
        name: 'Good Display 2.13" B/W',
        width: 122,
        height: 250,
        colors: [colorWhite, colorBlack]),
    DisplayPreset(
        name: 'Good Display 2.13" B/W/R',
        width: 122,
        height: 250,
        colors: [colorWhite, colorBlack, Colors.red]),
    DisplayPreset(
        name: 'Good Display 2.66" B/W',
        width: 152,
        height: 296,
        colors: [colorWhite, colorBlack]),
    DisplayPreset(
        name: 'Good Display 2.66" B/W/R',
        width: 152,
        height: 296,
        colors: [colorWhite, colorBlack, Colors.red]),
    DisplayPreset(
        name: 'Good Display 2.7" B/W',
        width: 176,
        height: 264,
        colors: [colorWhite, colorBlack]),
    DisplayPreset(
        name: 'Good Display 2.7" B/W/R',
        width: 176,
        height: 264,
        colors: [colorWhite, colorBlack, Colors.red]),
    DisplayPreset(
        name: 'Good Display 2.9" B/W',
        width: 128,
        height: 296,
        colors: [colorWhite, colorBlack]),
    DisplayPreset(
        name: 'Good Display 2.9" B/W/R',
        width: 128,
        height: 296,
        colors: [colorWhite, colorBlack, Colors.red]),
    DisplayPreset(
        name: 'Good Display 4.2" B/W',
        width: 300,
        height: 400,
        colors: [colorWhite, colorBlack]),
    DisplayPreset(
        name: 'Good Display 4.2" B/W/R',
        width: 300,
        height: 400,
        colors: [colorWhite, colorBlack, Colors.red]),
    DisplayPreset(
        name: 'Good Display 5.83" B/W',
        width: 448,
        height: 600,
        colors: [colorWhite, colorBlack]),
    DisplayPreset(
        name: 'Good Display 5.83" B/W/Y',
        width: 448,
        height: 600,
        colors: [colorWhite, colorBlack, Colors.yellow]),
    DisplayPreset(
        name: 'Good Display 7.5" B/W',
        width: 480,
        height: 800,
        colors: [colorWhite, colorBlack]),
    DisplayPreset(
        name: 'Good Display 7.5" B/W/R',
        width: 480,
        height: 800,
        colors: [colorWhite, colorBlack, Colors.red]),
    DisplayPreset(
        name: 'Good Display 10.2" B/W',
        width: 640,
        height: 960,
        colors: [colorWhite, colorBlack]),
    DisplayPreset(
        name: 'Good Display 10.2" B/W/R',
        width: 640,
        height: 960,
        colors: [colorWhite, colorBlack, Colors.red]),
    DisplayPreset(
        name: 'Good Display 12.48" B/W',
        width: 984,
        height: 1304,
        colors: [colorWhite, colorBlack]),
    DisplayPreset(
        name: 'Good Display 12.48" B/W/R',
        width: 984,
        height: 1304,
        colors: [colorWhite, colorBlack, Colors.red]),
    DisplayPreset(
        name: 'Good Display 13.3" B/W',
        width: 680,
        height: 960,
        colors: [colorWhite, colorBlack]),
    DisplayPreset(
        name: 'Good Display 13.3" B/W/R',
        width: 680,
        height: 960,
        colors: [colorWhite, colorBlack, Colors.red]),
    // --- Multicolor / Spectra (6-color) ---
    DisplayPreset(
        name: 'Good Display 4" Multicolor',
        width: 400,
        height: 600,
        colors: [
          colorWhite,
          colorBlack,
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.yellow
        ]),
    DisplayPreset(
        name: 'Good Display 7.3" Spectra',
        width: 480,
        height: 800,
        colors: [
          colorWhite,
          colorBlack,
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.yellow
        ]),
    DisplayPreset(
        name: 'Good Display 13.3" Spectra',
        width: 1200,
        height: 1600,
        colors: [
          colorWhite,
          colorBlack,
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.yellow
        ]),
    DisplayPreset(
        name: 'Good Display 31.5" E6',
        width: 1440,
        height: 2560,
        colors: [
          colorWhite,
          colorBlack,
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.yellow
        ]),
    DisplayPreset.custom,
];
