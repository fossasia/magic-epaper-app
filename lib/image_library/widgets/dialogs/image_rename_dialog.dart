import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

class ImageRenameDialog extends StatefulWidget {
  final String currentName;
  final Function(String) onRename;

  const ImageRenameDialog({
    super.key,
    required this.currentName,
    required this.onRename,
  });

  @override
  State<ImageRenameDialog> createState() => _ImageRenameDialogState();
}

class _ImageRenameDialogState extends State<ImageRenameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(Dimens.spacingXxl),
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
            _buildTextFieldSection(context),
            const SizedBox(height: Dimens.spacingXxxl),
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
          padding: const EdgeInsets.all(Dimens.spacingM),
          decoration: BoxDecoration(
            color: colorAccent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(Dimens.radiusXl),
          ),
          child: const Icon(
            Icons.edit_outlined,
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
                appLocalizations.renameImage,
                style: const TextStyle(
                  fontSize: Dimens.fontSizeXxl,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: Dimens.spacingXs),
              Text(
                appLocalizations.enterNewNameForImage,
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

  Widget _buildTextFieldSection(BuildContext _) {
    return SingleChildScrollView(
      child: Column(
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
            controller: _controller,
            autofocus: true,
            maxLength: 50,
            decoration: InputDecoration(
              hintText: appLocalizations.enterImageName,
              prefixIcon: const Icon(
                Icons.image_outlined,
                color: Colors.grey,
              ),
            ),
            textCapitalization: TextCapitalization.words,
            onSubmitted: (_) => _handleRename(context),
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
            onPressed: () => _handleRename(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: Dimens.spacingL),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens.radiusXl),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check, size: Dimens.iconSizeM),
                const SizedBox(width: Dimens.spacingS),
                Text(
                  appLocalizations.rename,
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

  void _handleRename(BuildContext context) {
    if (_controller.text.trim().isNotEmpty) {
      Navigator.pop(context);
      widget.onRename(_controller.text.trim());
    }
  }
}
