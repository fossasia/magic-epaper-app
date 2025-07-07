import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import 'extract_quantizer.dart';
import 'remap_quantizer.dart';

class ImageProcessing {
  static img.Image bwFloydSteinbergDither(img.Image orgImg) {
    var image = img.Image.from(orgImg);
    return img.ditherImage(image, quantizer: img.BinaryQuantizer());
  }

  static img.Image bwFalseFloydSteinbergDither(img.Image orgImg) {
    var image = img.Image.from(orgImg);
    return img.ditherImage(image,
        quantizer: img.BinaryQuantizer(),
        kernel: img.DitherKernel.falseFloydSteinberg);
  }

  static img.Image bwStuckiDither(img.Image orgImg) {
    var image = img.Image.from(orgImg);
    return img.ditherImage(image,
        quantizer: img.BinaryQuantizer(), kernel: img.DitherKernel.stucki);
  }

  static img.Image bwAtkinsonDither(img.Image orgImg) {
    var image = img.Image.from(orgImg);
    return img.ditherImage(image,
        quantizer: img.BinaryQuantizer(), kernel: img.DitherKernel.atkinson);
  }

  static img.Image bwThreshold(img.Image orgImg) {
    var image = img.Image.from(orgImg);
    return img.ditherImage(image,
        quantizer: img.BinaryQuantizer(), kernel: img.DitherKernel.none);
  }

  static img.Image bwHalftoneDither(img.Image orgImg) {
    final image = img.Image.from(orgImg);
    img.grayscale(image);
    img.colorHalftone(image, size: 3);
    return img.ditherImage(image, quantizer: img.BinaryQuantizer());
  }

  static img.Image bwrHalftone(img.Image orgImg) {
    var image = img.Image.from(orgImg);

    img.colorHalftone(image, size: 3);
    return img.ditherImage(image,
        quantizer: RemapQuantizer(palette: _createTriColorPalette()),
        kernel: img.DitherKernel.floydSteinberg);
  }

  static img.Image bwrFloydSteinbergDither(img.Image orgImg) {
    var image = img.Image.from(orgImg);

    return img.ditherImage(image,
        quantizer: RemapQuantizer(palette: _createTriColorPalette()),
        kernel: img.DitherKernel.floydSteinberg);
  }

  static img.Image bwrFalseFloydSteinbergDither(img.Image orgImg) {
    var image = img.Image.from(orgImg);

    return img.ditherImage(image,
        quantizer: RemapQuantizer(palette: _createTriColorPalette()),
        kernel: img.DitherKernel.falseFloydSteinberg);
  }

  static img.Image bwrStuckiDither(img.Image orgImg) {
    var image = img.Image.from(orgImg);

    return img.ditherImage(image,
        quantizer: RemapQuantizer(palette: _createTriColorPalette()),
        kernel: img.DitherKernel.stucki);
  }

  static img.Image bwrTriColorAtkinsonDither(img.Image orgImg) {
    var image = img.Image.from(orgImg);

    return img.ditherImage(image,
        quantizer: RemapQuantizer(palette: _createTriColorPalette()),
        kernel: img.DitherKernel.atkinson);
  }

  static img.Image extract(Color toBeExtract, img.Image orgImg) {
    var image = img.Image.from(orgImg);

    return img.ditherImage(image,
        quantizer: ExtractQuantizer(toBeExtract: toBeExtract, hThres: 80),
        kernel: img.DitherKernel.none);
  }

  static img.Image bwrThreshold(img.Image orgImg) {
    var image = img.Image.from(orgImg);

    return img.ditherImage(image,
        quantizer: RemapQuantizer(palette: _createTriColorPalette()),
        kernel: img.DitherKernel.none);
  }

  static img.Image customFloydSteinbergDither(
      img.Image orgImg, img.PaletteUint8 palette) {
    var image = img.Image.from(orgImg);
    return img.ditherImage(image,
        quantizer: RemapQuantizer(palette: palette),
        kernel: img.DitherKernel.floydSteinberg);
  }

  static img.Image customFalseFloydSteinbergDither(
      img.Image orgImg, img.PaletteUint8 palette) {
    var image = img.Image.from(orgImg);
    return img.ditherImage(image,
        quantizer: RemapQuantizer(palette: palette),
        kernel: img.DitherKernel.falseFloydSteinberg);
  }

  static img.Image customStuckiDither(
      img.Image orgImg, img.PaletteUint8 palette) {
    var image = img.Image.from(orgImg);
    return img.ditherImage(image,
        quantizer: RemapQuantizer(palette: palette),
        kernel: img.DitherKernel.stucki);
  }

  static img.Image customAtkinsonDither(
      img.Image orgImg, img.PaletteUint8 palette) {
    var image = img.Image.from(orgImg);
    return img.ditherImage(image,
        quantizer: RemapQuantizer(palette: palette),
        kernel: img.DitherKernel.atkinson);
  }

  static img.Image customThreshold(img.Image orgImg, img.PaletteUint8 palette) {
    var image = img.Image.from(orgImg);
    return img.ditherImage(image,
        quantizer: RemapQuantizer(palette: palette),
        kernel: img.DitherKernel.none);
  }

  static img.Image customHalftoneDither(
      img.Image orgImg, img.PaletteUint8 palette) {
    var image = img.Image.from(orgImg);
    img.colorHalftone(image, size: 3);
    return img.ditherImage(image,
        quantizer: RemapQuantizer(palette: palette),
        kernel: img.DitherKernel.floydSteinberg);
  }
}

img.PaletteUint8 _createTriColorPalette() {
  final palette = img.PaletteUint8(3, 3);
  palette.setRgb(0, 255, 0, 0); // red
  palette.setRgb(1, 0, 0, 0); // black
  palette.setRgb(2, 255, 255, 255); // white
  return palette;
}
