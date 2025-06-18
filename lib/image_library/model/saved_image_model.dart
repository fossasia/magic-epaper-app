import 'dart:typed_data';
import 'dart:convert';

class SavedImage {
  final String id;
  final String name;
  final Uint8List imageData;
  final DateTime createdAt;
  final String source;
  final Map<String, dynamic>? metadata;

  SavedImage({
    required this.id,
    required this.name,
    required this.imageData,
    required this.createdAt,
    required this.source,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageData': base64Encode(imageData),
      'createdAt': createdAt.toIso8601String(),
      'source': source,
      'metadata': metadata,
    };
  }

  factory SavedImage.fromJson(Map<String, dynamic> json) {
    Uint8List imageData;
    final imageDataJson = json['imageData'];

    if (imageDataJson is String) {
      imageData = base64Decode(imageDataJson);
    } else if (imageDataJson is List) {
      print("this method");

      imageData = Uint8List.fromList(List<int>.from(imageDataJson));
    } else {
      throw FormatException('Invalid imageData format');
    }

    return SavedImage(
      id: json['id'],
      name: json['name'],
      imageData: imageData,
      createdAt: DateTime.parse(json['createdAt']),
      source: json['source'],
      metadata: json['metadata'],
    );
  }
}
