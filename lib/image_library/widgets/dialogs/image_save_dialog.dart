import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

class ImageSaveDialog extends StatefulWidget {
  final Uint8List imageData;
  final String? filterName;
  final String? initialName;
  final Function(String) onSave;

  const ImageSaveDialog({
    super.key,
    required this.imageData,
    this.filterName,
    this.initialName,
    required this.onSave,
  });

  @override
  State<ImageSaveDialog> createState() => _ImageSaveDialogState();
}

class _ImageSaveDialogState extends State<ImageSaveDialog> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialName ??
          'Filtered_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

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
              const SizedBox(height: Dimens.spacingL),
              _buildImagePreview(),
              const SizedBox(height: Dimens.spacingL),
              _buildTextFieldSection(),
              const SizedBox(height: Dimens.spacingXxl),
              if (widget.filterName != null) ...[
                _buildFilterInfoChip(),
                const SizedBox(height: Dimens.spacingXl),
              ],
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
            color: colorAccent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(Dimens.radiusXl),
          ),
          child: const Icon(
            Icons.save_outlined,
            color: colorAccent,
            size: Dimens.iconSizeL,
          ),
        ),
        const SizedBox(width: Dimens.spacingL),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appLocalizations.saveImage,
                style: const TextStyle(
                  fontSize: Dimens.fontSizeXxl,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: Dimens.spacingXs),
              Text(
                appLocalizations.saveFilteredImageToLibrary,
                style: const TextStyle(
                  fontSize: Dimens.fontSizeM,
                  color: Colors.grey,
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
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: Dimens.spacingM),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(Dimens.radiusXxl),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.radiusXl),
        child: Image.memory(
          widget.imageData,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildTextFieldSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appLocalizations.imageName,
          style: const TextStyle(
            fontSize: Dimens.fontSizeM,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: Dimens.spacingS),
        TextField(
          controller: _nameController,
          autofocus: true,
          maxLength: 50,
          decoration: InputDecoration(
            hintText: appLocalizations.enterImageName,
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimens.radiusXl),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimens.radiusXl),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimens.radiusXl),
              borderSide: const BorderSide(color: colorAccent, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimens.radiusXl),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            prefixIcon: const Icon(
              Icons.photo_library_outlined,
              color: Colors.grey,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Dimens.spacingL,
              vertical: Dimens.spacingL,
            ),
          ),
          textCapitalization: TextCapitalization.words,
          onSubmitted: (value) => _handleSave(),
        ),
      ],
    );
  }

  Widget _buildFilterInfoChip() {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimens.spacingM, vertical: Dimens.spacingS),
      decoration: BoxDecoration(
        color: colorAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Dimens.radiusRound),
        border: Border.all(color: colorAccent.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.filter_alt_outlined,
            size: Dimens.iconSizeS,
            color: colorAccent,
          ),
          const SizedBox(width: Dimens.spacingSm),
          Text(
            '${appLocalizations.filterApplied} ${widget.filterName}',
            style: TextStyle(
              fontSize: Dimens.fontSizeS,
              fontWeight: FontWeight.w500,
              color: colorAccent,
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
                fontSize: Dimens.fontSizeL,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: Dimens.spacingM),
        Expanded(
          child: ElevatedButton(
            onPressed: () => _handleSave(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.download, size: Dimens.iconSizeM),
                const SizedBox(width: Dimens.spacingS),
                Text(
                  appLocalizations.save,
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

  void _handleSave() {
    if (_nameController.text.trim().isNotEmpty) {
      widget.onSave(_nameController.text.trim());
    }
  }
}

class SnackBarUtils {
  static void showLoading(BuildContext context,
      {String message = 'Loading...'}) {
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
            const SizedBox(width: Dimens.spacingM),
            Text(message),
          ],
        ),
        backgroundColor: colorAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle,
                color: Colors.white, size: Dimens.iconSizeM),
            const SizedBox(width: Dimens.spacingM),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.radiusL)),
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error,
                color: Colors.white, size: Dimens.iconSizeM),
            const SizedBox(width: Dimens.spacingM),
            Text(message),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.radiusL)),
      ),
    );
  }
}
