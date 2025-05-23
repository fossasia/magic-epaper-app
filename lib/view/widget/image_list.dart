import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:magic_epaper_app/util/epd/epd.dart';
import 'package:magic_epaper_app/util/protocol.dart';
import 'package:magic_epaper_app/util/image_processing/image_processing.dart';
import 'package:magic_epaper_app/constants.dart';

class ImageList extends StatefulWidget {
  final List<img.Image> imgList;
  final Epd epd;

  @override
  const ImageList({super.key, required this.imgList, required this.epd});

  @override
  State<StatefulWidget> createState() => _ImageList();
}

class _ImageList extends State<ImageList> {
  int imgSelection = 0;

  Map<Function, String> getFilterName() {
    return {
      ImageProcessing.bwFloydSteinbergDither: 'Floyd-Steinberg',
      ImageProcessing.bwFalseFloydSteinbergDither: 'False Floyd-Steinberg',
      ImageProcessing.bwStuckiDither: 'Stucki',
      ImageProcessing.bwAtkinsonDither: 'Atkinson',
      ImageProcessing.bwNoDither: 'None',
      ImageProcessing.bwHalftoneDither: 'Halftone',
      ImageProcessing.bwrHalftone: 'Color Halftone',
      ImageProcessing.bwrFloydSteinbergDither: 'BWR Floyd-Steinberg',
      ImageProcessing.bwrFalseFloydSteinbergDither: 'BWR False Floyd-Steinberg',
      ImageProcessing.bwrStuckiDither: 'BWR Stucki',
      ImageProcessing.bwrTriColorAtkinsonDither: 'BWR Atkinson',
      ImageProcessing.bwrNoDither: 'None'
    };
  }

  String getFilterNameByIndex(int index) {
    var methods = widget.epd.processingMethods;
    if (index < 0 || index >= methods.length) return "Unknown";

    var filterMap = getFilterName();
    return filterMap[methods[index]] ?? "Unknown";
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> imgWidgets = List.empty(growable: true);
    List<Widget> filterCards = List.empty(growable: true);

    if (widget.imgList.isEmpty) {
      return const Center(
        child: Text(
          "Please import an image to continue!",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      );
    }

    for (var i = 0; i < widget.imgList.length; i++) {
      var rotatedImg = img.copyRotate(widget.imgList[i], angle: 90);
      var uiImage = Image.memory(
        img.encodePng(rotatedImg),
        height: 100,
        isAntiAlias: false,
      );
      imgWidgets.add(uiImage);

      filterCards.add(
        GestureDetector(
          onTap: () {
            setState(() {
              imgSelection = i;
            });
          },
          child: Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            elevation: imgSelection == i ? 3 : 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: imgSelection == i ? colorPrimary : Colors.grey.shade300,
                width: imgSelection == i ? 2 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        getFilterNameByIndex(i),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color:
                              imgSelection == i ? colorPrimary : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: imgWidgets[i],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget previewWidget = Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 12.0, bottom: 8.0),
          child: Text(
            "Preview",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: imgSelection < imgWidgets.length
              ? Image.memory(
                  img.encodePng(
                      img.copyRotate(widget.imgList[imgSelection], angle: 90)),
                  fit: BoxFit.contain,
                )
              : const Center(child: Text("No filter selected")),
        ),
        const SizedBox(height: 16),
        const Divider(),
      ],
    );

    return Stack(
      children: [
        Column(
          children: [
            previewWidget,
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 80),
                children: filterCards,
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  Protocol(epd: widget.epd)
                      .writeImages(widget.imgList[imgSelection]);
                },
                child: const Text(
                  'Start Transfer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
