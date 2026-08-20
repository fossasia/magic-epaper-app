import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:magicepaperapp/util/image_crop_screen.dart';
import 'package:magicepaperapp/util/image_source_picker.dart';
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
  final outFile = File(
    '${dir.path}/mep_crop_${DateTime.now().microsecondsSinceEpoch}.png',
  );
  await outFile.writeAsBytes(cropped);
  return outFile;
}
