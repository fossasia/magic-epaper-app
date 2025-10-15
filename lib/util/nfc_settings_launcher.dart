import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_logger.dart';

class NFCSettingsLauncher {
  static const platform = MethodChannel('org.fossasia.magicepaperapp/settings');

  static Future<void> openNFCSettings() async {
    try {
      await platform.invokeMethod('openNFCSettings');
    } on PlatformException catch (e) {
      AppLogger.error("Failed to open NFC settings: ${e.message}");
    }
  }
}
