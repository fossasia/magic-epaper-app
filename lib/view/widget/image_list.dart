import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:magic_epaper_app/util/epd/edp.dart';
import 'package:magic_epaper_app/util/protocol.dart';

class ImageList extends StatefulWidget {
  final List<img.Image> imgList;
  final Epd epd;

  @override
  const ImageList({super.key, required this.imgList, required this.epd});

  @override
  State<StatefulWidget> createState() => _ImageList();
}

class _ImageList extends State<ImageList> {
  int imgSelection = 1;

  @override
  Widget build(BuildContext context) {
    List<Widget> imgWidgets = List.empty(growable: true);

    if (widget.imgList.isEmpty) {
      return const Text("Please import an image to continue!");
    }

    for (var i in widget.imgList) {
      var rotatedImg = img.copyRotate(i, angle: 90);
      var uiImage = Image.memory(img.encodePng(rotatedImg), height: 100, isAntiAlias: false);
      imgWidgets.add(uiImage);
    }

    return Column(children: [
          for (final w in imgWidgets)
            ListTile(
              title: w,
              leading: Radio(
                value: imgWidgets.indexOf(w),
                groupValue: imgSelection,
                onChanged: (int? value) {
                  setState(() {
                    imgSelection = value!;
                  });
                },
              ),
            ),

            Expanded(child:Container()),

            ElevatedButton(
              onPressed: () {
                Protocol(epd: widget.epd).writeImages(widget.imgList[imgSelection]);
              },
              child: const Text('Start Transfer'),
            )
        ],
    );
  }
}