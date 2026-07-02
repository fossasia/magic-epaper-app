import 'package:flutter/material.dart';

import '../model/stroke.dart';

class StrokePainter extends CustomPainter {
  final List<Stroke> strokes;
  final double displayScale;

  StrokePainter({required this.strokes, required this.displayScale});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    for (final stroke in strokes) {
      if (stroke.points.isEmpty) continue;
      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.width * displayScale
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      if (stroke.points.length == 1) {
        final p = stroke.points.first * displayScale;
        canvas.drawCircle(
          p,
          (stroke.width * displayScale) / 2,
          Paint()..color = stroke.color,
        );
        continue;
      }

      final path = Path()
        ..moveTo(
          stroke.points.first.dx * displayScale,
          stroke.points.first.dy * displayScale,
        );
      for (var i = 1; i < stroke.points.length; i++) {
        path.lineTo(
          stroke.points[i].dx * displayScale,
          stroke.points[i].dy * displayScale,
        );
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant StrokePainter old) =>
      old.strokes != strokes || old.displayScale != displayScale;
}
