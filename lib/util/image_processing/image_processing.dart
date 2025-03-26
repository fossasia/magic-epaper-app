import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import 'extract_quantizer.dart';
import 'remap_quantizer.dart';

class ImageProcessing {
  final img.Image orgImg;

  ImageProcessing(this.orgImg);

  img.Image binaryDither() {
    var image = img.Image.from(orgImg);
    return img.ditherImage(image, quantizer: img.BinaryQuantizer());
  }

  img.Image halftone() {
    final image = img.Image.from(orgImg);
    img.grayscale(image);
    img.colorHalftone(image);
    return img.ditherImage(image, quantizer: img.BinaryQuantizer());
  }

  img.Image colorHalftone() {
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

  img.Image rwbTriColorDither() {
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

  img.Image extractRed() {
    var image = img.Image.from(orgImg);

    return img.ditherImage(image,
        quantizer: ExtractQuantizer(toBeExtract: Colors.red, hThres: 80),
        kernel: img.DitherKernel.none);
  }

  img.Image experiment() {
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

  static Uint8List toEpdBitmap(img.Image image) {
    List<int> bytes = List.empty(growable: true);
    int j=0;
    int byte = 0;
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        var bin = image.getPixel(x, y).luminanceNormalized < 0.5 ? 0 : 1;
        if (bin == 1) {
          byte |= 0x80 >> j;
        }

        j++;
        if (j >= 8) {
          bytes.add(byte);
          byte = 0;
          j = 0;
        }
      }
    }

    return Uint8List.fromList(bytes);
  }

  // TODO: this should be in Epd class, toEpdPixels???
  static (Uint8List, Uint8List) toEpdBiColor(img.Image image) {
    List<int> red = List.empty(growable: true);
    List<int> black = List.empty(growable: true);
    int j=0;
    int rbyte = 0xff;
    int bbyte = 0;
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        var p = image.getPixel(x, y);
        num excessRed = 2 * p.rNormalized - p.gNormalized - p.bNormalized;
        if (excessRed >= 0.5) { // red
          rbyte &= ~(0x80 >> j);
          // bbyte |= 0x80 >> j; // to make this b-pixel white
        } else if (p.luminanceNormalized >= 0.5) { // black
          bbyte |= 0x80 >> j;
        }

        j++;
        if (j >= 8) {
          red.add(rbyte);
          black.add(bbyte);
          rbyte = 0xff;
          bbyte = 0;
          j = 0;
        }
      }
    }
    return (Uint8List.fromList(red), Uint8List.fromList(black));
  }
}