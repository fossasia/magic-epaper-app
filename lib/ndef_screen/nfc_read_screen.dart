import 'package:flutter/material.dart';
import 'package:magicepaperapp/theme/colors.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/ndef_screen/nfc_base_screen_state.dart';
import 'package:magicepaperapp/ndef_screen/widgets/nfc_disabled_card.dart';
import 'package:magicepaperapp/ndef_screen/widgets/nfc_status_card.dart';
import 'package:magicepaperapp/ndef_screen/widgets/nfc_read_card.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';

class NFCReadScreen extends StatefulWidget {
  const NFCReadScreen({super.key});

  @override
  State<NFCReadScreen> createState() => _NFCReadScreenState();
}

class _NFCReadScreenState extends NFCBaseScreenState<NFCReadScreen> {
  Future<bool> _showConfirmDialog(String title, String content) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(this.appLocalizations.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: Text(this.appLocalizations.confirm),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: this.appLocalizations.readNfcTags,
      index: 1,
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_sweep, color: colorWhite),
          onPressed: () {
            if (nfcController.result.isNotEmpty) {
              nfcController.clearResult();
              showSnackBar(this.appLocalizations.resultsCleared);
            } else {
              showSnackBar(this.appLocalizations.nothingToClear, isError: true);
            }
          },
          tooltip: this.appLocalizations.clearResults,
        ),
      ],
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              NFCStatusCard(
                availability: nfcController.availability,
                onRefresh: checkNFCAvailability,
              ),
              const SizedBox(height: Dimens.spacingL),
              if (nfcController.availability == NFCAvailability.available) ...[
                NFCReadCard(
                  isReading: nfcController.isReading,
                  isClearing: nfcController.isClearing,
                  result: nfcController.result,
                  onRead: () async {
                    await nfcController.readNDEF();
                    if (nfcController.result
                        .contains(this.appLocalizations.error)) {
                      showSnackBar(
                        this.appLocalizations.readOperationFailed,
                        isError: true,
                      );
                    } else {
                      showSnackBar(this.appLocalizations.tagReadSuccessfully);
                    }
                  },
                  onVerify: () async {
                    await nfcController.verifyWrite();
                    if (nfcController.result
                        .contains(this.appLocalizations.error)) {
                      showSnackBar(
                        this.appLocalizations.verificationFailed,
                        isError: true,
                      );
                    } else {
                      showSnackBar(
                          this.appLocalizations.tagVerifiedSuccessfully);
                    }
                  },
                  onClear: () async {
                    bool confirmed = await _showConfirmDialog(
                      this.appLocalizations.clearNfcTag,
                      this.appLocalizations.clearNfcTagConfirmation,
                    );
                    if (confirmed) {
                      await nfcController.clearNDEF();
                      if (nfcController.result.contains(
                        this.appLocalizations.error,
                      )) {
                        showSnackBar(
                          this.appLocalizations.clearOperationFailed,
                          isError: true,
                        );
                      } else {
                        showSnackBar(
                            this.appLocalizations.tagClearedSuccessfully);
                      }
                    }
                  },
                ),
                const SizedBox(height: Dimens.spacingL),
              ] else if (nfcController.availability ==
                  NFCAvailability.disabled) ...[
                const NFCDisabledCard(),
              ],
              const SizedBox(height: Dimens.spacingL),
            ],
          ),
        ),
      ),
    );
  }
}
