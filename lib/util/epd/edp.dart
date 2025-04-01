import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'driver/driver.dart';
import 'package:magic_epaper_app/util/image_processing/image_processing.dart';

abstract class Epd {
  int get width;
  int get height;
  final processingMethods = <img.Image Function(img.Image)>[];
  String get description;
  List<Color> get colors;
  Driver get controller;
  
  Uint8List _extractEpaperColorFrame(Color color, img.Image orgImage) {
    final image = ImageProcessing.extract(color, orgImage);
    final colorPixel = img.ColorRgb8(color.red, color.green, color.blue);
    List<int> bytes = List.empty(growable: true);
    int j=0;
    int byte = 0;
    
    for (final pixel in image) {
      var bin = pixel.rNormalized - colorPixel.rNormalized
        + pixel.gNormalized - colorPixel.gNormalized
        + pixel.bNormalized - colorPixel.bNormalized;

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
      if(c == Colors.white) continue; // skip white
      retList.add(_extractEpaperColorFrame(c, orgImage));
    }
    return retList;
  }
  // TODO: howToAdjust ???
}