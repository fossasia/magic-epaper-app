import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/waveshare/models/waveshare_nfc_exception.dart';
import 'package:magicepaperapp/waveshare/services/waveshare_g_image_codec.dart';
import 'package:magicepaperapp/waveshare/services/waveshare_g_nfc_protocol.dart';
import 'package:magicepaperapp/waveshare/services/waveshare_nfc_protocol.dart';

class WaveshareGNfcServices {
  static const platform = MethodChannel('org.fossasia.magicepaperapp/nfc');
  static const _pollTimeout = Duration(minutes: 2);

  Future<void> flashImage(
    img.Image image, {
    WaveshareProgressCallback? onProgress,
  }) async {
    var sessionStarted = false;

    try {
      final codec = WaveshareGImageCodec();
      final oriented = image.width > image.height
          ? img.copyRotate(image, angle: 270)
          : image;
      final imageData = codec.encodeVertical(oriented);
      final packetCount = codec.packetCount(oriented.width, oriented.height);

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
        throw WaveshareNfcException(
          'TAG_NOT_SUPPORTED',
          'Expected an ISO-DEP (G) tag but found: ${tag.type}',
        );
      }

      final protocol = WaveshareGNfcProtocol(
        transceive: (command, timeout) {
          return FlutterNfcKit.transceive<Uint8List>(command, timeout: timeout);
        },
      );

      final success = await protocol.writeDisplay(
        imageData,
        packetCount,
        onProgress: onProgress,
      );

      if (!success) {
        throw WaveshareNfcException(
          'FLASH_FAILED',
          'Failed to write over NFC, unknown reason.',
        );
      }

      await _finishSession();
    } on WaveshareNfcException catch (error) {
      if (sessionStarted) {
        await _finishSession();
      }
      throw PlatformException(code: error.code);
    } on PlatformException {
      if (sessionStarted) {
        await _finishSession();
      }
      rethrow;
    } catch (error) {
      if (sessionStarted) {
        await _finishSession();
      }
      throw PlatformException(code: 'NFC_ERROR', details: error.toString());
    } finally {
      await restoreSilentReaderMode();
    }
  }

  Future<void> restoreSilentReaderMode() async {
    try {
      await platform.invokeMethod('disableNfcReaderMode');
    } on MissingPluginException {
      // no-op
    } on PlatformException {
      // no-op
    }
  }

  Future<void> _ensureNfcAvailable() async {
    final availability = await FlutterNfcKit.nfcAvailability;
    switch (availability) {
      case NFCAvailability.available:
        return;
      case NFCAvailability.disabled:
      case NFCAvailability.not_supported:
        throw const WaveshareNfcException(
          'NFC_ERROR',
          'NFC is not available or not enabled.',
        );
    }
  }

  Future<void> _finishSession() async {
    try {
      await FlutterNfcKit.finish();
    } catch (_) {
      // no-op
    }
  }
}
