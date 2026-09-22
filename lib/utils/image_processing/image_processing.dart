import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/src/rust/api/simple.dart';

class ImageProcessingMethod {
  final DitherMethod method;
  final ColorMode colorMode;
  final bool useDartHalftone;
  const ImageProcessingMethod(this.method, this.colorMode,
      {this.useDartHalftone = false});
}

class ImageProcessing {
  static const bwFloydSteinbergDither =
      ImageProcessingMethod(DitherMethod.floydSteinberg, ColorMode.bw);
  static const bwFalseFloydSteinbergDither =
      ImageProcessingMethod(DitherMethod.falseFloydSteinberg, ColorMode.bw);
  static const bwStuckiDither =
      ImageProcessingMethod(DitherMethod.stucki, ColorMode.bw);
  static const bwAtkinsonDither =
      ImageProcessingMethod(DitherMethod.atkinson, ColorMode.bw);
  static const bwThreshold =
      ImageProcessingMethod(DitherMethod.threshold, ColorMode.bw);
  static const bwBayerDither =
      ImageProcessingMethod(DitherMethod.bayer, ColorMode.bw);
  static const bwSierra2Dither =
      ImageProcessingMethod(DitherMethod.sierra2, ColorMode.bw);
  static const bwBurkesDither =
      ImageProcessingMethod(DitherMethod.burkes, ColorMode.bw);
  static const bwHalftoneDither = ImageProcessingMethod(
      DitherMethod.halftone, ColorMode.bw,
      useDartHalftone: true);

  static const bwrFloydSteinbergDither =
      ImageProcessingMethod(DitherMethod.floydSteinberg, ColorMode.bwr);
  static const bwrFalseFloydSteinbergDither =
      ImageProcessingMethod(DitherMethod.falseFloydSteinberg, ColorMode.bwr);
  static const bwrStuckiDither =
      ImageProcessingMethod(DitherMethod.stucki, ColorMode.bwr);
  static const bwrTriColorAtkinsonDither =
      ImageProcessingMethod(DitherMethod.atkinson, ColorMode.bwr);
  static const bwrThreshold =
      ImageProcessingMethod(DitherMethod.threshold, ColorMode.bwr);
  static const bwrBayerDither =
      ImageProcessingMethod(DitherMethod.bayer, ColorMode.bwr);
  static const bwrSierra2Dither =
      ImageProcessingMethod(DitherMethod.sierra2, ColorMode.bwr);
  static const bwrBurkesDither =
      ImageProcessingMethod(DitherMethod.burkes, ColorMode.bwr);
  static const bwrHalftone = ImageProcessingMethod(
      DitherMethod.halftone, ColorMode.bwr,
      useDartHalftone: true);

  static const bwryFloydSteinbergDither =
      ImageProcessingMethod(DitherMethod.floydSteinberg, ColorMode.bwry);
  static const bwryFalseFloydSteinbergDither =
      ImageProcessingMethod(DitherMethod.falseFloydSteinberg, ColorMode.bwry);
  static const bwryStuckiDither =
      ImageProcessingMethod(DitherMethod.stucki, ColorMode.bwry);
  static const bwryTriColorAtkinsonDither =
      ImageProcessingMethod(DitherMethod.atkinson, ColorMode.bwry);
  static const bwryThreshold =
      ImageProcessingMethod(DitherMethod.threshold, ColorMode.bwry);
  static const bwryBayerDither =
      ImageProcessingMethod(DitherMethod.bayer, ColorMode.bwry);
  static const bwrySierra2Dither =
      ImageProcessingMethod(DitherMethod.sierra2, ColorMode.bwry);
  static const bwryBurkesDither =
      ImageProcessingMethod(DitherMethod.burkes, ColorMode.bwry);
  static const bwryHalftone = ImageProcessingMethod(
      DitherMethod.halftone, ColorMode.bwry,
      useDartHalftone: true);

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
