import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';

import 'package:magic_epaper_app/util/epd/edp.dart';
import 'package:magic_epaper_app/provider/image_loader.dart';

class ImageList extends StatelessWidget {
  final Epd epd;
  final List<img.Image> processedImgs = List.empty(growable: true);

  @override
  ImageList({super.key, required this.epd});

  @override
  Widget build(BuildContext context) {
    var imgLoader = context.watch<ImageLoader>();
    List<Widget> imgWidgets = List.empty(growable: true);
    final orgImg = imgLoader.image;

    if (orgImg != null) {
      final image = img.copyResize(orgImg, width: epd.width, height: epd.height);
      var rotatedImg = img.copyRotate(image, angle: 90);
      var uiImage = Image.memory(img.encodePng(rotatedImg), height: 100, isAntiAlias: false);
      imgWidgets.add(uiImage);

      processImg(image);
      for (var i in processedImgs) {
        var rotatedImg = img.copyRotate(i, angle: 90);
        var uiImage = Image.memory(img.encodePng(rotatedImg), height: 100, isAntiAlias: false);
        imgWidgets.add(uiImage);
      }
    } else {
      return const Text("Please import an image to continue!");
    }
    return Wrap(spacing: 10, direction: Axis.vertical, children: imgWidgets);
  }

  void processImg(img.Image image) {
    for (final method in epd.processingMethods) {
      processedImgs.add(method(image));
    }
  }
}