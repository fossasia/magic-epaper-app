import 'package:flutter/material.dart';
import 'package:magicepaperapp/native_canvas/model/canvas_element.dart';
import 'package:magicepaperapp/native_canvas/widgets/editable_element.dart';

class BadgeCanvasView extends StatelessWidget {
  const BadgeCanvasView({
    super.key,
    required this.width,
    required this.height,
    required this.canvasColor,
    required this.elements,
  });

  final int width;
  final int height;
  final Color canvasColor;
  final List<CanvasElement> elements;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.toDouble(),
      height: height.toDouble(),
      child: Stack(
        children: [
          Positioned.fill(child: ColoredBox(color: canvasColor)),
          for (final element in elements) _buildElement(element),
        ],
      ),
    );
  }

  Widget _buildElement(CanvasElement element) {
    final w = element.baseSize.width * element.scale;
    final h = element.baseSize.height * element.scale;
    final cx = element.position.dx;
    final cy = element.position.dy;
    return Positioned(
      left: cx - w / 2,
      top: cy - h / 2,
      width: w,
      height: h,
      child: Transform.rotate(
        angle: element.rotation,
        child: CanvasElementContent(element: element),
      ),
    );
  }
}
