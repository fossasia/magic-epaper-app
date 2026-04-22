import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/view/widget/common_alert_dialog.dart';
import 'package:magicepaperapp/view/widget/common_dialog_button.dart';

AppLocalizations appLocalizations = getIt.get<AppLocalizations>();

class ImageRenameDialog extends StatelessWidget {
  final String currentName;
  final Function(String) onRename;

  const ImageRenameDialog({
    super.key,
    required this.currentName,
    required this.onRename,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: currentName);

    return CommonAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildTextFieldSection(controller, context),
          const SizedBox(height: 32),
          _buildActionButtons(context, controller),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.edit_outlined,
            color: colorAccent,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appLocalizations.renameImage,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                appLocalizations.enterNewNameForImage,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextFieldSection(TextEditingController controller, context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appLocalizations.imageName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            autofocus: true,
            maxLength: 50,
            decoration: InputDecoration(
              hintText: appLocalizations.enterImageName,
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: colorAccent, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              prefixIcon: const Icon(
                Icons.image_outlined,
                color: Colors.grey,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            textCapitalization: TextCapitalization.words,
            onSubmitted: (value) => _handleRename(controller, context),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, TextEditingController controller) {
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
            onPressed: () => _handleRename(controller, context),
            icon: Icons.check,
            label: appLocalizations.rename,
          ),
        ),
      ],
    );
  }

  void _handleRename(TextEditingController controller, BuildContext context) {
    if (controller.text.trim().isNotEmpty) {
      Navigator.pop(context);
      onRename(controller.text.trim());
    }
  }
}
