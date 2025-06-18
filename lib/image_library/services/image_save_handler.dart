import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:magic_epaper_app/image_library/provider/image_library_provider.dart';
import 'package:magic_epaper_app/image_library/services/image_operations_service.dart';
import 'package:magic_epaper_app/image_library/widgets/dialogs/image_save_dialog.dart';

class ImageSaveHandler {
  final BuildContext context;
  final ImageLibraryProvider provider;
  final ImageOperationsService imageOpsService;

  ImageSaveHandler({
    required this.context,
    required this.provider,
  }) : imageOpsService = ImageOperationsService(context);

  Future<void> saveCurrentImage({
    required List<img.Image> rawImages,
    required int selectedFilterIndex,
    required bool flipHorizontal,
    required bool flipVertical,
    required String currentImageSource,
    required List<Function> processingMethods,
    required String modelId,
  }) async {
    if (rawImages.isEmpty) return;

    img.Image finalImg = rawImages[selectedFilterIndex];

    if (flipHorizontal) {
      finalImg = img.flipHorizontal(finalImg);
    }
    if (flipVertical) {
      finalImg = img.flipVertical(finalImg);
    }

    final pngBytes = Uint8List.fromList(img.encodePng(finalImg));

    _showSaveDialog(
      pngBytes,
      selectedFilterIndex,
      currentImageSource,
      processingMethods,
      flipHorizontal,
      flipVertical,
      modelId,
    );
  }

  void _showSaveDialog(
    Uint8List imageData,
    int selectedFilterIndex,
    String currentImageSource,
    List<Function> processingMethods,
    bool flipHorizontal,
    bool flipVertical,
    String modelId,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ImageSaveDialog(
        imageData: imageData,
        filterName: imageOpsService.getFilterNameByIndex(
          selectedFilterIndex,
          processingMethods,
        ),
        onSave: (imageName) => _performSave(
          imageName,
          imageData,
          currentImageSource,
          selectedFilterIndex,
          processingMethods,
          flipHorizontal,
          flipVertical,
          modelId,
        ),
      ),
    );
  }

  Future<void> _performSave(
    String imageName,
    Uint8List imageData,
    String currentImageSource,
    int selectedFilterIndex,
    List<Function> processingMethods,
    bool flipHorizontal,
    bool flipVertical,
    String modelId,
  ) async {
    Navigator.pop(context);

    await imageOpsService.saveImageWithFeedback(
      imageName,
      imageData,
      provider,
      currentImageSource,
      selectedFilterIndex,
      processingMethods,
      flipHorizontal,
      flipVertical,
      modelId,
    );
  }
}
