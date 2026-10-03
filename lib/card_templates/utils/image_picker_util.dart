import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:magicepaperapp/utils/app_logger.dart';
import 'package:magicepaperapp/view/image_crop_screen.dart';
import 'package:magicepaperapp/utils/image_source_picker.dart';
import 'package:path_provider/path_provider.dart';

final ImagePicker _picker = ImagePicker();

Future<File?> pickAndEditImage(BuildContext context) async {
  final source = await chooseImageSource(context);
  if (source == null) return null;

  final picked = await _picker.pickImage(source: source);
  if (picked == null) return null;

  final bytes = await picked.readAsBytes();
  if (!context.mounted) return null;

  final cropped = await showImageCropScreen(context, bytes);
  if (cropped == null) return null;

  final dir = await getTemporaryDirectory();
  await dir.create(recursive: true);
  final outFile = File(
    '${dir.path}/mep_crop_${DateTime.now().microsecondsSinceEpoch}.png',
  );
  await outFile.writeAsBytes(cropped);
  return outFile;
}

Future<void> deleteTemporaryImage(File? image) async {
  if (image == null) return;

  try {
    if (await image.exists()) {
      await image.delete();
    }
  } catch (error, stackTrace) {
    AppLogger.warning(
      'Failed to delete temporary image: ${image.path}',
      error,
      stackTrace,
    );
  }
}
