import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/asset_paths.dart';
import 'package:magicepaperapp/util/epd/driver/driver.dart';
import 'package:magicepaperapp/util/epd/driver/uc8253.dart';
import 'package:magicepaperapp/util/image_processing/image_processing.dart';
import 'package:image/image.dart' as img;
import 'epd.dart';

/// Represents a named image filter for use in e-paper image processing.
///
/// Associates a filter function with a display name for UI and export purposes.
class NamedImageFilter {
  /// The image filter function to apply.
  final img.Image Function(img.Image) filter;

  /// The display name of the filter.
  final String name;

  /// Creates a [NamedImageFilter] with the given [filter] and [name].
  NamedImageFilter(this.filter, this.name);
}

/// A dynamically configurable e-paper display for custom export and processing.
///
/// This class is used to export dithered images and supports:
/// - Changing the color palette for dithering (custom colors)
/// - Setting the height and width of the display
/// - Generating XBM output for custom displays
///
/// It allows users to experiment with different display configurations and image processing methods.
class ConfigurableEpd extends Epd {
  /// The width of the display in pixels.
  @override
  final int width;

  /// The height of the display in pixels.
  @override
  final int height;

  /// The display name for UI and export.
  @override
  final String name;

  /// The list of supported colors for dithering and export.
  @override
  final List<Color> colors;

  /// The model identifier for this configurable export display.
  final String _modelId;
  @override
  String get modelId => _modelId;

  /// The asset path for the display image (custom export icon).
  @override
  String get imgPath => ImageAssets.customExport;

  /// Using a dummy driver as this is only for exporting images.
  @override
  Driver get controller => Uc8253() as Driver;

  /// The list of named image processing methods available for this display.
  final List<NamedImageFilter> namedProcessingMethods = [];

  @override
  List<String> get displayChips =>
      ['Good Display (FOSSASIA Hardware Required)'];

  @override
  List<img.Image Function(img.Image)> get processingMethods =>
      namedProcessingMethods.map((f) => f.filter).toList();

  List<String> get processingMethodNames =>
      namedProcessingMethods.map((f) => f.name).toList();

  /// Creates a [ConfigurableEpd] with the given [width], [height], [colors], and optional [name] and [modelId].
  ///
  /// The color palette and display size can be customized, and dithering methods can be chosen.
  ConfigurableEpd({
    required this.width,
    required this.height,
    required this.colors,
    this.name = 'Arduino Export',
    String modelId = 'NA',
  }) : _modelId = modelId {
    _addProcessingMethods();
  }

  /// Creates a palette for the 'image' library from a list of Flutter [Color]s.
  ///
  /// Used for custom dithering with custom color palettes.
  img.PaletteUint8 _createDynamicPalette() {
    final palette = img.PaletteUint8(colors.length, 3);
    for (int i = 0; i < colors.length; i++) {
      final color = colors[i];
      palette.setRgb(i, (color.r * 255.0).round(), (color.g * 255.0).round(),
          (color.b * 255.0).round());
    }
    return palette;
  }

  /// Populates the list of processing methods based on the color palette.
  void _addProcessingMethods() {
    namedProcessingMethods.clear();
    final isBlackAndWhite = colors.length == 2;
    if (isBlackAndWhite) {
      namedProcessingMethods.add(
        NamedImageFilter(
          ImageProcessing.bwFloydSteinbergDither,
          'Floyd-Steinberg',
        ),
      );
      namedProcessingMethods.add(
        NamedImageFilter(
          ImageProcessing.bwFalseFloydSteinbergDither,
          'False Floyd-Steinberg',
        ),
      );
      namedProcessingMethods.add(
        NamedImageFilter(ImageProcessing.bwStuckiDither, 'Stucki'),
      );
      namedProcessingMethods.add(
        NamedImageFilter(ImageProcessing.bwAtkinsonDither, 'Atkinson'),
      );
      namedProcessingMethods.add(
        NamedImageFilter(ImageProcessing.bwHalftoneDither, 'Halftone'),
      );
      namedProcessingMethods.add(
        NamedImageFilter(ImageProcessing.bwThreshold, 'Threshold'),
      );
    } else {
      final dynamicPalette = _createDynamicPalette();
      namedProcessingMethods.add(
        NamedImageFilter(
          (img.Image orgImg) => ImageProcessing.customFloydSteinbergDither(
            orgImg,
            dynamicPalette,
          ),
          'Floyd-Steinberg',
        ),
      );
      namedProcessingMethods.add(
        NamedImageFilter(
          (img.Image orgImg) => ImageProcessing.customFalseFloydSteinbergDither(
            orgImg,
            dynamicPalette,
          ),
          'False Floyd-Steinberg',
        ),
      );
      namedProcessingMethods.add(
        NamedImageFilter(
          (img.Image orgImg) =>
              ImageProcessing.customStuckiDither(orgImg, dynamicPalette),
          'Stucki',
        ),
      );
      namedProcessingMethods.add(
        NamedImageFilter(
          (img.Image orgImg) =>
              ImageProcessing.customAtkinsonDither(orgImg, dynamicPalette),
          'Atkinson',
        ),
      );
      namedProcessingMethods.add(
        NamedImageFilter(
          (img.Image orgImg) =>
              ImageProcessing.customHalftoneDither(orgImg, dynamicPalette),
          'Halftone',
        ),
      );
      namedProcessingMethods.add(
        NamedImageFilter(
          (img.Image orgImg) =>
              ImageProcessing.customThreshold(orgImg, dynamicPalette),
          'Threshold',
        ),
      );
    }
  }
}
