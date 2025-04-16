import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NFCSettingsLauncher {
  static const platform = MethodChannel('com.yourapp.nfc/settings');

  static Future<void> openNFCSettings() async {
    try {
      await platform.invokeMethod('openNFCSettings');
    } on PlatformException catch (e) {
      debugPrint("Failed to open NFC settings: ${e.message}");
    }
  }
}
