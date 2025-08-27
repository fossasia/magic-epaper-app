import 'package:flutter/services.dart';

class WaveShareNfcServices {
  static const platform = MethodChannel('org.fossasia.magicepaperapp/nfc');

  Future<String?> flashImage(Uint8List imageBytes, int ePaperSize) async {
    try {
      final String? result = await platform.invokeMethod('flashImage', {
        'imageBytes': imageBytes,
        'ePaperSize': ePaperSize,
      });
      return result;
    } on PlatformException {
      rethrow;
    }
  }

  Future<void> disableNfcReaderMode() async {
    try {
      await platform.invokeMethod('disableNfcReaderMode');
    } on PlatformException {
      /// Ignoring exception
    }
  }
}
