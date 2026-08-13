import 'dart:io';

import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/image_library/model/saved_image_model.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/theme/colors.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

class SharedDeleteConfirmationDialog extends StatelessWidget {
  final SavedImage? image;
  final List<SavedImage>? selectedImages;
  final VoidCallback onConfirm;
  final bool isBatchDelete;

  const SharedDeleteConfirmationDialog.single({
    super.key,
    required SavedImage image,
    required this.onConfirm,
  })  : image = image,
        selectedImages = null,
        isBatchDelete = false;

  const SharedDeleteConfirmationDialog.batch({
    super.key,
    required List<SavedImage> selectedImages,
    required this.onConfirm,
  })  : image = null,
        selectedImages = selectedImages,
        isBatchDelete = true;

  @override
  Widget build(BuildContext context) {
    final images = isBatchDelete
        ? selectedImages ?? <SavedImage>[]
        : <SavedImage>[
            if (image != null) image!,
          ];

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: Dimens.spacingL,
        vertical: Dimens.spacingXxl,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: Dimens.dialogMaxWidth,
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(Dimens.spacingXxl),
            decoration: BoxDecoration(
              color: colorWhite,
              borderRadius: BorderRadius.circular(Dimens.radiusRound),
              boxShadow: [
                BoxShadow(
                  color: colorBlack.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(images.length),
                const SizedBox(height: Dimens.spacingXxl),
                _buildPreview(images),
                const SizedBox(height: Dimens.spacingXl),
                _buildWarningMessage(images.length),
                const SizedBox(height: Dimens.spacingXxl),
                _buildActionButtons(context, images.length),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(int imageCount) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(Dimens.spacingM),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(Dimens.radiusXl),
          ),
          child: Icon(
            isBatchDelete ? Icons.delete_sweep_outlined : Icons.delete_outline,
            color: Colors.red,
            size: Dimens.iconSizeL,
          ),
        ),
        const SizedBox(width: Dimens.spacingL),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isBatchDelete
                    ? appLocalizations.deleteMultipleImages
                    : appLocalizations.deleteImage,
                style: const TextStyle(
                  fontSize: Dimens.fontSizeXxl,
                  fontWeight: FontWeight.bold,
                  color: colorBlack87,
                ),
              ),
              const SizedBox(height: Dimens.spacingXs),
              Text(
                isBatchDelete
                    ? appLocalizations.imagesSelected(imageCount)
                    : appLocalizations.thisActionCannotBeUndone,
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

  Widget _buildPreview(List<SavedImage> images) {
    if (isBatchDelete) {
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
            if (images.isNotEmpty)
              Wrap(
                alignment: WrapAlignment.center,
                spacing: Dimens.spacingS,
                runSpacing: Dimens.spacingS,
                children: [
                  ...images.take(3).map(
                        (image) => Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimens.radiusM),
                            border: Border.all(
                              color: Colors.red.withValues(alpha: 0.3),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimens.radiusM),
                            child: Image.file(
                              File(image.filePath),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                  if (images.length > 3)
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: grey500.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(Dimens.radiusM),
                        border: Border.all(
                          color: grey500.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '+${images.length - 3}',
                          style: const TextStyle(
                            fontSize: Dimens.fontSizeM,
                            fontWeight: FontWeight.bold,
                            color: grey500,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            const SizedBox(height: Dimens.spacingM),
            Text(
              appLocalizations.imagesSelectedForDeletion(images.length),
              style: const TextStyle(
                fontSize: Dimens.fontSizeL,
                fontWeight: FontWeight.w600,
                color: colorBlack87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final currentImage = image;
    if (currentImage == null) {
      return const SizedBox.shrink();
    }

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
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimens.radiusXl),
              border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimens.radiusXl),
              child: Image.file(File(currentImage.filePath), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: Dimens.spacingM),
          Text(
            currentImage.name,
            style: const TextStyle(
              fontSize: Dimens.fontSizeL,
              fontWeight: FontWeight.w600,
              color: colorBlack87,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: Dimens.spacingXs),
          if (currentImage.metadata != null &&
              currentImage.metadata!['filter'] != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.spacingS,
                vertical: Dimens.spacingXs,
              ),
              decoration: BoxDecoration(
                color: grey500.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(Dimens.radiusXl),
              ),
              child: Text(
                '${appLocalizations.filterLabel} ${currentImage.metadata!['filter']}',
                style: const TextStyle(
                  fontSize: Dimens.fontSizeS,
                  color: grey500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWarningMessage(int imageCount) {
    return Container(
      padding: const EdgeInsets.all(Dimens.spacingL),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Dimens.radiusXl),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_outlined,
            color: Colors.amber.shade700,
            size: Dimens.iconSizeM,
          ),
          const SizedBox(width: Dimens.spacingM),
          Expanded(
            child: Text(
              isBatchDelete
                  ? (imageCount > 1
                      ? appLocalizations
                          .areYouSureDeleteMultipleImages(imageCount)
                      : appLocalizations.areYouSureDeleteSingleImage)
                  : appLocalizations.areYouSureDeleteImage,
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

  Widget _buildActionButtons(BuildContext context, int imageCount) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              appLocalizations.cancel,
              style: const TextStyle(
                fontSize: Dimens.fontSizeL,
                fontWeight: FontWeight.w600,
              ),
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
                  isBatchDelete
                      ? (imageCount > 1
                          ? appLocalizations.deleteAll
                          : appLocalizations.delete)
                      : appLocalizations.delete,
                  style: const TextStyle(
                    fontSize: Dimens.fontSizeL,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
