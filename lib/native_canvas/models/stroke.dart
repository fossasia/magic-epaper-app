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

  Map<String, dynamic> toJson() {
    return {
      'points': [
        for (final p in points) [p.dx, p.dy]
      ],
      'color': color.toARGB32(),
      'width': width,
    };
  }

  factory Stroke.fromJson(Map<String, dynamic> json) {
    return Stroke(
      points: [
        for (final p in json['points'] as List)
          Offset((p[0] as num).toDouble(), (p[1] as num).toDouble()),
      ],
      color: Color(json['color'] as int),
      width: (json['width'] as num).toDouble(),
    );
  }
}
