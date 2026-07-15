import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/src/rust/api/simple.dart';

class ImageProcessingMethod {
  final DitherMethod method;
  final bool isBwr;
  final bool useDartHalftone;
  final bool is4Color;
  const ImageProcessingMethod(this.method, this.isBwr,
      {this.useDartHalftone = false, this.is4Color = false});
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

  static const bwrHalftone =
      ImageProcessingMethod(DitherMethod.halftone, true, useDartHalftone: true);

  static const bwryFloydSteinbergDither =
      ImageProcessingMethod(DitherMethod.floydSteinberg, true, is4Color: true);
  static const bwryFalseFloydSteinbergDither = ImageProcessingMethod(
      DitherMethod.falseFloydSteinberg, true,
      is4Color: true);
  static const bwryStuckiDither =
      ImageProcessingMethod(DitherMethod.stucki, true, is4Color: true);
  static const bwryAtkinsonDither =
      ImageProcessingMethod(DitherMethod.atkinson, true, is4Color: true);
  static const bwryThreshold =
      ImageProcessingMethod(DitherMethod.threshold, true, is4Color: true);

  static const List<List<int>> fourColorPalette = [
    [0, 0, 0],
    [255, 255, 255],
    [255, 0, 0],
    [255, 255, 0],
  ];

  static img.Image fourColorDither(
    img.Image src,
    DitherMethod method,
    int width,
    int height,
  ) {
    final resized = (src.width == width && src.height == height)
        ? img.Image.from(src)
        : img.copyResize(src, width: width, height: height);
    final out = img.Image(width: width, height: height);

    final buffer = List<double>.filled(width * height * 3, 0);
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final p = resized.getPixel(x, y);
        final i = (y * width + x) * 3;
        buffer[i] = p.r.toDouble();
        buffer[i + 1] = p.g.toDouble();
        buffer[i + 2] = p.b.toDouble();
      }
    }

    final kernel = _diffusionKernel(method);

    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final i = (y * width + x) * 3;
        var r = buffer[i];
        var g = buffer[i + 1];
        var b = buffer[i + 2];

        final nearest = _nearestPaletteColor(r, g, b);
        out.setPixelRgb(x, y, nearest[0], nearest[1], nearest[2]);

        if (kernel != null) {
          final er = r - nearest[0];
          final eg = g - nearest[1];
          final eb = b - nearest[2];
          for (final w in kernel.weights) {
            final nx = x + w[0];
            final ny = y + w[1];
            if (nx < 0 || nx >= width || ny < 0 || ny >= height) continue;
            final ni = (ny * width + nx) * 3;
            final factor = w[2] / kernel.divisor;
            buffer[ni] += er * factor;
            buffer[ni + 1] += eg * factor;
            buffer[ni + 2] += eb * factor;
          }
        }
      }
    }

    return out;
  }

  static List<int> _nearestPaletteColor(double r, double g, double b) {
    var best = fourColorPalette.first;
    var bestDist = double.infinity;
    for (final c in fourColorPalette) {
      final dr = r - c[0];
      final dg = g - c[1];
      final db = b - c[2];
      final dist = dr * dr + dg * dg + db * db;
      if (dist < bestDist) {
        bestDist = dist;
        best = c;
      }
    }
    return best;
  }

  static _DiffusionKernel? _diffusionKernel(DitherMethod method) {
    switch (method) {
      case DitherMethod.floydSteinberg:
        return const _DiffusionKernel(16, [
          [1, 0, 7],
          [-1, 1, 3],
          [0, 1, 5],
          [1, 1, 1],
        ]);
      case DitherMethod.falseFloydSteinberg:
        return const _DiffusionKernel(8, [
          [1, 0, 3],
          [0, 1, 3],
          [1, 1, 2],
        ]);
      case DitherMethod.stucki:
        return const _DiffusionKernel(42, [
          [1, 0, 8],
          [2, 0, 4],
          [-2, 1, 2],
          [-1, 1, 4],
          [0, 1, 8],
          [1, 1, 4],
          [2, 1, 2],
          [-2, 2, 1],
          [-1, 2, 2],
          [0, 2, 4],
          [1, 2, 2],
          [2, 2, 1],
        ]);
      case DitherMethod.atkinson:
        return const _DiffusionKernel(8, [
          [1, 0, 1],
          [2, 0, 1],
          [-1, 1, 1],
          [0, 1, 1],
          [1, 1, 1],
          [0, 2, 1],
        ]);
      case DitherMethod.threshold:
      case DitherMethod.halftone:
      case DitherMethod.bayer:
        return null;
    }
  }

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

class _DiffusionKernel {
  final int divisor;

  /// Each entry is `[dx, dy, weight]`.
  final List<List<int>> weights;
  const _DiffusionKernel(this.divisor, this.weights);
}
