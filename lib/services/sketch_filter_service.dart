import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import '../src/rust/api/simple.dart' as rust_api;

class SketchFilterService {
  static String? _cachedModelPath;

  static Future<String> _getModelPath() async {
    if (_cachedModelPath != null && await File(_cachedModelPath!).exists()) {
      return _cachedModelPath!;
    }
    final appDir = await getApplicationDocumentsDirectory();
    final modelFile = File('${appDir.path}/line_art_int8.onnx');
    if (!await modelFile.exists()) {
      final byteData = await rootBundle.load('assets/model/line_art_int8.onnx');
      await modelFile.writeAsBytes(
        byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
      );
    }
    _cachedModelPath = modelFile.path;
    return _cachedModelPath!;
  }

  static Future<Uint8List> generateSketch({
    required Uint8List imageBytes,
    required int targetWidth,
    required int targetHeight,
  }) async {
    final modelPath = await _getModelPath();
    return rust_api.applySketchFilterRust(
      imageBytes: imageBytes,
      modelPath: modelPath,
      targetWidth: targetWidth,
      targetHeight: targetHeight,
    );
  }
}
