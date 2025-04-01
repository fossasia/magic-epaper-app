import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageLoader extends ChangeNotifier {
  img.Image? image;
  final List<img.Image> processedImgs = List.empty(growable: true);

  void pickImage({required int width, required int height}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: CropAspectRatio(ratioX: width.toDouble(), ratioY: height.toDouble()),
    );
    if (croppedFile == null) return;

    processedImgs.clear();
    image = await img.decodeImageFile(croppedFile.path);

    notifyListeners();
  }
}