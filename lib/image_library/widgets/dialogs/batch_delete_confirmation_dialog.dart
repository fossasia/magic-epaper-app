import 'dart:io';
import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/image_library/model/saved_image_model.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

class BatchDeleteConfirmationDialog extends StatelessWidget {
  final List<SavedImage> selectedImages;
  final VoidCallback onConfirm;

  const BatchDeleteConfirmationDialog({
    super.key,
    required this.selectedImages,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(Dimens.spacingXxl),
          margin: const EdgeInsets.symmetric(vertical: 48),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimens.radiusRound),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: Dimens.spacingXxl),
              _buildImagesPreview(),
              const SizedBox(height: Dimens.spacingXl),
              _buildWarningMessage(),
              const SizedBox(height: Dimens.spacingXxl),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(Dimens.spacingM),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(Dimens.radiusXl),
          ),
          child: const Icon(Icons.delete_sweep_outlined,
              color: Colors.red, size: Dimens.iconSizeL),
        ),
        const SizedBox(width: Dimens.spacingL),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appLocalizations.deleteMultipleImages,
                style: const TextStyle(
                  fontSize: Dimens.fontSizeXxl,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: Dimens.spacingXs),
              Text(
                appLocalizations.imagesSelected(selectedImages.length),
                style: const TextStyle(
                  fontSize: Dimens.fontSizeM,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImagesPreview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimens.spacingL),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(Dimens.radiusXxl),
        border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          if (selectedImages.isNotEmpty)
            SizedBox(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...selectedImages.take(3).map(
                        (image) => Container(
                          margin: const EdgeInsets.only(right: Dimens.spacingS),
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimens.radiusM),
                            border: Border.all(
                                color: Colors.red.withValues(alpha: 0.3)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimens.radiusM),
                            child: Image.file(File(image.filePath),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                  if (selectedImages.length > 3)
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(Dimens.radiusM),
                        border: Border.all(
                            color: Colors.grey.withValues(alpha: 0.3)),
                      ),
                      child: Center(
                        child: Text(
                          '+${selectedImages.length - 3}',
                          style: const TextStyle(
                            fontSize: Dimens.fontSizeM,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          const SizedBox(height: Dimens.spacingM),
          Text(
            appLocalizations.imagesSelectedForDeletion(selectedImages.length),
            style: const TextStyle(
              fontSize: Dimens.fontSizeL,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWarningMessage() {
    return Container(
      padding: const EdgeInsets.all(Dimens.spacingL),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Dimens.radiusXl),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_outlined,
              color: Colors.amber.shade700, size: Dimens.iconSizeM),
          const SizedBox(width: Dimens.spacingM),
          Expanded(
            child: Text(
              selectedImages.length > 1
                  ? 'Are you sure you want to delete these ${selectedImages.length} images? This action cannot be undone.'
                  : appLocalizations.areYouSureDeleteSingleImage,
              style: TextStyle(
                fontSize: Dimens.fontSizeM,
                color: Colors.amber.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              appLocalizations.cancel,
              style: const TextStyle(
                  fontSize: Dimens.fontSizeL, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: Dimens.spacingM),
        Expanded(
          child: ElevatedButton(
            onPressed: onConfirm,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.delete_forever, size: Dimens.iconSizeM),
                const SizedBox(width: Dimens.spacingS),
                Text(
                  selectedImages.length > 1
                      ? appLocalizations.deleteAll
                      : appLocalizations.delete,
                  style: const TextStyle(
                      fontSize: Dimens.fontSizeL, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
