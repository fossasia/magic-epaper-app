import 'dart:typed_data';
import 'package:magicepaperapp/native_canvas/models/canvas_document.dart';
import 'package:magicepaperapp/utils/template_util.dart';

class GeneratedBadge {
  final String name;
  Uint8List bytes;
  final List<LayerSpec> layers;
  CanvasDocument? document;
  GeneratedBadge({
    required this.name,
    required this.bytes,
    required this.layers,
    this.document,
  });
}
