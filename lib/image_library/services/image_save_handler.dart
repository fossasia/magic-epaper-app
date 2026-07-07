import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/image_library/image_library.dart';
import 'package:magicepaperapp/image_library/provider/image_library_provider.dart';
import 'package:magicepaperapp/image_library/services/image_operations_service.dart';
import 'package:magicepaperapp/image_library/widgets/dialogs/image_save_dialog.dart';
import '../../util/image_processing/image_processing.dart';

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
    required List<ImageProcessingMethod> processingMethods,
    required String modelId,
    required int deviceWidth,
    required int deviceHeight,
    required List<Color> deviceColors,
    Map<String, dynamic>? canvasDocument,
    Uint8List? sourceImage,
    String? existingImageId,
  }) async {
    if (rawImages.isEmpty) return;

    img.Image finalImg = rawImages[selectedFilterIndex];

    if (flipHorizontal) finalImg = img.flipHorizontal(finalImg);
    if (flipVertical) finalImg = img.flipVertical(finalImg);

    final pngBytes = Uint8List.fromList(img.encodePng(finalImg));

    if (existingImageId != null) {
      await imageOpsService.saveImageWithFeedback(
        '',
        pngBytes,
        provider,
        currentImageSource,
        selectedFilterIndex,
        processingMethods,
        flipHorizontal,
        flipVertical,
        modelId,
        deviceWidth: deviceWidth,
        deviceHeight: deviceHeight,
        deviceColors: deviceColors,
        canvasDocument: canvasDocument,
        sourceImage: sourceImage,
        existingImageId: existingImageId,
      );
      return;
    }

    _showSaveDialog(
      pngBytes,
      selectedFilterIndex,
      currentImageSource,
      processingMethods,
      flipHorizontal,
      flipVertical,
      modelId,
      deviceWidth,
      deviceHeight,
      deviceColors,
      canvasDocument,
      sourceImage,
    );
  }

  Future<void> navigateToImageLibrary() async {
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ImageLibraryScreen(),
        ),
      );
    }
  }

  void _showSaveDialog(
    Uint8List imageData,
    int selectedFilterIndex,
    String currentImageSource,
    List<ImageProcessingMethod> processingMethods,
    bool flipHorizontal,
    bool flipVertical,
    String modelId,
    int deviceWidth,
    int deviceHeight,
    List<Color> deviceColors,
    Map<String, dynamic>? canvasDocument,
    Uint8List? sourceImage,
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
          deviceWidth,
          deviceHeight,
          deviceColors,
          canvasDocument,
          sourceImage,
        ),
      ),
    );
  }

  Future<void> _performSave(
    String imageName,
    Uint8List imageData,
    String currentImageSource,
    int selectedFilterIndex,
    List<ImageProcessingMethod> processingMethods,
    bool flipHorizontal,
    bool flipVertical,
    String modelId,
    int deviceWidth,
    int deviceHeight,
    List<Color> deviceColors,
    Map<String, dynamic>? canvasDocument,
    Uint8List? sourceImage,
  ) async {
    if (context.mounted) Navigator.pop(context);

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
      deviceWidth: deviceWidth,
      deviceHeight: deviceHeight,
      deviceColors: deviceColors,
      canvasDocument: canvasDocument,
      sourceImage: sourceImage,
    );
  }
}
