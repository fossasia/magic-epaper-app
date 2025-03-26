import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:magic_epaper_app/provider/load_image.dart';

class EditImage extends StatelessWidget {
  const EditImage({super.key});

  @override
  Widget build(BuildContext context) {
  var imgLoader = context.watch<ImageLoader>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Image'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              imgLoader.pickImage(width: 240, height: 416); // TODO: change these constants to the selected display size once it's implemented
            },
            child: const Text("Import Image"),
          ),
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              // child: Image(image: image, height: 100, isAntiAlias: false,),
              child: imgLoader.orgCroppedImg,
            ),
            Container(
              child:  imgLoader.processedImgs,
            ),

            Expanded(child:Container()),

            ElevatedButton(
              onPressed: () {
                imgLoader.writeToNfc();
              },
              child: const Text('Start Transfer'),
            ),
          ],
        )
      ),

    );
  }
}
