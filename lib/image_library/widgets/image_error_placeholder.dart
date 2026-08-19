import 'package:flutter/material.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

class ImageErrorPlaceholder extends StatelessWidget {
  final double iconSize;
  final bool showLabel;

  const ImageErrorPlaceholder({
    super.key,
    this.iconSize = 48,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.broken_image_outlined,
              color: Colors.grey,
              size: iconSize,
            ),
            if (showLabel) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  getIt.get<AppLocalizations>().imageUnavailable,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
