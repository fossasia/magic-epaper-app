import 'dart:io';
import 'package:flutter/material.dart';
import 'package:magicepaperapp/image_library/model/saved_image_model.dart';
import 'package:magicepaperapp/image_library/utils/date_utils.dart' as dt;
import 'package:magicepaperapp/image_library/utils/filter_utils.dart';
import 'package:magicepaperapp/image_library/utils/source_utils.dart';
import 'package:magicepaperapp/image_library/widgets/dialogs/image_properties_dialog.dart';
import 'package:magicepaperapp/image_library/widgets/dialogs/image_rename_dialog.dart';
import 'package:magicepaperapp/util/epd/display_device.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

AppLocalizations appLocalizations = getIt.get<AppLocalizations>();

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
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              _buildContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () => _showPropertiesDialog(context),
            icon: const Icon(Icons.info_outline, color: Colors.white),
            tooltip: appLocalizations.imageProperties,
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildImageContainer(),
          const SizedBox(height: 16),
          _buildImageInfo(),
          const SizedBox(height: 24),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildImageContainer() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: mdGrey400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(image.filePath),
          fit: BoxFit.contain,
          isAntiAlias: false,
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
        const SizedBox(height: 8),
        _buildInfoRow(
          Icons.source,
          '${appLocalizations.source} ${SourceUtils.getSourceName(image.source)}',
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          Icons.filter_alt,
          '${appLocalizations.filter} ${FilterUtils.getFilterName(image.metadata)}',
        ),
        const SizedBox(height: 8),
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
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
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
                label: Text(appLocalizations.delete,
                  style: TextStyle(fontSize: 12),),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showRenameDialog(context),
                icon: const Icon(Icons.edit_outlined),
                label: Text(appLocalizations.rename,
                  style: TextStyle(fontSize: 12),),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              onTransfer();
            },
            icon: const Icon(Icons.send),
            label: Text(appLocalizations.transferToEpaper),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
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
