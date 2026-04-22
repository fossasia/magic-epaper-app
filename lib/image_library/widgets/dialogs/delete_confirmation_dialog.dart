import 'dart:io';
import 'package:flutter/material.dart';
import 'package:magicepaperapp/image_library/model/saved_image_model.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/view/widget/common_alert_dialog.dart';
import 'package:magicepaperapp/view/widget/common_dialog_button.dart';

AppLocalizations appLocalizations = getIt.get<AppLocalizations>();

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
    return CommonAlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildImagePreview(),
            const SizedBox(height: 20),
            _buildWarningMessage(),
            const SizedBox(height: 24),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.delete_outline, color: Colors.red, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appLocalizations.deleteImage,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                appLocalizations.thisActionCannotBeUndone,
                style: const TextStyle(
                  fontSize: 14,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(File(image.filePath), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            image.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          if (image.metadata != null && image.metadata!['filter'] != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${appLocalizations.filterLabel} ${image.metadata!['filter']}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_outlined,
              color: Colors.amber.shade700, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              appLocalizations.areYouSureDeleteImage,
              style: TextStyle(
                fontSize: 14,
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
          child: CommonDialogButton(
            onPressed: () => Navigator.pop(context),
            variant: DialogButtonVariant.secondary,
            label: appLocalizations.cancel,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CommonDialogButton(
            onPressed: onConfirm,
            variant: DialogButtonVariant.danger,
            icon: Icons.delete_forever,
            label: appLocalizations.delete,
          ),
        ),
      ],
    );
  }
}
