import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/src/rust/api/simple.dart';

class ImageProcessingMethod {
  final DitherMethod method;
  final bool isBwr;
  final bool useDartHalftone;
  const ImageProcessingMethod(this.method, this.isBwr,
      {this.useDartHalftone = false});
}

class ImageProcessing {
  static const bwFloydSteinbergDither =
      ImageProcessingMethod(DitherMethod.floydSteinberg, false);
  static const bwFalseFloydSteinbergDither =
      ImageProcessingMethod(DitherMethod.falseFloydSteinberg, false);
  static const bwStuckiDither =
      ImageProcessingMethod(DitherMethod.stucki, false);
  static const bwAtkinsonDither =
      ImageProcessingMethod(DitherMethod.atkinson, false);
  static const bwThreshold =
      ImageProcessingMethod(DitherMethod.threshold, false);
  static const bwBayerDither = ImageProcessingMethod(DitherMethod.bayer, false);
  static const bwBurkesDither =
      ImageProcessingMethod(DitherMethod.burkes, false);

  static const bwHalftoneDither = ImageProcessingMethod(
      DitherMethod.halftone, false,
      useDartHalftone: true);

  static const bwrFloydSteinbergDither =
      ImageProcessingMethod(DitherMethod.floydSteinberg, true);
  static const bwrFalseFloydSteinbergDither =
      ImageProcessingMethod(DitherMethod.falseFloydSteinberg, true);
  static const bwrStuckiDither =
      ImageProcessingMethod(DitherMethod.stucki, true);
  static const bwrTriColorAtkinsonDither =
      ImageProcessingMethod(DitherMethod.atkinson, true);
  static const bwrThreshold =
      ImageProcessingMethod(DitherMethod.threshold, true);
  static const bwrBayerDither = ImageProcessingMethod(DitherMethod.bayer, true);
  static const bwrBurkesDither =
      ImageProcessingMethod(DitherMethod.burkes, true);

  static const bwrHalftone =
      ImageProcessingMethod(DitherMethod.halftone, true, useDartHalftone: true);

  static img.Image extract(Color toBeExtract, img.Image orgImg) {
    var image = img.Image.from(orgImg);
    for (var p in image) {
      final rDiff = (p.r - toBeExtract.r * 255).abs();
      final gDiff = (p.g - toBeExtract.g * 255).abs();
      final bDiff = (p.b - toBeExtract.b * 255).abs();

      final isMatch = rDiff < 80 && gDiff < 80 && bDiff < 80;
      p.r = isMatch ? 0 : 255;
      p.g = isMatch ? 0 : 255;
      p.b = isMatch ? 0 : 255;
    }
    return image;
  }
}
