import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/image_library/image_library.dart';
import 'package:magicepaperapp/image_library/widgets/dialogs/storage_permisson_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:magicepaperapp/image_library/provider/image_library_provider.dart';
import 'package:magicepaperapp/image_library/services/image_operations_service.dart';
import 'package:magicepaperapp/image_library/widgets/dialogs/image_save_dialog.dart';
import '../../util/app_logger.dart';

class ImageSaveHandler {
  final BuildContext context;
  final ImageLibraryProvider provider;
  final ImageOperationsService imageOpsService;
  bool _hasStoragePermission = false;

  ImageSaveHandler({
    required this.context,
    required this.provider,
  }) : imageOpsService = ImageOperationsService(context);

  bool get hasStoragePermission => _hasStoragePermission;

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
    final hasPermission = await checkPermissionBeforeAction();
    if (!hasPermission) {
      return;
    }

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

  Future<bool> requestStoragePermission() async {
    try {
      var status = await Permission.storage.status;
      if (status.isGranted) {
        _hasStoragePermission = true;
        return true;
      }
      if (await Permission.manageExternalStorage.status.isGranted) {
        _hasStoragePermission = true;
        return true;
      }
      if (status.isDenied) {
        status = await Permission.storage.request();
      }
      if (status.isDenied || status.isPermanentlyDenied) {
        final manageStorageStatus =
            await Permission.manageExternalStorage.request();
        if (manageStorageStatus.isGranted) {
          _hasStoragePermission = true;
          return true;
        }
      }
      _hasStoragePermission = status.isGranted;
      if (!_hasStoragePermission) {
        await _showPermissionDialog();
      }
      return _hasStoragePermission;
    } catch (e) {
      AppLogger.error('Error requesting storage permission: $e');
      _hasStoragePermission = false;
      return false;
    }
  }

  Future<void> _showPermissionDialog() async {
    await StoragePermissionDialog.show(
      context,
      onGrantPermission: () async {
        await requestStoragePermission();
      },
      onCancel: () {
        AppLogger.debug('Storage permission dialog cancelled');
      },
      colorAccent: colorAccent,
      colorBlack: colorBlack,
    );
  }

  Future<bool> checkPermissionBeforeAction() async {
    if (_hasStoragePermission) {
      return true;
    }
    final granted = await requestStoragePermission();
    return granted;
  }

  Future<void> navigateToImageLibrary() async {
    final hasPermission = await checkPermissionBeforeAction();
    if (!hasPermission) {
      return;
    }
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
