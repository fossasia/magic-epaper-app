import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart'; // For Canvas and related classes

class ImageHandler {
  img.Image? image;

  // Load raster image (PNG, JPEG, etc.)
  Future<void> loadRaster(String assetPath) async {
    final imgBin = await rootBundle.load(assetPath);
    final Uint8List byteArray = imgBin.buffer.asUint8List();
    image = img.decodeImage(byteArray)!;
  }

  // Load SVG image
  Future<void> loadSVG(String assetPath) async {
    final pictureInfo = await _loadSvgPicture(assetPath);
    final image = await _convertPictureToImage(pictureInfo);
    this.image = image;
  }

  Future<ui.Picture> _loadSvgPicture(String assetPath) async {
    final svgString = await rootBundle.loadString(assetPath);
    final drawableRoot = await svg.fromSvgString(svgString, svgString);
    final picture = drawableRoot.toPicture();
    return picture;
  }

  Future<img.Image> _convertPictureToImage(ui.Picture picture, {int width = 500, int height = 500}) async {
    final image = await picture.toImage(width, height);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();
    return img.decodeImage(pngBytes)!;
  }

  Uint8List toEpdBitmap() {
    final imgArray = image?.buffer.asUint8List();
    List<int> bytes = List.empty(growable: true);
    int j = 0;
    int byte = 0;
    for (int i = 3; i < imgArray!.length; i += 4) {
      double gray = (0.299 * imgArray[i - 3] + 0.587 * imgArray[i - 2] + 0.114 * imgArray[i - 1]);
      if (gray >= 127) {
        byte |= 0x80 >> j;
      }

      j++;
      if (j >= 8) {
        bytes.add(byte);
        byte = 0;
        j = 0;
      }
    }
    return Uint8List.fromList(bytes);
  }

  (Uint8List, Uint8List) toEpdBiColor() {
    final imgArray = image?.buffer.asUint8List();
    List<int> red = List.empty(growable: true);
    List<int> black = List.empty(growable: true);
    int j = 0;
    int rbyte = 0xff;
    int bbyte = 0;
    for (int i = 3; i < imgArray!.length; i += 4) {
      double gray = (0.299 * imgArray[i - 3] + 0.587 * imgArray[i - 2] + 0.114 * imgArray[i - 1]);
      int excessRed = ((imgArray[i - 3] * 2) - imgArray[i - 2]) - imgArray[i - 1];
      if (excessRed >= 128 + 64) {
        // red
        rbyte &= ~(0x80 >> j);
      } else if (gray >= 128 + 64) {
        // black
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
    return (Uint8List.fromList(red), Uint8List.fromList(black));
  }
}

extension on Svg {
  fromSvgString(String svgString, String svgString2) {}
}

