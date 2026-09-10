import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'canvas_element.dart';
import 'stroke.dart';

class CanvasDocument {
  final int width;
  final int height;
  final Color canvasColor;
  final List<CanvasElement> elements;
  final List<Stroke> strokes;

  const CanvasDocument({
    required this.width,
    required this.height,
    required this.canvasColor,
    required this.elements,
    required this.strokes,
  });

  Map<String, dynamic> toJson() {
    return {
      'version': 1,
      'width': width,
      'height': height,
      'canvasColor': canvasColor.toARGB32(),
      'elements': [
        for (final e in elements)
          if (e.kind != CanvasElementKind.widget) e.toJson(),
      ],
      'strokes': [for (final s in strokes) s.toJson()],
    };
  }

  factory CanvasDocument.fromJson(Map<String, dynamic> json) {
    return CanvasDocument(
      width: json['width'] as int,
      height: json['height'] as int,
      canvasColor: Color(json['canvasColor'] as int),
      elements: [
        for (final e in json['elements'] as List)
          CanvasElement.fromJson(Map<String, dynamic>.from(e as Map)),
      ],
      strokes: [
        for (final s in json['strokes'] as List)
          Stroke.fromJson(Map<String, dynamic>.from(s as Map)),
      ],
    );
  }
}

class CanvasEditorResult {
  final Uint8List png;
  final CanvasDocument document;

  const CanvasEditorResult(this.png, this.document);
}
