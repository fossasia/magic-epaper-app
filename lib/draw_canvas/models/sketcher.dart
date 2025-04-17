import 'package:flutter/material.dart';
import 'package:magic_epaper_app/draw_canvas/models/draw_line.dart';

class Sketcher extends CustomPainter {
  final List<DrawnLine> lines;
  Sketcher(this.lines);

  @override
  void paint(Canvas canvas, Size size) {
    for (var line in lines) {
      final paint = Paint()
        ..color = line.color
        ..strokeWidth = line.width
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      for (int i = 0; i < line.path.length - 1; i++) {
        canvas.drawLine(line.path[i], line.path[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Sketcher oldDelegate) => true;
}
