import 'package:flutter/material.dart';
import 'package:magic_epaper_app/view/widget/image_list.dart';
import 'package:provider/provider.dart';

import 'package:magic_epaper_app/util/image_processing/image_processing.dart';
import 'package:magic_epaper_app/util/nfc_handler.dart';
import 'package:magic_epaper_app/provider/image_loader.dart';
import 'package:magic_epaper_app/util/epd/edp.dart';

class ImageEditor extends StatelessWidget {
  final Epd epd;
  const ImageEditor({super.key, required this.epd});

  @override
  Widget build(BuildContext context) {
  var imgLoader = context.watch<ImageLoader>();
  final imgList = ImageList(epd: epd);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Image'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              imgLoader.pickImage(width: epd.width, height: epd.height);
            },
            child: const Text("Import Image"),
          ),
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imgList,

            Expanded(child:Container()),

            ElevatedButton(
              onPressed: () {
                final (red, black) = ImageProcessing.toEpdBiColor(imgList.processedImgs[1]);
                Protocol(epd: epd).writeImage(red, black);
              },
              child: const Text('Start Transfer'),
            ),
          ],
        )
      ),

    );
  }
}
