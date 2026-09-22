import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/theme/colors.dart';

class NFCDisabledCard extends StatelessWidget {
  const NFCDisabledCard({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = getIt.get<AppLocalizations>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Dimens.spacingS),
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(Dimens.radiusXl),
        boxShadow: [
          BoxShadow(
            color: colorBlack.withValues(alpha: 0.08),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(Dimens.spacingXxl),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(Dimens.spacingL),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.warning_outlined,
                size: 48,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: Dimens.spacingXxl),
            Text(
              appLocalizations.nfcNotAvailable,
              style: const TextStyle(
                fontSize: Dimens.fontSizeXxl,
                fontWeight: FontWeight.bold,
                color: colorBlack87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimens.spacingM),
            Text(
              appLocalizations.enableNfcMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Dimens.fontSizeL,
                color: grey600,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
