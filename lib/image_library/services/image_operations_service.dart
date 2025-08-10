import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:magicepaperapp/image_library/services/image_filter_helper.dart';
import 'package:magicepaperapp/image_library/model/image_properties.dart';
import 'package:magicepaperapp/image_library/model/saved_image_model.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/image_library/provider/image_library_provider.dart';
import 'package:magicepaperapp/image_library/utils/epd_utils.dart';
import 'package:magicepaperapp/util/epd/epd.dart';
import 'package:magicepaperapp/util/protocol.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';

class ImageOperationsService {
  final BuildContext context;

  ImageOperationsService(this.context);

  Epd getEpdFromImage(SavedImage image) {
    return EpdUtils.getEpdFromMetadata(image.metadata);
  }

  Future<void> renameImage(
    SavedImage image,
    String newName,
    ImageLibraryProvider provider,
  ) async {
    if (newName.trim().isEmpty) return;

    try {
      _showLoadingSnackBar('Renaming image...');
      await provider.renameImage(image.id, newName.trim());
      _showSuccessSnackBar('Image renamed to "${newName.trim()}"');
    } catch (e) {
      _showErrorSnackBar('Failed to rename image: ${e.toString()}');
    }
  }

  Future<void> deleteImage(
      SavedImage image, ImageLibraryProvider provider) async {
    try {
      Navigator.pop(context);
      _showLoadingSnackBar('Deleting image...');
      await provider.deleteImage(image.id);
      _showDeleteSuccessSnackBar('Image "${image.name}" deleted');
    } catch (e) {
      _showErrorSnackBar('Failed to delete image: ${e.toString()}');
    }
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
      _showErrorSnackBar('Failed to delete images: ${e.toString()}');
    }
  }

  Future<void> saveImageWithFeedback(
    String imageName,
    Uint8List imageData,
    ImageLibraryProvider provider,
    String currentImageSource,
    int selectedFilterIndex,
    List<Function> processingMethods,
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

  String getFilterNameByIndex(int index, List<Function> processingMethods) {
    return ImageFilterHelper.getFilterNameByIndex(index, processingMethods);
  }

  Future<void> transferSingleImage(SavedImage image) async {
    try {
      final imageEpd = getEpdFromImage(image);
      final imageData = await image.getImageData();
      if (imageData == null) {
        _showErrorSnackBar('Failed to load image data for "${image.name}"');
        return;
      }
      final decodedImage = img.decodeImage(imageData);
      if (decodedImage != null) {
        final rotatedImage = img.copyRotate(decodedImage, angle: -90);
        Protocol(epd: imageEpd).writeImages(rotatedImage);
      } else {
        _showErrorSnackBar('Failed to decode image "${image.name}"');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to transfer "${image.name}": ${e.toString()}');
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
      debugPrint('Error loading image properties: $e');
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
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 12),
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
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showDeleteSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.delete_sweep, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Text('Deleting $count image${count > 1 ? 's' : ''}...'),
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
            const Icon(Icons.delete_sweep, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                count > 1
                    ? '$count images deleted successfully'
                    : 'Image deleted successfully',
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSaveLoadingSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            const Text('Saving image...'),
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
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            const Text('Image saved to library!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
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
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text('Failed to save image: $error')),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
