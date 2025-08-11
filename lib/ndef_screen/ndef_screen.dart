import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:magicepaperapp/constants/string_constants.dart';
import 'package:magicepaperapp/ndef_screen/controller/nfc_controller.dart';
import 'package:magicepaperapp/ndef_screen/models/v_card_data.dart';
import 'package:magicepaperapp/ndef_screen/nfc_vcard_write_card.dart';
import 'package:magicepaperapp/ndef_screen/widgets/nfc_status_card.dart';
import 'package:magicepaperapp/ndef_screen/widgets/nfc_write_card.dart';
import 'package:magicepaperapp/ndef_screen/widgets/nfc_read_card.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';

class NDEFScreen extends StatefulWidget {
  const NDEFScreen({super.key});

  @override
  State<NDEFScreen> createState() => _NDEFScreenState();
}

class _NDEFScreenState extends State<NDEFScreen> {
  late NFCController _nfcController;
  String _textValue = '';
  String _urlValue = '';
  String _wifiSSIDValue = '';
  String _wifiPasswordValue = '';
  VCardData? _vCardData;

  @override
  void initState() {
    super.initState();
    _nfcController = NFCController();
    _nfcController.addListener(_onNFCStateChanged);
    _checkNFCAvailability();
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

  @override
  void dispose() {
    _nfcController.removeListener(_onNFCStateChanged);
    _nfcController.dispose();
    super.dispose();
  }

  void _onNFCStateChanged() {
    setState(() {});
  }

  Future<void> _checkNFCAvailability() async {
    await _nfcController.checkNFCAvailability();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      title: StringConstants.appName,
      index: 1,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.clear_all,
            color: Colors.white,
          ),
          onPressed: _nfcController.result.isNotEmpty
              ? () {
                  _nfcController.clearResult();
                  _showSnackBar('Results cleared');
                }
              : null,
          tooltip: 'Clear Results',
        ),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            NFCStatusCard(
              availability: _nfcController.availability,
              onRefresh: _checkNFCAvailability,
            ),
            const SizedBox(height: 16),
            NFCReadCard(
              isReading: _nfcController.isReading,
              isClearing: _nfcController.isClearing,
              result: _nfcController.result,
              onRead: () async {
                await _nfcController.readNDEF();
                if (_nfcController.result.contains(StringConstants.error)) {
                  _showSnackBar(StringConstants.readOperationFailed,
                      isError: true);
                } else {
                  _showSnackBar(StringConstants.tagReadSuccessfully);
                }
              },
              onVerify: () async {
                await _nfcController.verifyWrite();
                if (_nfcController.result.contains(StringConstants.error)) {
                  _showSnackBar(StringConstants.verificationFailed,
                      isError: true);
                } else {
                  _showSnackBar(StringConstants.tagVerifiedSuccessfully);
                }
              },
              onClear: () async {
                bool confirmed = await _showConfirmDialog(
                  StringConstants.clearNfcTag,
                  StringConstants.clearNfcTagConfirmation,
                );
                if (confirmed) {
                  await _nfcController.clearNDEF();
                  if (_nfcController.result.contains(StringConstants.error)) {
                    _showSnackBar(StringConstants.clearOperationFailed,
                        isError: true);
                  } else {
                    _showSnackBar(StringConstants.tagClearedSuccessfully);
                  }
                }
              },
            ),
            const SizedBox(height: 16),
            if (_nfcController.availability == NFCAvailability.available) ...[
              NFCVCardWriteCard(
                isWriting: _nfcController.isWriting,
                vCardData: _vCardData,
                onVCardChanged: (vCardData) =>
                    setState(() => _vCardData = vCardData),
                onWriteVCard: () async {
                  if (_vCardData != null) {
                    await _nfcController.writeVCardRecord(_vCardData!);
                    _handleWriteResult();
                  }
                },
              ),
              const SizedBox(height: 16),
              NFCWriteCard(
                isWriting: _nfcController.isWriting,
                textValue: _textValue,
                urlValue: _urlValue,
                wifiSSIDValue: _wifiSSIDValue,
                wifiPasswordValue: _wifiPasswordValue,
                onTextChanged: (value) => setState(() => _textValue = value),
                onUrlChanged: (value) => setState(() => _urlValue = value),
                onWifiSSIDChanged: (value) =>
                    setState(() => _wifiSSIDValue = value),
                onWifiPasswordChanged: (value) =>
                    setState(() => _wifiPasswordValue = value),
                onWriteText: () async {
                  await _nfcController.writeTextRecord(_textValue);
                  _handleWriteResult();
                },
                onWriteUrl: () async {
                  await _nfcController.writeUrlRecord(_urlValue);
                  _handleWriteResult();
                },
                onWriteWifi: () async {
                  await _nfcController.writeWifiRecord(
                      _wifiSSIDValue, _wifiPasswordValue);
                  _handleWriteResult();
                },
                onWriteMultiple: () async {
                  await _nfcController.writeMultipleRecords(
                    _textValue,
                    _urlValue,
                    _wifiSSIDValue,
                    _wifiPasswordValue,
                    _vCardData,
                  );
                  _handleWriteResult();
                },
              ),
            ] else ...[
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(Icons.warning, size: 48, color: Colors.orange),
                      const SizedBox(height: 16),
                      Text(
                        StringConstants.nfcNotAvailable,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        StringConstants.enableNfcMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _handleWriteResult() {
    if (_nfcController.result.contains(StringConstants.error)) {
      _showSnackBar(StringConstants.writeOperationFailed, isError: true);
    } else if (_nfcController.result.contains(StringConstants.successfully)) {
      _showSnackBar(StringConstants.dataWrittenSuccessfully);
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
                  child: const Text(StringConstants.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text(StringConstants.confirm),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
