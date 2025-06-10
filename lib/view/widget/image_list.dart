import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:magic_epaper_app/constants/asset_paths.dart';
import 'package:magic_epaper_app/util/epd/epd.dart';
import 'package:magic_epaper_app/util/image_processing/image_processing.dart';
import 'package:magic_epaper_app/constants/color_constants.dart';

class ImageList extends StatefulWidget {
  final List<img.Image> imgList;
  final Epd epd;
  final bool flipHorizontal;
  final bool flipVertical;
  final Function() onFlipHorizontal;
  final Function() onFlipVertical;

  @override
  const ImageList({
    super.key,
    required this.imgList,
    required this.epd,
    required this.flipHorizontal,
    required this.flipVertical,
    required this.onFlipHorizontal,
    required this.onFlipVertical,
  });

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
      ImageProcessing.bwThreshold: 'Threshold',
      ImageProcessing.bwHalftoneDither: 'Halftone',
      ImageProcessing.bwrHalftone: 'Color Halftone',
      ImageProcessing.bwrFloydSteinbergDither: 'BWR Floyd-Steinberg',
      ImageProcessing.bwrFalseFloydSteinbergDither: 'BWR False Floyd-Steinberg',
      ImageProcessing.bwrStuckiDither: 'BWR Stucki',
      ImageProcessing.bwrTriColorAtkinsonDither: 'BWR Atkinson',
      ImageProcessing.bwrThreshold: 'Threshold',
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
      var uiImage = Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..scale(widget.flipHorizontal ? -1.0 : 1.0,
              widget.flipVertical ? -1.0 : 1.0),
        child: Image.memory(
          img.encodePng(rotatedImg),
          height: 100,
          isAntiAlias: false,
        ),
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
            color: colorWhite,
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            elevation: imgSelection == i ? 3 : 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: imgSelection == i ? colorPrimary : mdGrey400,
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
                          color: imgSelection == i ? colorPrimary : colorBlack,
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
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: mdGrey400),
            borderRadius: BorderRadius.circular(8),
          ),
          child: imgSelection < imgWidgets.length
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..scale(widget.flipHorizontal ? -1.0 : 1.0,
                        widget.flipVertical ? -1.0 : 1.0),
                  child: Image.memory(
                    img.encodePng(img.copyRotate(widget.imgList[imgSelection],
                        angle: 90)),
                    fit: BoxFit.contain,
                  ),
                )
              : const Center(child: Text("No filter selected")),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorWhite,
                boxShadow: [
                  BoxShadow(
                    color: colorBlack.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: IconButton(
                icon: Image.asset(
                  ImageAssets.flipHorizontal,
                  height: 24,
                  width: 24,
                ),
                onPressed: widget.onFlipHorizontal,
                tooltip: 'Flip Horizontally',
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorWhite,
                boxShadow: [
                  BoxShadow(
                    color: colorBlack.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: IconButton(
                icon: Transform.rotate(
                  angle: -1.5708,
                  child: Image.asset(
                    ImageAssets.flipHorizontal,
                    height: 24,
                    width: 24,
                  ),
                ),
                onPressed: widget.onFlipVertical,
                tooltip: 'Flip Vertically',
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
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
              color: colorWhite,
              boxShadow: [
                BoxShadow(
                  color: colorBlack.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
