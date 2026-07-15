import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/util/image_source_picker.dart';

final ImagePicker _picker = ImagePicker();

Future<File?> pickAndEditImage(BuildContext context) async {
  final source = await chooseImageSource(context);
  if (source == null) return null;

  final picked = await _picker.pickImage(source: source);
  if (picked == null) return null;

  final cropped = await ImageCropper().cropImage(
    sourcePath: picked.path,
    compressFormat: ImageCompressFormat.png,
    compressQuality: 100,
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Crop',
        toolbarColor: colorAccent,
        toolbarWidgetColor: colorWhite,
        activeControlsWidgetColor: colorAccent,
        backgroundColor: colorBlack,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
        hideBottomControls: false,
      ),
      IOSUiSettings(
        title: 'Crop',
        aspectRatioLockEnabled: false,
        resetAspectRatioEnabled: true,
      ),
    ],
  );

  if (cropped == null) return null;
  return File(cropped.path);
}
