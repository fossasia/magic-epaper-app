import 'dart:ui';
import 'package:image/image.dart' as img;
import 'package:magic_epaper_app/util/epd/epd.dart';

List<img.Image> processImages({
  required img.Image originalImage,
  required Epd epd,
  required Map<Color, double> weights,
}) {
  final List<img.Image> processedImgs = [];

  img.Image transformed = img.copyResize(
    originalImage,
    width: epd.width,
    height: epd.height,
  );

  for (final method in epd.processingMethods) {
    processedImgs.add(method(transformed, weights));
  }

  return processedImgs;
}
