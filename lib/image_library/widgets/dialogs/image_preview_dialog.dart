import 'dart:io';
import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/image_library/model/saved_image_model.dart';
import 'package:magicepaperapp/image_library/utils/date_utils.dart' as dt;
import 'package:magicepaperapp/image_library/utils/filter_utils.dart';
import 'package:magicepaperapp/image_library/utils/source_utils.dart';
import 'package:magicepaperapp/image_library/widgets/dialogs/image_properties_dialog.dart';
import 'package:magicepaperapp/image_library/widgets/dialogs/image_rename_dialog.dart';
import 'package:magicepaperapp/image_library/widgets/image_error_placeholder.dart';
import 'package:magicepaperapp/util/epd/display_device.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

class ImagePreviewDialog extends StatelessWidget {
  final SavedImage image;
  final DisplayDevice epd;
  final VoidCallback onDelete;
  final Function(String) onRename;
  final VoidCallback onTransfer;

  const ImagePreviewDialog({
    super.key,
    required this.image,
    required this.epd,
    required this.onDelete,
    required this.onRename,
    required this.onTransfer,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: colorWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.radiusXxl),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Dimens.spacingM),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildImageContainer(),
                    const SizedBox(height: Dimens.spacingL),
                    _buildImageInfo(),
                    const SizedBox(height: Dimens.spacingXxl),
                    _buildActionButtons(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimens.spacingL),
      decoration: const BoxDecoration(
        color: colorAccent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              image.name,
              style: const TextStyle(
                color: colorWhite,
                fontSize: Dimens.fontSizeXl,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () => _showPropertiesDialog(context),
            icon: const Icon(Icons.info_outline, color: colorWhite),
            tooltip: appLocalizations.imageProperties,
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: colorWhite),
          ),
        ],
      ),
    );
  }

  Widget _buildImageContainer() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(Dimens.radiusM),
          color: Colors.grey.shade50,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimens.radiusM),
          child: Image.file(
            File(image.filePath),
            fit: BoxFit.contain,
            isAntiAlias: false,
            errorBuilder: (context, error, stackTrace) {
              return const AspectRatio(
                aspectRatio: 1,
                child: ImageErrorPlaceholder(showLabel: true),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildImageInfo() {
    return Column(
      children: [
        _buildInfoRow(
          Icons.access_time,
          '${appLocalizations.created} ${dt.DateUtils.formatFullDate(image.createdAt)}',
        ),
        const SizedBox(height: Dimens.spacingS),
        _buildInfoRow(
          Icons.source,
          '${appLocalizations.source} ${SourceUtils.getSourceName(image.source)}',
        ),
        const SizedBox(height: Dimens.spacingS),
        _buildInfoRow(
          Icons.filter_alt,
          '${appLocalizations.filter} ${FilterUtils.getFilterName(image.metadata)}',
        ),
        const SizedBox(height: Dimens.spacingS),
        _buildInfoRow(
          Icons.display_settings,
          '${appLocalizations.epdModel} ${epd.modelId}',
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: Dimens.iconSizeS, color: grey600),
        const SizedBox(width: Dimens.spacingXs),
        Text(
          text,
          style: TextStyle(color: grey600, fontSize: Dimens.fontSizeS),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  onDelete();
                },
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: Text(
                  appLocalizations.delete,
                  style:
                      TextStyle(color: Colors.red, fontSize: Dimens.fontSizeS),
                ),
              ),
            ),
            const SizedBox(width: Dimens.spacingXs),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showRenameDialog(context),
                icon: const Icon(Icons.edit_outlined),
                label: Text(
                  appLocalizations.rename,
                  style: TextStyle(fontSize: Dimens.fontSizeS),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: Dimens.spacingS),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              onTransfer();
            },
            icon: const Icon(Icons.send),
            label: Text(appLocalizations.transferToEpaper),
          ),
        ),
      ],
    );
  }

  void _showPropertiesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ImagePropertiesDialog(image: image),
    );
  }

  void _showRenameDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ImageRenameDialog(
        currentName: image.name,
        onRename: (newName) {
          Navigator.pop(context);
          onRename(newName);
        },
      ),
    );
  }
}
