import 'package:flutter/material.dart';

import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

AppLocalizations appLocalizations = getIt.get<AppLocalizations>();

import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/string_constants.dart';


class NFCReadCard extends StatelessWidget {
  final bool isReading;
  final String result;
  final VoidCallback onRead;
  final VoidCallback onVerify;
  final VoidCallback onClear;
  final bool isClearing;

  const NFCReadCard({
    super.key,
    required this.isReading,
    required this.result,
    required this.onRead,
    required this.onVerify,
    required this.onClear,
    required this.isClearing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(12),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.nfc, color: colorAccent, size: 22),
                SizedBox(width: 8),
                Text(
                  appLocalizations.readNdefTags,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorBlack,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: mdGrey400.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          onPressed: isReading ? null : onRead,
                          icon: isReading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        colorWhite),
                                  ),
                                )
                              : const Icon(Icons.nfc, color: colorWhite),
                          label: isReading
                              ? appLocalizations.reading
                              : appLocalizations.readNfcTag,
                          backgroundColor: colorAccent,
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildActionButton(
                        onPressed: onVerify,
                        icon: const Icon(Icons.search, color: colorWhite),
                        label: appLocalizations.verify,
                        backgroundColor: Colors.orange,
                        isCompact: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: _buildActionButton(
                      onPressed: isClearing ? null : onClear,
                      icon: isClearing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(colorWhite),
                              ),
                            )
                          : const Icon(Icons.delete_forever, color: colorWhite),
                      label: isClearing
                          ? appLocalizations.clearing
                          : appLocalizations.clearNfcTag,
                      backgroundColor: Colors.red[700]!,
                    ),
                  ),
                ],
              ),
            ),
            if (result.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Row(
                children: [
                  Icon(Icons.receipt_long, color: colorAccent, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Read Results',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colorBlack,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxHeight: 300),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: mdGrey400.withValues(alpha: 0.3)),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    result,
                    style: TextStyle(
                      fontFamily: appLocalizations.monospaceFontFamily,
                      fontSize: 12,
                      color: colorBlack,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback? onPressed,
    required Widget icon,
    required String label,
    required Color backgroundColor,
    bool isCompact = false,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          vertical: 14,
          horizontal: isCompact ? 16 : 20,
        ),
        backgroundColor: backgroundColor,
        foregroundColor: colorWhite,
        disabledBackgroundColor: Colors.grey[300],
        disabledForegroundColor: Colors.grey[600],
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
