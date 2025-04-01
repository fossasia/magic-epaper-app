import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import 'extract_quantizer.dart';
import 'remap_quantizer.dart';

class ImageProcessing {
  static img.Image binaryDither(img.Image orgImg) {
    var image = img.Image.from(orgImg);
    return img.ditherImage(image, quantizer: img.BinaryQuantizer());
  }

  static img.Image halftone(img.Image orgImg) {
    final image = img.Image.from(orgImg);
    img.grayscale(image);
    img.colorHalftone(image);
    return img.ditherImage(image, quantizer: img.BinaryQuantizer());
  }

  static img.Image colorHalftone(img.Image orgImg) {
    var image = img.Image.from(orgImg);

    // Tri-color palette
    final palette = img.PaletteUint8(3, 3);
    palette.setRgb(0, 255, 0, 0); // red
    palette.setRgb(1, 0, 0, 0); // black
    palette.setRgb(2, 255, 255, 255); // white

    img.colorHalftone(image);
    return img.ditherImage(image,
        quantizer: RemapQuantizer(palette: palette),
        kernel: img.DitherKernel.floydSteinberg);
  }

  static img.Image rwbTriColorDither(img.Image orgImg) {
    var image = img.Image.from(orgImg);

    // Tri-color palette
    final palette = img.PaletteUint8(3, 3);
    palette.setRgb(0, 255, 0, 0); // red
    palette.setRgb(1, 0, 0, 0); // black
    palette.setRgb(2, 255, 255, 255); // white

    return img.ditherImage(image,
        quantizer: RemapQuantizer(palette: palette),
        kernel: img.DitherKernel.floydSteinberg);
  }

  static img.Image extract(Color toBeExtract, img.Image orgImg) {
    var image = img.Image.from(orgImg);

    return img.ditherImage(image,
        quantizer: ExtractQuantizer(toBeExtract: toBeExtract, hThres: 80),
        kernel: img.DitherKernel.none);
  }

  static img.Image experiment(img.Image orgImg) {
    var image = img.Image.from(orgImg);

    // Tri-color palette
    final palette = img.PaletteUint8(3, 3);
    palette.setRgb(0, 255, 0, 0); // red
    palette.setRgb(1, 0, 0, 0); // black
    palette.setRgb(2, 255, 255, 255); // white

    return img.ditherImage(image,
        quantizer: RemapQuantizer(palette: palette),
        kernel: img.DitherKernel.none);
  }
}