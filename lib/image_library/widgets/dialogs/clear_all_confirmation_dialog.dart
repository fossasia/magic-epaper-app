import 'package:flutter/material.dart';
import 'package:magicepaperapp/view/widget/common_alert_dialog.dart';
import 'package:magicepaperapp/view/widget/common_dialog_button.dart';

class ClearAllConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final int totalImages;

  const ClearAllConfirmationDialog({
    super.key,
    required this.onConfirm,
    required this.totalImages,
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
            _buildDataSummary(),
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
          child: const Icon(
            Icons.delete_forever_outlined,
            color: Colors.red,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Clear All Data',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Complete data removal',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataSummary() {
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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.photo_library_outlined,
                  size: 32,
                  color: Colors.red.shade600,
                ),
                const SizedBox(width: 12),
                Column(
                  children: [
                    Text(
                      '$totalImages',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                      ),
                    ),
                    Text(
                      'Total Images',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'All images and associated data will be permanently removed',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
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
            label: 'Cancel',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CommonDialogButton(
            onPressed: onConfirm,
            variant: DialogButtonVariant.danger,
            icon: Icons.delete_forever,
            label: 'Clear All',
          ),
        ),
      ],
    );
  }
}
