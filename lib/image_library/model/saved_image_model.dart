import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:magicepaperapp/native_canvas/model/canvas_document.dart';
import '../../util/app_logger.dart';

class SavedImage {
  final String id;
  final String name;
  final String filePath;
  final DateTime createdAt;
  final String source;
  final Map<String, dynamic>? metadata;

  SavedImage({
    required this.id,
    required this.name,
    required this.filePath,
    required this.createdAt,
    required this.source,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'filePath': filePath,
      'createdAt': createdAt.toIso8601String(),
      'source': source,
      'metadata': metadata,
    };
  }

  factory SavedImage.fromJson(Map<String, dynamic> json) {
    return SavedImage(
      id: json['id'],
      name: json['name'],
      filePath: json['filePath'],
      createdAt: DateTime.parse(json['createdAt']),
      source: json['source'],
      metadata: json['metadata'],
    );
  }

  Future<Uint8List?> getImageData() async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.readAsBytes();
      }
      return null;
    } catch (e) {
      AppLogger.error('Error reading image file: $e');
      return null;
    }
  }

  bool get hasCanvasDocument => metadata?['canvasDocument'] != null;

  String get imageCacheKey =>
      '$filePath#${metadata?['updatedAt'] ?? createdAt.millisecondsSinceEpoch}';

  Uint8List? get sourceImageBytes {
    final raw = metadata?['sourceImage'];
    return raw is String ? base64Decode(raw) : null;
  }

  CanvasDocument? get canvasDocument {
    final raw = metadata?['canvasDocument'];
    if (raw is Map) {
      return CanvasDocument.fromJson(Map<String, dynamic>.from(raw));
    }
    return null;
  }

  Future<bool> fileExists() async {
    try {
      final file = File(filePath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }
}
