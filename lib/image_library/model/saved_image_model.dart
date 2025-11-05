import 'dart:io';
import 'dart:typed_data';
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

  Future<bool> fileExists() async {
    try {
      final file = File(filePath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }
}
