// lib/model/display_device.dart
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:magic_epaper_app/util/epd/driver/waveform.dart';
import 'package:magic_epaper_app/util/image_processing/image_processing.dart';

typedef TransferProgressCallback = void Function(
    double progress, String status);

abstract class DisplayDevice {
  String get name;
  String get modelId;
  String get imgPath;
  int get width;
  int get height;
  List<Color> get colors;

  List<img.Image Function(img.Image)> get processingMethods;

  Future<void> transfer(
    BuildContext context,
    img.Image image, {
    Waveform? waveform,
  });

  Uint8List _extractEpaperColorFrame(Color color, img.Image orgImage) {
    final image = ImageProcessing.extract(color, orgImage);
    final red = (color.r * 255).toInt();
    final green = (color.g * 255).toInt();
    final blue = (color.b * 255).toInt();
    final colorPixel = img.ColorRgb8(red, green, blue);
    List<int> bytes = List.empty(growable: true);
    int j = 0;
    int byte = 0;

    for (final pixel in image) {
      var bin = pixel.rNormalized -
          colorPixel.rNormalized +
          pixel.gNormalized -
          colorPixel.gNormalized +
          pixel.bNormalized -
          colorPixel.bNormalized;

      if (bin > 0.5) {
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

  List<Uint8List> extractEpaperColorFrames(img.Image orgImage) {
    final retList = <Uint8List>[];
    for (final c in colors) {
      if (c == Colors.white) continue; // skip white
      retList.add(_extractEpaperColorFrame(c, orgImage));
    }
    return retList;
  }

  img.Image extractColorPlaneAsImage(Color color, img.Image orgImage) {
    return ImageProcessing.extract(color, orgImage);
  }
  // TODO: howToAdjust ???
}
