import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/ndef_screen/controller/nfc_controller.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

import '../../util/app_logger.dart';

abstract class NFCBaseScreenState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  late final NFCController nfcController;
  Timer? _nfcAvailabilityTimer;

  AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

  @override
  void initState() {
    super.initState();

    nfcController = NFCController();
    nfcController.addListener(_onNFCStateChanged);

    WidgetsBinding.instance.addObserver(this);

    checkNFCAvailability();
    _startNFCAvailabilityListener();
  }

  @override
  void dispose() {
    nfcController.removeListener(_onNFCStateChanged);
    nfcController.dispose();

    _stopNFCAvailabilityListener();

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      checkNFCAvailability();
      _startNFCAvailabilityListener();
    } else if (state == AppLifecycleState.paused) {
      _stopNFCAvailabilityListener();
    }
  }

  void _startNFCAvailabilityListener() {
    _stopNFCAvailabilityListener();

    _nfcAvailabilityTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => _checkNFCAvailabilityWithChangeDetection(),
    );
  }

  void _stopNFCAvailabilityListener() {
    _nfcAvailabilityTimer?.cancel();
    _nfcAvailabilityTimer = null;
  }

  Future<void> checkNFCAvailability() async {
    await nfcController.checkNFCAvailability();
  }

  Future<void> _checkNFCAvailabilityWithChangeDetection() async {
    try {
      final previous = nfcController.availability;

      await nfcController.checkNFCAvailability();

      if (previous != nfcController.availability) {
        _showNFCStatusChangeMessage(previous, nfcController.availability);
      }
    } catch (e) {
      AppLogger.error('Error checking NFC availability: $e');
    }
  }

  void _showNFCStatusChangeMessage(
    NFCAvailability from,
    NFCAvailability to,
  ) {
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

    showSnackBar(message, isError: isError);
  }

  void _onNFCStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void showSnackBar(String message, {bool isError = false}) {
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
}
