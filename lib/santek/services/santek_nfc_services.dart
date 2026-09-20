import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/santek/models/santek_nfc_exception.dart';
import 'package:magicepaperapp/santek/services/santek_nfc_protocol.dart';

typedef SantekProgressCallback = void Function(int progress);

class SantekNfcServices {
  static const _platform = MethodChannel('org.fossasia.magicepaperapp/nfc');
  static const _pollTimeout = Duration(minutes: 2);

  Future<void> flashImage(
    img.Image image, {
    SantekProgressCallback? onProgress,
  }) async {
    var sessionStarted = false;

    try {
      await _ensureNfcAvailable();
      onProgress?.call(0);

      final tag = await FlutterNfcKit.poll(
        timeout: _pollTimeout,
        androidCheckNDEF: false,
        readIso14443A: true,
        readIso14443B: false,
        readIso18092: false,
        readIso15693: false,
      );
      sessionStarted = true;

      if (tag.type != NFCTagType.iso7816) {
        throw SantekNfcException(
          'TAG_NOT_SUPPORTED',
          'Expected ISO-DEP tag but found: ${tag.type}',
        );
      }

      final protocol = SantekNfcProtocol(
        transceive: (cmd, timeout) =>
            FlutterNfcKit.transceive<Uint8List>(cmd, timeout: timeout),
      );

      final success = await protocol.writeDisplay(image, onProgress: onProgress);
      if (!success) {
        throw SantekNfcException('FLASH_FAILED', 'Display did not confirm completion.');
      }

      await _finishSession();
    } on SantekNfcException catch (e) {
      if (sessionStarted) await _finishSession();
      throw PlatformException(code: e.code, message: e.message);
    } on PlatformException {
      if (sessionStarted) await _finishSession();
      rethrow;
    } catch (e) {
      if (sessionStarted) await _finishSession();
      throw PlatformException(code: 'NFC_ERROR', details: e.toString());
    } finally {
      await _restoreSilentReaderMode();
    }
  }

  Future<void> _ensureNfcAvailable() async {
    final availability = await FlutterNfcKit.nfcAvailability;
    switch (availability) {
      case NFCAvailability.available:
        return;
      case NFCAvailability.disabled:
      case NFCAvailability.not_supported:
        throw const SantekNfcException('NFC_ERROR', 'NFC is not available or not enabled.');
    }
  }

  Future<void> _finishSession() async {
    try {
      await FlutterNfcKit.finish();
    } catch (_) {}
  }

  Future<void> _restoreSilentReaderMode() async {
    try {
      await _platform.invokeMethod('disableNfcReaderMode');
    } on MissingPluginException {
      // no-op
    } on PlatformException {
      // no-op
    }
  }
}
