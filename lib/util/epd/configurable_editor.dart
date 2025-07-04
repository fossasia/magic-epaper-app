import 'package:flutter/material.dart';
import 'package:magic_epaper_app/constants/asset_paths.dart';
import 'package:magic_epaper_app/util/epd/driver/driver.dart';
import 'package:magic_epaper_app/util/epd/driver/uc8253.dart';
import 'package:magic_epaper_app/util/image_processing/image_processing.dart';
import 'package:image/image.dart' as img;
import 'epd.dart';

/// Represents a dynamically configurable e-paper display.
///
/// Used for the "Arduino Export Tool" to allow users to specify
/// custom dimensions and color palettes for image processing.
class NamedImageFilter {
  final img.Image Function(img.Image) filter;
  final String name;
  NamedImageFilter(this.filter, this.name);
}

class ConfigurableEpd extends Epd {
  @override
  final int width;

  @override
  final int height;

  @override
  final String name;

  @override
  final List<Color> colors;

  @override
  String get modelId => 'CustomTool';

  @override
  // NOTE: You might want to add a specific asset for this tool.
  String get imgPath => ImageAssets.epaper37Bwr;

  @override
  Driver get controller => Uc8253() as Driver;

  final List<NamedImageFilter> namedProcessingMethods = [];

  @override
  List<img.Image Function(img.Image)> get processingMethods =>
      namedProcessingMethods.map((f) => f.filter).toList();

  List<String> get processingMethodNames =>
      namedProcessingMethods.map((f) => f.name).toList();

  ConfigurableEpd({
    required this.width,
    required this.height,
    required this.colors,
    this.name = 'Custom Export',
  }) {
    _addProcessingMethods();
  }

  /// Creates a palette for the 'image' library from a list of Flutter Colors.
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
  ///
  /// IMPORTANT: This class creates new function instances for dithering.
  /// The current `ImageList` widget identifies filters by their function
  /// reference, so these dynamic filters will be named "Unknown" in the UI.
  /// A future improvement would be to store filter names in the Epd class itself.
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
          'Custom Floyd-Steinberg',
        ),
      );
      namedProcessingMethods.add(
        NamedImageFilter(
          (img.Image orgImg) => ImageProcessing.customFalseFloydSteinbergDither(
            orgImg,
            dynamicPalette,
          ),
          'Custom False Floyd-Steinberg',
        ),
      );
      namedProcessingMethods.add(
        NamedImageFilter(
          (img.Image orgImg) =>
              ImageProcessing.customStuckiDither(orgImg, dynamicPalette),
          'Custom Stucki',
        ),
      );
      namedProcessingMethods.add(
        NamedImageFilter(
          (img.Image orgImg) =>
              ImageProcessing.customAtkinsonDither(orgImg, dynamicPalette),
          'Custom Atkinson',
        ),
      );
      namedProcessingMethods.add(
        NamedImageFilter(
          (img.Image orgImg) =>
              ImageProcessing.customHalftoneDither(orgImg, dynamicPalette),
          'Custom Halftone',
        ),
      );
      namedProcessingMethods.add(
        NamedImageFilter(
          (img.Image orgImg) =>
              ImageProcessing.customThreshold(orgImg, dynamicPalette),
          'Custom Threshold',
        ),
      );
    }
  }
}
