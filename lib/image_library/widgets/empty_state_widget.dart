import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.photo_library_outlined,
              size: 64, color: Colors.grey),
          const SizedBox(height: Dimens.spacingL),
          Text(
            appLocalizations.noSavedImagesYet,
            style: const TextStyle(
              fontSize: Dimens.fontSizeXl,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: Dimens.spacingS),
          Text(
            appLocalizations.saveImagesFromEditor,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
