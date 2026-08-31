import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:magicepaperapp/util/image_crop_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

img.Image? _decodeAndResize(Map<String, dynamic> args) {
  final bytes = args['bytes'] as Uint8List;
  final int width = args['width'] as int;
  final int height = args['height'] as int;
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return null;
  return img.copyResize(decoded, width: width, height: height);
}

class ImageLoader extends ChangeNotifier {
  img.Image? image;
  final List<img.Image> processedImgs = List.empty(growable: true);
  bool isLoading = false;

  Future<bool> pickImage({
    required BuildContext context,
    required int width,
    required int height,
  }) async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: width.toDouble(),
      maxHeight: height.toDouble(),
      imageQuality: 50,
    );
    if (file == null) return false;

    final bytes = await file.readAsBytes();
    if (!context.mounted) return false;

    final cropped = await showImageCropScreen(
      context,
      bytes,
      aspectRatio: width / height,
    );
    if (cropped == null) return false;

    processedImgs.clear();
    image = await compute(_decodeAndResize, {
      'bytes': cropped,
      'width': width,
      'height': height,
    });

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
        image = await compute(_decodeAndResize, {
          'bytes': bytes,
          'width': width,
          'height': height,
        });
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
    image = await compute(_decodeAndResize, {
      'bytes': bytes,
      'width': width,
      'height': height,
    });
    notifyListeners();
  }
}
