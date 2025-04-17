import 'dart:typed_data';
import 'package:flutter/material.dart';

enum OverlayType { text, image }

class OverlayItem {
  final String id;
  final String type;
  final String? text;
  final Uint8List? imageBytes;
  final Color? color;
  final String font;
  final double fontSize;
  final String? label;
  Offset position;
  double scale;
  double rotation;

  OverlayItem.text({
    required this.text,
    required this.color,
    this.font = 'Roboto',
    this.fontSize = 24.0,
    this.label,
    this.position = const Offset(100, 100),
    this.scale = 1.0,
    this.rotation = 0.0,
  })  : id = UniqueKey().toString(),
        type = 'text',
        imageBytes = null;

  OverlayItem.image({
    required this.imageBytes,
    this.font = 'Roboto',
    this.fontSize = 24.0,
    this.label,
    this.position = const Offset(100, 100),
    this.scale = 1.0,
    this.rotation = 0.0,
  })  : id = UniqueKey().toString(),
        type = 'image',
        text = null,
        color = null;
}
