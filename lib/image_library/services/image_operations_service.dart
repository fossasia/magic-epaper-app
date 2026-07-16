import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/image_library/services/image_filter_helper.dart';
import 'package:magicepaperapp/image_library/model/image_properties.dart';
import 'package:magicepaperapp/image_library/model/saved_image_model.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/image_library/provider/image_library_provider.dart';
import 'package:magicepaperapp/image_library/utils/epd_utils.dart';
import 'package:magicepaperapp/util/epd/display_device.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import '../../util/app_logger.dart';
import '../../util/image_processing/image_processing.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

class ImageOperationsService {
  final BuildContext context;

  ImageOperationsService(this.context);

  DisplayDevice getEpdFromImage(SavedImage image) {
    return EpdUtils.getEpdFromMetadata(image.metadata);
  }

  Future<void> renameImage(
    SavedImage image,
    String newName,
    ImageLibraryProvider provider,
  ) async {
    if (newName.trim().isEmpty) return;

    try {
      _showLoadingSnackBar(appLocalizations.renamingImage);
      await provider.renameImage(image.id, newName.trim());
      _showSuccessSnackBar(
          '${appLocalizations.imageRenamedTo}${newName.trim()}"');
    } catch (e) {
      _showErrorSnackBar(
          '${appLocalizations.failedToRenameImage}${e.toString()}');
    }
  }

  Future<void> deleteImage(
      SavedImage image, ImageLibraryProvider provider) async {
    try {
      Navigator.pop(context);
      _showLoadingSnackBar(appLocalizations.deletingImage(1));
      await provider.deleteImage(image.id);
      _showDeleteSuccessSnackBar(
          '${appLocalizations.imageDeleted}${image.name}${appLocalizations.deleted}');
    } catch (e) {
      _showErrorSnackBar(
        appLocalizations.failedToDeleteImage(1, e.toString()),
      );
    }
  }

  Future<void> clearAllData(ImageLibraryProvider provider) async {
    try {
      Navigator.pop(context);
      _showClearAllLoadingSnackBar();
      await provider.clearAllData();
      _showClearAllSuccessSnackBar();
    } catch (e) {
      _showErrorSnackBar(
          '${appLocalizations.failedToClearAllData}: ${e.toString()}');
    }
  }

