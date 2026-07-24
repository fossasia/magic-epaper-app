import 'package:flutter/material.dart';
import 'package:magicepaperapp/theme/colors.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/ndef_screen/app_launcher_card.dart';
import 'package:magicepaperapp/ndef_screen/app_nfc/app_data_model.dart';
import 'package:magicepaperapp/ndef_screen/nfc_base_screen_state.dart';
import 'package:magicepaperapp/ndef_screen/models/v_card_data.dart';
import 'package:magicepaperapp/ndef_screen/widgets/nfc_disabled_card.dart';
import 'package:magicepaperapp/ndef_screen/widgets/nfc_status_card.dart';
import 'package:magicepaperapp/ndef_screen/widgets/nfc_write_card.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';

class NFCWriteScreen extends StatefulWidget {
  const NFCWriteScreen({super.key});

  @override
  State<NFCWriteScreen> createState() => _NFCWriteScreenState();
}

class _NFCWriteScreenState extends NFCBaseScreenState<NFCWriteScreen> {
  String _textValue = '';
  String _urlValue = '';
  String _wifiSSIDValue = '';
  String _wifiPasswordValue = '';
  VCardData? _vCardData;
  AppData? _selectedApp;

  @override
  void initState() {
    super.initState();
    _vCardData = VCardData(
      firstName: '',
      lastName: '',
      organization: '',
      title: '',
      mobileNumber: '',
      emailAddress: '',
      street: '',
      city: '',
      zipCode: '',
      country: '',
      website: '',
    );
  }

  void _onAppSelected(AppData? app) {
    setState(() {
      _selectedApp = app;
    });
  }

  Future<void> _writeAppLauncher() async {
    if (_selectedApp != null) {
      await nfcController.writeAppLauncherRecord(_selectedApp!.packageName);
      if (!mounted) return;
      _handleWriteResult();
      if (nfcController.result.contains(this.appLocalizations.successfully)) {
        setState(() {
          _selectedApp = null;
        });
      }
    }
  }

  void _handleWriteResult() {
    if (nfcController.result.contains(this.appLocalizations.error)) {
      showSnackBar(this.appLocalizations.writeOperationFailed, isError: true);
    } else if (nfcController.result
        .contains(this.appLocalizations.successfully)) {
      showSnackBar(this.appLocalizations.dataWrittenSuccessfully);
      setState(() {
        _textValue = '';
        _urlValue = '';
        _wifiSSIDValue = '';
        _wifiPasswordValue = '';
        _vCardData = VCardData(
          firstName: '',
          lastName: '',
          organization: '',
          title: '',
          mobileNumber: '',
          emailAddress: '',
          street: '',
          city: '',
          zipCode: '',
          country: '',
          website: '',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: this.appLocalizations.writeNfcTags,
      index: 2,
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
                NFCWriteCard(
                  isWriting: nfcController.isWriting,
                  textValue: _textValue,
                  urlValue: _urlValue,
                  wifiSSIDValue: _wifiSSIDValue,
                  wifiPasswordValue: _wifiPasswordValue,
                  vCardData: _vCardData,
                  onTextChanged: (value) => setState(() => _textValue = value),
                  onUrlChanged: (value) => setState(() => _urlValue = value),
                  onWifiSSIDChanged: (value) =>
                      setState(() => _wifiSSIDValue = value),
                  onWifiPasswordChanged: (value) =>
                      setState(() => _wifiPasswordValue = value),
                  onVCardChanged: (vCardData) =>
                      setState(() => _vCardData = vCardData),
                  onWriteText: () async {
                    await nfcController.writeTextRecord(_textValue);
                    if (!mounted) return;
                    _handleWriteResult();
                  },
                  onWriteUrl: () async {
                    await nfcController.writeUrlRecord(_urlValue);
                    if (!mounted) return;
                    _handleWriteResult();
                  },
                  onWriteWifi: () async {
                    await nfcController.writeWifiRecord(
                      _wifiSSIDValue,
                      _wifiPasswordValue,
                    );
                    if (!mounted) return;
                    _handleWriteResult();
                  },
                  onWriteVCard: () async {
                    if (_vCardData != null) {
                      await nfcController.writeVCardRecord(_vCardData!);
                      if (!mounted) return;
                      _handleWriteResult();
                    }
                  },
                  onWriteMultiple: () async {
                    await nfcController.writeMultipleRecords(
                      _textValue,
                      _urlValue,
                      _wifiSSIDValue,
                      _wifiPasswordValue,
                      _vCardData,
                    );
                    if (!mounted) return;
                    _handleWriteResult();
                  },
                ),
                AppLauncherCard(
                  selectedApp: _selectedApp,
                  onAppSelected: _onAppSelected,
                  isWriting: nfcController.isWriting,
                  onWriteAppLauncher: _writeAppLauncher,
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
