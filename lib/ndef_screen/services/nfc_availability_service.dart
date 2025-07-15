import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class NFCAvailabilityService {
  static Future<NFCAvailability> checkAvailability() async {
    try {
      return await FlutterNfcKit.nfcAvailability;
    } catch (e) {
      return NFCAvailability.not_supported;
    }
  }

  static String getAvailabilityString(NFCAvailability availability) {
    return availability
        .toString()
        .split('.')
        .last
        .replaceAll('_', ' ')
        .toUpperCase();
  }

  static Color getAvailabilityColor(NFCAvailability availability) {
    switch (availability) {
      case NFCAvailability.available:
        return Colors.green;
      case NFCAvailability.disabled:
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  static IconData getAvailabilityIcon(NFCAvailability availability) {
    switch (availability) {
      case NFCAvailability.available:
        return Icons.check_circle;
      case NFCAvailability.disabled:
        return Icons.warning;
      default:
        return Icons.error;
    }
  }
}
