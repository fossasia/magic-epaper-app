import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';
import 'package:magic_epaper_app/draw_canvas/ImageAdjust/image_adjust_parms.dart';

Uint8List processImage(ImageAdjustParams params) {
  final img.Image adjusted = img.adjustColor(
    params.image.clone(),
    brightness: params.brightness,
    contrast: params.contrast,
  );
  return Uint8List.fromList(img.encodePng(adjusted));
}

img.Image decodeImage(Uint8List bytes) {
  final original = img.decodeImage(bytes)!;
  return img.copyResize(original, width: 512);
}
