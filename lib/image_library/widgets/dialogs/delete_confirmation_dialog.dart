import 'dart:io';
import 'package:magicepaperapp/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/image_library/model/saved_image_model.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

class DeleteConfirmationDialog extends StatelessWidget {
  final SavedImage image;
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    super.key,
    required this.image,
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
              _buildHeader(),
              const SizedBox(height: Dimens.spacingXxl),
              _buildImagePreview(),
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
          child: const Icon(Icons.delete_outline,
              color: Colors.red, size: Dimens.iconSizeL),
        ),
        const SizedBox(width: Dimens.spacingL),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appLocalizations.deleteImage,
                style: const TextStyle(
                  fontSize: Dimens.fontSizeXxl,
                  fontWeight: FontWeight.bold,
                  color: colorBlack87,
                ),
              ),
              const SizedBox(height: Dimens.spacingXs),
              Text(
                appLocalizations.thisActionCannotBeUndone,
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

  Widget _buildImagePreview() {
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
              child: Image.file(File(image.filePath), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: Dimens.spacingM),
          Text(
            image.name,
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
          if (image.metadata != null && image.metadata!['filter'] != null)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.spacingS, vertical: Dimens.spacingXs),
              decoration: BoxDecoration(
                color: grey500.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(Dimens.radiusXl),
              ),
              child: Text(
                '${appLocalizations.filterLabel} ${image.metadata!['filter']}',
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
              appLocalizations.areYouSureDeleteImage,
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
                  appLocalizations.delete,
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
