import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/santek/models/santek_nfc_exception.dart';
import 'package:magicepaperapp/santek/services/santek_image_codec.dart';
import 'package:magicepaperapp/santek/services/santek_nfc_protocol.dart';

typedef SantekProgressCallback = void Function(int progress);

class SantekNfcServices {
  static const _platform = MethodChannel('org.fossasia.magicepaperapp/nfc');
  static const _pollTimeout = Duration(minutes: 2);

  Future<void> flashImage(
    img.Image image, {
    SantekProgressCallback? onProgress,
  }) async {
    final landscape = image.width < image.height
        ? img.copyRotate(image, angle: 90)
        : image;
    final data = SantekImageCodec().encode(landscape);

    var sessionStarted = false;

    try {
      await _ensureNfcAvailable();
      await _pauseSilentReaderMode();
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

      await protocol.writeAndRefresh(data, onProgress: onProgress);
    } on SantekNfcException catch (e) {
      throw PlatformException(code: e.code, message: e.message);
    } on PlatformException {
      rethrow;
    } catch (e) {
      throw PlatformException(code: 'NFC_ERROR', message: e.toString());
    } finally {
      if (sessionStarted) await _finishSession();
      await _resumeSilentReaderMode();
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

  Future<void> _pauseSilentReaderMode() async {
    try {
      await _platform.invokeMethod('pauseNfcReaderMode');
    } on MissingPluginException {
      // no-op
    } on PlatformException {
      // no-op
    }
  }

  Future<void> _resumeSilentReaderMode() async {
    try {
      await _platform.invokeMethod('resumeNfcReaderMode');
    } on MissingPluginException {
      // no-op
    } on PlatformException {
      // no-op
    }
  }

  Future<void> _finishSession() async {
    try {
      await FlutterNfcKit.finish();
    } catch (_) {}
  }
}
