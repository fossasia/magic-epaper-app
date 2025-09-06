import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/ndef_screen/controller/nfc_controller.dart';
import 'package:magicepaperapp/ndef_screen/widgets/nfc_status_card.dart';
import 'package:magicepaperapp/ndef_screen/widgets/nfc_read_card.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';
import 'dart:async';

AppLocalizations appLocalizations = getIt.get<AppLocalizations>();

class NFCReadScreen extends StatefulWidget {
  const NFCReadScreen({super.key});

  @override
  State<NFCReadScreen> createState() => _NFCReadScreenState();
}

class _NFCReadScreenState extends State<NFCReadScreen>
    with WidgetsBindingObserver {
  late NFCController _nfcController;
  Timer? _nfcAvailabilityTimer;

  @override
  void initState() {
    super.initState();
    _nfcController = NFCController();
    _nfcController.addListener(_onNFCStateChanged);

    WidgetsBinding.instance.addObserver(this);

    _checkNFCAvailability();
    _startNFCAvailabilityListener();
  }

  @override
  void dispose() {
    _nfcController.removeListener(_onNFCStateChanged);
    _nfcController.dispose();
    _stopNFCAvailabilityListener();

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      _checkNFCAvailability();
      _startNFCAvailabilityListener();
    } else if (state == AppLifecycleState.paused) {
      _stopNFCAvailabilityListener();
    }
  }

  void _startNFCAvailabilityListener() {
    _stopNFCAvailabilityListener();

    _nfcAvailabilityTimer = Timer.periodic(const Duration(seconds: 2), (
      timer,
    ) async {
      await _checkNFCAvailabilityWithChangeDetection();
    });
  }

  void _stopNFCAvailabilityListener() {
    _nfcAvailabilityTimer?.cancel();
    _nfcAvailabilityTimer = null;
  }

  Future<void> _checkNFCAvailabilityWithChangeDetection() async {
    try {
      NFCAvailability previousAvailability = _nfcController.availability;
      await _nfcController.checkNFCAvailability();

      if (previousAvailability != _nfcController.availability) {
        _showNFCStatusChangeMessage(
          previousAvailability,
          _nfcController.availability,
        );
      }
    } catch (e) {
      debugPrint('Error checking NFC availability: $e');
    }
  }

  void _showNFCStatusChangeMessage(NFCAvailability from, NFCAvailability to) {
    String message;
    bool isError = false;

    switch (to) {
      case NFCAvailability.available:
        message = appLocalizations.nfcIsNowEnabledAndReady;
        break;
      case NFCAvailability.disabled:
        message = appLocalizations.nfcHasBeenDisabled;
        isError = true;
        break;
      case NFCAvailability.not_supported:
        message = appLocalizations.nfcIsNotSupportedOnDevice;
        isError = true;
        break;
    }

    _showSnackBar(message, isError: isError);
  }

  void _onNFCStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _checkNFCAvailability() async {
    await _nfcController.checkNFCAvailability();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
                  child: Text(appLocalizations.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: Text(appLocalizations.confirm),
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
      title: appLocalizations.readNfcTags,
      index: 1,
      actions: [
        IconButton(
          icon: const Icon(Icons.clear_all, color: Colors.white),
          onPressed: _nfcController.result.isNotEmpty
              ? () {
                  _nfcController.clearResult();
                  _showSnackBar(appLocalizations.resultsCleared);
                }
              : null,
          tooltip: appLocalizations.clearResults,
        ),
      ],
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              NFCStatusCard(
                availability: _nfcController.availability,
                onRefresh: _checkNFCAvailability,
              ),
              const SizedBox(height: 16),
              if (_nfcController.availability == NFCAvailability.available) ...[
                NFCReadCard(
                  isReading: _nfcController.isReading,
                  isClearing: _nfcController.isClearing,
                  result: _nfcController.result,
                  onRead: () async {
                    await _nfcController.readNDEF();
                    if (_nfcController.result
                        .contains(appLocalizations.error)) {
                      _showSnackBar(
                        appLocalizations.readOperationFailed,
                        isError: true,
                      );
                    } else {
                      _showSnackBar(appLocalizations.tagReadSuccessfully);
                    }
                  },
                  onVerify: () async {
                    await _nfcController.verifyWrite();
                    if (_nfcController.result
                        .contains(appLocalizations.error)) {
                      _showSnackBar(
                        appLocalizations.verificationFailed,
                        isError: true,
                      );
                    } else {
                      _showSnackBar(appLocalizations.tagVerifiedSuccessfully);
                    }
                  },
                  onClear: () async {
                    bool confirmed = await _showConfirmDialog(
                      appLocalizations.clearNfcTag,
                      appLocalizations.clearNfcTagConfirmation,
                    );
                    if (confirmed) {
                      await _nfcController.clearNDEF();
                      if (_nfcController.result.contains(
                        appLocalizations.error,
                      )) {
                        _showSnackBar(
                          appLocalizations.clearOperationFailed,
                          isError: true,
                        );
                      } else {
                        _showSnackBar(appLocalizations.tagClearedSuccessfully);
                      }
                    }
                  },
                ),
                const SizedBox(height: 16),
              ] else ...[
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
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
                        const SizedBox(height: 24),
                        Text(
                          appLocalizations.nfcNotAvailable,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          appLocalizations.enableNfcMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            height: 1.4,
                          ),
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
      ),
    );
  }
}
