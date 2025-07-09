import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageLoader extends ChangeNotifier {
  img.Image? image;
  final List<img.Image> processedImgs = List.empty(growable: true);
  bool isLoading = false;

  Future<bool> pickImage({required int width, required int height}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return false;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: CropAspectRatio(
        ratioX: width.toDouble(),
        ratioY: height.toDouble(),
      ),
    );
    if (croppedFile == null) return false;

    processedImgs.clear();
    image = await img.decodeImageFile(croppedFile.path);

    notifyListeners();
    return true;
  }

  Future<void> saveFinalizedImageBytes(Uint8List bytes) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(path.join(dir.path, 'last_finalized.png'));
    await file.writeAsBytes(bytes);
  }

  Future<void> loadFinalizedImage({
    required int width,
    required int height,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/last_finalized.png');

      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        final decoded = img.decodeImage(bytes);
        if (decoded != null) {
          final resized = img.copyResize(decoded, width: width, height: height);
          image = resized;
        }
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateImage({
    required Uint8List bytes,
    required int width,
    required int height,
  }) async {
    final decoded = img.decodeImage(bytes);
    if (decoded != null) {
      final resized = img.copyResize(decoded, width: width, height: height);
      image = resized;
      notifyListeners();
    }
  }
}
