import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:magic_epaper_app/pro_image_editor/features/movable_background_image.dart';
import 'package:magic_epaper_app/view/widget/image_list.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;

import 'package:magic_epaper_app/provider/image_loader.dart';
import 'package:magic_epaper_app/util/epd/epd.dart';
import 'package:magic_epaper_app/constants.dart';

class ImageEditor extends StatelessWidget {
  final Epd epd;
  const ImageEditor({super.key, required this.epd});

  @override
  Widget build(BuildContext context) {
    var imgLoader = context.watch<ImageLoader>();
    final List<img.Image> processedImgs = List.empty(growable: true);
    final orgImg = imgLoader.image;

    if (orgImg != null) {
      final image = img.copyResize(imgLoader.image!,
          width: epd.width, height: epd.height);
      for (final method in epd.processingMethods) {
        processedImgs.add(method(image));
      }
    }

    final imgList = ImageList(
      imgList: processedImgs,
      epd: epd,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: colorAccent,
        elevation: 0,
        title: const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Select Your Filter',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        toolbarHeight: 85,
        actions: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                imgLoader.pickImage(width: epd.width, height: epd.height);
              },
              child: const Text(
                "Import Image",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final canvasBytes = await Navigator.of(context).push<Uint8List>(
                MaterialPageRoute(
                  builder: (context) => const MovableBackgroundImageExample(),
                ),
              );
              imgLoader.updateImage(
                bytes: canvasBytes!,
                width: epd.width,
                height: epd.height,
              );
            },
            child: const Text("Open Editor"),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: imgList,
        ),
      ),
    );
  }
}
