import 'dart:typed_data';
import 'package:magicepaperapp/native_canvas/model/canvas_document.dart';
import 'package:magicepaperapp/util/template_util.dart';

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
