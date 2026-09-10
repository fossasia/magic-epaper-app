import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';

class OcrScanButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const OcrScanButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.document_scanner_outlined, size: 18),
        label: Text(
          l10n.ocrScanToFill,
          style: const TextStyle(
            fontSize: Dimens.fontSizeM,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: colorAccent,
          side: const BorderSide(color: colorAccent, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: Dimens.spacingM),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.radiusM),
          ),
        ),
      ),
    );
  }
}
