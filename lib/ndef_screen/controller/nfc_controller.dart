import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:magicepaperapp/constants/string_constants.dart';
import 'package:magicepaperapp/ndef_screen/models/v_card_data.dart';
import 'package:magicepaperapp/ndef_screen/services/ndef_record_parser.dart';
import 'package:magicepaperapp/ndef_screen/services/nfc_availability_service.dart';
import 'package:magicepaperapp/ndef_screen/services/nfc_operations_service.dart';
import 'package:ndef/ndef.dart' as ndef;

class NFCController extends ChangeNotifier {
  NFCAvailability _availability = NFCAvailability.not_supported;
  String _result = '';
  bool _isReading = false;
  bool _isWriting = false;
  bool _isClearing = false;

  NFCAvailability get availability => _availability;
  String get result => _result;
  bool get isReading => _isReading;
  bool get isWriting => _isWriting;
  bool get isClearing => _isClearing;
  bool get isAnyOperationInProgress => _isReading || _isWriting || _isClearing;

  Future<void> checkNFCAvailability() async {
    _availability = await NFCAvailabilityService.checkAvailability();
    notifyListeners();
  }

  Future<void> readNDEF() async {
    if (_availability != NFCAvailability.available) return;

    _setReading(true);
    _setResult(StringConstants.scanningForNfcTag);

    final result = await NFCOperationsService.readNDEF();
    _setResult(result.message);
    _setReading(false);
  }

  Future<void> writeTextRecord(String text) async {
    if (_availability != NFCAvailability.available || text.trim().isEmpty) {
      return;
    }
    try {
      final record = NDEFRecordFactory.createTextRecord(text);
      await _performWrite([record]);
    } catch (e) {
      _setResult('${StringConstants.errorCreatingTextRecord}$e');
    }
  }

  Future<void> writeUrlRecord(String url) async {
    if (_availability != NFCAvailability.available || url.trim().isEmpty) {
      return;
    }
    try {
      final record = NDEFRecordFactory.createUrlRecord(url);
      await _performWrite([record]);
    } catch (e) {
      _setResult('${StringConstants.errorCreatingUrlRecord}$e');
    }
  }

  Future<void> writeWifiRecord(String ssid, String password) async {
    if (_availability != NFCAvailability.available || ssid.trim().isEmpty) {
      return;
    }
    try {
      final record = NDEFRecordFactory.createWifiRecord(ssid, password);
      await _performWrite([record]);
    } catch (e) {
      _setResult('${StringConstants.errorCreatingWifiRecord}$e');
    }
  }

  Future<void> writeMultipleRecords(String text, String url, String wifiSSID,
      String wifiPassword, VCardData? vCardData) async {
    if (_availability != NFCAvailability.available) return;

    List<ndef.NDEFRecord> records = [];
    try {
      if (vCardData != null) {
        records.add(NDEFRecordFactory.createVCardRecord(vCardData));
      }
      if (text.trim().isNotEmpty) {
        records.add(NDEFRecordFactory.createTextRecord(text));
      }
      if (url.trim().isNotEmpty) {
        records.add(NDEFRecordFactory.createUrlRecord(url));
      }
      if (wifiSSID.trim().isNotEmpty) {
        records.add(NDEFRecordFactory.createWifiRecord(wifiSSID, wifiPassword));
      }
      if (records.isEmpty) {
        _setResult(StringConstants.pleaseEnterAtLeastOneRecord);
        return;
      }
      await _performWrite(records);
    } catch (e) {
      _setResult('${StringConstants.errorCreatingMultipleRecords}$e');
    }
  }

  Future<void> _performWrite(List<ndef.NDEFRecord> records) async {
    _setWriting(true);
    _setResult(StringConstants.scanningForNfcTagToWrite);
    final result = await NFCOperationsService.writeNDEF(records);
    _setResult(result.message);
    _setWriting(false);
  }

  Future<void> clearNDEF() async {
    if (_availability != NFCAvailability.available) return;
    _setClearing(true);
    _setResult(StringConstants.scanningForNfcTagToClear);
    final result = await NFCOperationsService.clearNDEF();
    _setResult(result.message);
    _setClearing(false);
  }

  Future<void> verifyWrite() async {
    if (_availability != NFCAvailability.available) return;
    _setResult(StringConstants.scanningTagForVerification);
    final result = await NFCOperationsService.verifyTag();
    _setResult(result.message);
  }

  Future<void> writeVCardRecord(VCardData vCardData) async {
    if (_availability != NFCAvailability.available) {
      return;
    }

    try {
      final record = NDEFRecordFactory.createVCardRecord(vCardData);
      await _performWrite([record]);
    } catch (e) {
      _setResult('Error creating vCard record: $e');
    }
  }

  void clearResult() {
    _setResult('');
  }

  void _setReading(bool value) {
    _isReading = value;
    notifyListeners();
  }

  void _setWriting(bool value) {
    _isWriting = value;
    notifyListeners();
  }

  void _setClearing(bool value) {
    _isClearing = value;
    notifyListeners();
  }

  void _setResult(String value) {
    _result = value;
    notifyListeners();
  }
}
