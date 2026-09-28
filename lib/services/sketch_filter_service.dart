import 'dart:io';
import 'package:flutter/services.dart' show Uint8List;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../src/rust/api/simple.dart' as rust_api;

class SketchFilterService {
  static const String _modelUrl =
      'https://huggingface.co/rocca/informative-drawings-line-art-onnx/resolve/main/model.onnx';

  static String? _cachedModelPath;

  static Future<String> _getModelPath(
      {void Function(double)? onDownloadProgress}) async {
    if (_cachedModelPath != null && await File(_cachedModelPath!).exists()) {
      return _cachedModelPath!;
    }

    final dir = await getApplicationDocumentsDirectory();
    final modelFile = File('${dir.path}/line_art_int8.onnx');

    if (!await modelFile.exists()) {
      final client = http.Client();
      try {
        final request = http.Request('GET', Uri.parse(_modelUrl));
        final response = await client.send(request);
        if (response.statusCode != 200) {
          throw Exception(
              'Failed to download sketch model: ${response.statusCode}');
        }
        final total = response.contentLength ?? 0;
        int received = 0;
        final sink = modelFile.openWrite();
        await response.stream.map((chunk) {
          received += chunk.length;
          if (total > 0 && onDownloadProgress != null) {
            onDownloadProgress(received / total);
          }
          return chunk;
        }).pipe(sink);
        await sink.close();
      } finally {
        client.close();
      }
    }

    _cachedModelPath = modelFile.path;
    return _cachedModelPath!;
  }

  static Future<Uint8List> generateSketch({
    required Uint8List imageBytes,
    required int targetWidth,
    required int targetHeight,
    void Function(double)? onDownloadProgress,
  }) async {
    final modelPath =
        await _getModelPath(onDownloadProgress: onDownloadProgress);

    final result = await rust_api.applySketchFilterRust(
      imageBytes: imageBytes,
      modelPath: modelPath,
      targetWidth: targetWidth,
      targetHeight: targetHeight,
    );

    return result;
  }
}
