import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/image_library/image_library.dart';
import 'package:magicepaperapp/image_library/widgets/dialogs/storage_permisson_dialog.dart';
import 'package:magicepaperapp/image_library/provider/image_library_provider.dart';
import 'package:magicepaperapp/image_library/services/image_operations_service.dart';
import 'package:magicepaperapp/image_library/widgets/dialogs/image_save_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../util/image_processing/image_processing.dart';

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

  Future<bool> checkPermissionBeforeAction() async {
    if (_hasStoragePermission) return true;

    final granted = await checkAndRequestPermission(
      context,
      colorAccent: colorAccent,
      colorBlack: colorBlack,
    );

    _hasStoragePermission = granted;
    return granted;
  }

  Future<void> saveCurrentImage({
    required List<img.Image> rawImages,
    required int selectedFilterIndex,
    required bool flipHorizontal,
    required bool flipVertical,
    required String currentImageSource,
    required List<ImageProcessingMethod> processingMethods,
    required String modelId,
  }) async {
    if (rawImages.isEmpty) return;

    final hasPermission = await checkPermissionBeforeAction();
    if (!hasPermission) return;

    img.Image finalImg = rawImages[selectedFilterIndex];

    if (flipHorizontal) finalImg = img.flipHorizontal(finalImg);
    if (flipVertical) finalImg = img.flipVertical(finalImg);

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

  Future<void> navigateToImageLibrary() async {
    final hasPermission = await checkPermissionBeforeAction();
    if (!hasPermission) return;

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
    List<ImageProcessingMethod> processingMethods,
    bool flipHorizontal,
    bool flipVertical,
    String modelId,
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
    );
  }

  static Future<bool> checkAndRequestPermission(
    BuildContext context, {
    Color colorAccent = Colors.blue,
    Color colorBlack = Colors.black,
  }) async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return true;
    }
    Permission permission;

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        permission = Permission.photos;
      } else {
        permission = Permission.storage;
      }
    } else if (Platform.isIOS) {
      permission = Permission.photos;
    } else {
      return false;
    }

    var status = await permission.status;
    if (status.isGranted || status.isLimited) return true;

    if (status.isDenied || status.isPermanentlyDenied) {
      if (!context.mounted) return false;

      bool? userAgreed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return StoragePermissionDialog(
            colorAccent: colorAccent,
            colorBlack: colorBlack,
            onGrantPermission: () {
              Navigator.of(dialogContext).pop(true);
            },
            onCancel: () {
              Navigator.of(dialogContext).pop(false);
            },
          );
        },
      );

      if (userAgreed == true) {
        status = await permission.request();

        if (status.isGranted) {
          return true;
        }

        if (status.isPermanentlyDenied && context.mounted) {
          _showSettingsRedirectDialog(context);
        }
      }
    }

    return false;
  }

  static void _showSettingsRedirectDialog(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(appLocalizations.permissionRequired),
        content: Text(appLocalizations.storagePermissionMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(appLocalizations.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: Text(appLocalizations.openSettings),
          ),
        ],
      ),
    );
  }
}