  void _showClearAllSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle,
                color: colorWhite, size: Dimens.iconSizeM),
            const SizedBox(width: Dimens.spacingM),
            Text(appLocalizations.allDataCleared),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.radiusL)),
      ),
    );
  }

  void _showClearAllLoadingSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(colorWhite),
              ),
            ),
            const SizedBox(width: Dimens.spacingM),
            Text(appLocalizations.clearingAllData),
          ],
        ),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> batchDeleteImages(
    List<SavedImage> selectedImages,
    ImageLibraryProvider provider,
  ) async {
    try {
      Navigator.pop(context);

      final count = selectedImages.length;
      _showBatchLoadingSnackBar(count);

      for (final image in selectedImages) {
        await provider.deleteImage(image.id);
      }

      _showBatchDeleteSuccessSnackBar(count);
    } catch (e) {
      _showErrorSnackBar(
        appLocalizations.failedToDeleteImage(
            selectedImages.length, e.toString()),
      );
    }
  }

  Future<void> saveImageWithFeedback(
    String imageName,
    Uint8List imageData,
    ImageLibraryProvider provider,
    String currentImageSource,
    int selectedFilterIndex,
    List<ImageProcessingMethod> processingMethods,
    bool flipHorizontal,
    bool flipVertical,
    String epdModelId,
  ) async {
    try {
      _showSaveLoadingSnackBar();

      await provider.saveImage(
        name: imageName,
        imageData: imageData,
        source: currentImageSource,
        metadata: {
          'filter':
              getFilterNameByIndex(selectedFilterIndex, processingMethods),
          'flipHorizontal': flipHorizontal,
          'flipVertical': flipVertical,
          'epdModel': epdModelId,
        },
      );

      _showSaveSuccessSnackBar();
    } catch (e) {
      _showSaveErrorSnackBar(e.toString());
    }
  }

  String getFilterNameByIndex(
      int index, List<ImageProcessingMethod> processingMethods) {
    return ImageFilterHelper.getFilterNameByIndex(index, processingMethods);
  }

  Future<void> transferSingleImage(SavedImage image) async {
    try {
      final imageEpd = getEpdFromImage(image);
      final imageData = await image.getImageData();
      if (imageData == null) {
        _showErrorSnackBar(
            '${appLocalizations.failedToLoadImageData}${image.name}"');
        return;
      }
      final decodedImage = img.decodeImage(imageData);
      if (decodedImage != null) {
        if (!context.mounted) return;
        imageEpd.transfer(
          context,
          decodedImage,
        );
      } else {
        _showErrorSnackBar(
            '${appLocalizations.failedToDecodeImage}${image.name}"');
      }
    } catch (e) {
      _showErrorSnackBar(
          '${appLocalizations.failedToTransfer}${image.name}": ${e.toString()}');
    }
  }

  Future<ImageProperties?> loadImageProperties(SavedImage image) async {
    try {
      final file = File(image.filePath);
      if (!await file.exists()) {
        return null;
      }
      final fileStat = await file.stat();
      final fileSize = await file.length();
      final imageData = await file.readAsBytes();
      final codec = await ui.instantiateImageCodec(imageData);
      final frame = await codec.getNextFrame();
      final imageFrame = frame.image;
      final extension = image.filePath.split('.').last.toLowerCase();
      String format;
      switch (extension) {
        case 'jpg':
        case 'jpeg':
          format = 'JPEG';
          break;
        case 'png':
          format = 'PNG';
          break;
        case 'bmp':
          format = 'BMP';
          break;
        case 'webp':
          format = 'WebP';
          break;
        default:
          format = extension.toUpperCase();
      }
      final properties = ImageProperties(
        fileSizeBytes: fileSize,
        width: imageFrame.width,
        height: imageFrame.height,
        format: format,
        aspectRatio: imageFrame.width / imageFrame.height,
        lastModified: fileStat.modified,
        filePath: image.filePath,
      );
      imageFrame.dispose();
      return properties;
    } catch (e) {
      AppLogger.error('Error loading image properties: $e');
      return null;
    }
  }

  void _showLoadingSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(colorWhite),
              ),
            ),
            const SizedBox(width: Dimens.spacingM),
            Text(message),
          ],
        ),
        backgroundColor: colorAccent,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle,
                color: colorWhite, size: Dimens.iconSizeM),
            const SizedBox(width: Dimens.spacingM),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.radiusL)),
      ),
    );
  }

  void _showDeleteSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.delete_sweep,
                color: colorWhite, size: Dimens.iconSizeM),
            const SizedBox(width: Dimens.spacingM),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.radiusL)),
      ),
    );
  }

  void _showBatchLoadingSnackBar(int count) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(colorWhite),
              ),
            ),
            const SizedBox(width: Dimens.spacingM),
            Text(
              appLocalizations.deletingImage(count),
            )
          ],
        ),
        backgroundColor: Colors.amber,
        duration: Duration(seconds: count > 5 ? 3 : 2),
      ),
    );
  }

  void _showBatchDeleteSuccessSnackBar(int count) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.delete_sweep,
                color: colorWhite, size: Dimens.iconSizeM),
            const SizedBox(width: Dimens.spacingM),
            Expanded(
              child: Text(
                appLocalizations.imageDeletedSuccessfully(count),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.radiusL)),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: colorWhite, size: Dimens.iconSizeM),
            const SizedBox(width: Dimens.spacingM),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.radiusL)),
      ),
    );
  }

  void _showSaveLoadingSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(colorWhite),
              ),
            ),
            const SizedBox(width: Dimens.spacingM),
            Text(appLocalizations.savingImage),
          ],
        ),
        backgroundColor: colorAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSaveSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: colorWhite,
              size: Dimens.iconSizeM,
            ),
            const SizedBox(width: Dimens.spacingM),
            Text(appLocalizations.imageSavedToLibrary),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusL),
        ),
      ),
    );
  }

  void _showSaveErrorSnackBar(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error,
              color: colorWhite,
              size: Dimens.iconSizeM,
            ),
            const SizedBox(width: Dimens.spacingM),
            Expanded(child: Text(appLocalizations.failedToSaveImage(error))),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.radiusL),
        ),
      ),
    );
  }
}
