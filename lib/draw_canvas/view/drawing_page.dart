import 'package:flutter/material.dart';
import 'package:magic_epaper_app/draw_canvas/helper_functions/helper_functions.dart';
import 'package:magic_epaper_app/draw_canvas/models/draw_line.dart';
import 'package:magic_epaper_app/draw_canvas/models/overlay_item.dart';
import 'package:magic_epaper_app/draw_canvas/models/sketcher.dart';
import 'package:magic_epaper_app/draw_canvas/overlays/image_overlays.dart';
import 'package:magic_epaper_app/draw_canvas/overlays/text_overlays.dart';
import 'package:magic_epaper_app/util/epd/edp.dart';
import 'package:screenshot/screenshot.dart';

class DrawingPage extends StatefulWidget {
  final Epd epd;

  const DrawingPage({Key? key, required this.epd}) : super(key: key);

  @override
  _DrawingPageState createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  List<DrawnLine> lines = [];
  Color selectedColor = Colors.black;
  double strokeWidth = 4.0;
  bool isCapturing = false;
  List<OverlayItem> overlayItems = [];
  final ScreenshotController screenshotController = ScreenshotController();

  void startDrawing(Offset position) {
    setState(() {
      lines.add(DrawnLine([position], selectedColor, strokeWidth));
    });
  }

  void drawUpdate(Offset position) {
    setState(() {
      lines.last.path.add(position);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Magic ePaper Editor",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: () {
              pickImageFromGallery(onImagePicked: (item) {
                setState(() {
                  overlayItems.add(item);
                });
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.text_fields),
            onPressed: () {
              addTextOverlayDialog(
                context: context,
                selectedColor: selectedColor,
                onItemCreated: (item) {
                  setState(() {
                    overlayItems.add(item);
                  });
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: () {
              pickColorDialog(context, selectedColor, (color) {
                setState(() => selectedColor = color);
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              captureAndProcessImage(
                context: context,
                controller: screenshotController,
                epd: widget.epd,
                onCaptureStart: () => setState(() => isCapturing = true),
                onCaptureEnd: () => setState(() => isCapturing = false),
                onImageExported: (adjustedBytes) {
                  Navigator.pop(context, adjustedBytes);
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.layers),
            onPressed: () {
              showLayerManagerModal(
                context: context,
                items: overlayItems,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final item = overlayItems.removeAt(oldIndex);
                    overlayItems.insert(newIndex, item);
                  });
                },
              );
            },
          ),
        ],
      ),
      body: Screenshot(
        controller: screenshotController,
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              GestureDetector(
                onPanStart: (details) => startDrawing(details.localPosition),
                onPanUpdate: (details) => drawUpdate(details.localPosition),
                child: CustomPaint(
                  size: Size.infinite,
                  painter: Sketcher(lines),
                ),
              ),
              for (var item in overlayItems)
                if (item.type == 'text')
                  DraggableResizableText(
                    overlayItem: item,
                    text: item.text!,
                    color: item.color!,
                    isCapturing: isCapturing,
                    font: item.font,
                    fontSize: item.fontSize,
                    onDelete: () {
                      setState(() {
                        overlayItems.removeWhere((e) => e.id == item.id);
                      });
                    },
                  )
                else if (item.type == 'image')
                  DraggableResizableImage(
                    overlayItem: item,
                    imageBytes: item.imageBytes!,
                    isCapturing: isCapturing,
                    onDelete: () {
                      setState(() {
                        overlayItems.removeWhere((e) => e.id == item.id);
                      });
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
