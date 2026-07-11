import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

import 'package:magicepaperapp/constants/color_constants.dart';

import 'package:magicepaperapp/ndef_screen/services/nfc_availability_service.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

class NFCStatusCard extends StatelessWidget {
  final NFCAvailability availability;
  final VoidCallback onRefresh;

  const NFCStatusCard({
    super.key,
    required this.availability,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(Dimens.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.nfc_outlined,
                      color: colorAccent,
                      size: 22,
                    ),
                    const SizedBox(width: Dimens.spacingS),
                    Text(
                      appLocalizations.nfcStatus,
                      style: const TextStyle(
                        fontSize: Dimens.fontSizeXl,
                        fontWeight: FontWeight.bold,
                        color: colorBlack,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorWhite,
                    boxShadow: [
                      BoxShadow(
                        color: colorBlack.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.refresh,
                      color: colorAccent,
                      size: Dimens.iconSizeM,
                    ),
                    onPressed: onRefresh,
                    tooltip: appLocalizations.refreshNfcStatus,
                    padding: const EdgeInsets.all(Dimens.spacingS),
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimens.spacingL),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dimens.spacingL),
              decoration: BoxDecoration(
                color: _getStatusBackgroundColor(),
                borderRadius: BorderRadius.circular(Dimens.radiusL),
                border: Border.all(
                  color: NFCAvailabilityService.getAvailabilityColor(
                    availability,
                  ).withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(Dimens.spacingS),
                    decoration: BoxDecoration(
                      color: NFCAvailabilityService.getAvailabilityColor(
                        availability,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Dimens.radiusM),
                    ),
                    child: Icon(
                      NFCAvailabilityService.getAvailabilityIcon(availability),
                      color: NFCAvailabilityService.getAvailabilityColor(
                        availability,
                      ),
                      size: Dimens.iconSizeL,
                    ),
                  ),
                  const SizedBox(width: Dimens.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          NFCAvailabilityService.getAvailabilityString(
                            availability,
                          ),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Dimens.fontSizeL,
                            color: NFCAvailabilityService.getAvailabilityColor(
                              availability,
                            ),
                          ),
                        ),
                        const SizedBox(height: Dimens.spacingXs),
                        Text(
                          _getStatusDescription(),
                          style: TextStyle(
                            fontSize: Dimens.fontSizeS,
                            color: Colors.grey[600],
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusBackgroundColor() {
    switch (availability) {
      case NFCAvailability.available:
        return Colors.green[50]!;
      case NFCAvailability.not_supported:
        return Colors.red[50]!;
      case NFCAvailability.disabled:
        return Colors.orange[50]!;
    }
  }

  String _getStatusDescription() {
    switch (availability) {
      case NFCAvailability.available:
        return appLocalizations.nfcIsReadyToUse;
      case NFCAvailability.not_supported:
        return appLocalizations.deviceDoesNotSupportNfc;
      case NFCAvailability.disabled:
        return appLocalizations.pleaseEnableNfcInSettings;
    }
  }
}
