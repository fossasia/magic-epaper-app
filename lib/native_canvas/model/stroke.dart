import 'package:flutter/material.dart';

class Stroke {
  final List<Offset> points;
  final Color color;
  final double width;

  const Stroke({
    required this.points,
    required this.color,
    required this.width,
  });

  Stroke addPoint(Offset point) => Stroke(
        points: [...points, point],
        color: color,
        width: width,
      );
}
