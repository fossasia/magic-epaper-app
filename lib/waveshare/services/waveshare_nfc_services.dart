import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/waveshare/models/waveshare_nfc_exception.dart';
import 'package:magicepaperapp/waveshare/models/waveshare_nfc_profile.dart';
import 'package:magicepaperapp/waveshare/services/waveshare_image_codec.dart';
import 'package:magicepaperapp/waveshare/services/waveshare_nfc_protocol.dart';

class WaveShareNfcServices {
  static const platform = MethodChannel('org.fossasia.magicepaperapp/nfc');
  static const _pollTimeout = Duration(minutes: 2);
  static const _successMessage = 'Image flashed successfully!';

  Future<String> flashImage(
    img.Image image,
    int ePaperSize, {
    WaveshareProgressCallback? onProgress,
  }) async {
    var sessionStarted = false;

    try {
      final profile = WaveshareNfcProfile.fromType(ePaperSize);
      final imageData = WaveshareImageCodec().encode(profile, image);

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

      if (!_isSupportedWaveshareTag(tag)) {
        throw WaveshareNfcException(
          'TAG_NOT_SUPPORTED',
          'NFC tag type not supported.',
        );
      }

      final protocol = WaveshareNfcProtocol(
        transceive: (command, timeout) {
          return FlutterNfcKit.transceive<Uint8List>(
            command,
            timeout: timeout,
          );
        },
      );

      final success = await protocol.writeDisplay(
        profile,
        imageData,
        onProgress: onProgress,
      );

      if (!success) {
        throw WaveshareNfcException(
          'FLASH_FAILED',
          'Failed to write over NFC, unknown reason.',
        );
      }

      await _finishSession(success: true);
      return _successMessage;
    } on WaveshareNfcException catch (error) {
      if (sessionStarted) {
        await _finishSession(errorMessage: error.message);
      }
      throw PlatformException(code: error.code, message: error.message);
    } on PlatformException {
      if (sessionStarted) {
        await _finishSession(errorMessage: 'NFC communication failed.');
      }
      rethrow;
    } catch (error) {
      if (sessionStarted) {
        await _finishSession(errorMessage: error.toString());
      }
      throw PlatformException(
        code: 'NFC_ERROR',
        message: 'Failed to write over NFC: $error',
      );
    } finally {
      await restoreSilentReaderMode();
    }
  }

  Future<void> restoreSilentReaderMode() async {
    try {
      await platform.invokeMethod('disableNfcReaderMode');
    } on PlatformException {
      /// Ignoring exception
    }
  }

  Future<void> _ensureNfcAvailable() async {
    final availability = await FlutterNfcKit.nfcAvailability;
    switch (availability) {
      case NFCAvailability.available:
        return;
      case NFCAvailability.disabled:
        throw const WaveshareNfcException(
          'NFC_ERROR',
          'NFC is not available or not enabled.',
        );
      case NFCAvailability.not_supported:
        throw const WaveshareNfcException(
          'NFC_ERROR',
          'NFC is not available or not enabled.',
        );
    }
  }

  bool _isSupportedWaveshareTag(NFCTag tag) {
    final standard = tag.standard.toLowerCase();
    return standard.contains('type a') ||
        tag.type == NFCTagType.mifare_ultralight ||
        tag.type == NFCTagType.mifare_classic ||
        tag.type == NFCTagType.mifare_desfire ||
        tag.type == NFCTagType.mifare_plus;
  }

  Future<void> _finishSession({
    bool success = false,
    String? errorMessage,
  }) async {
    try {
      await FlutterNfcKit.finish(
        iosAlertMessage: success ? _successMessage : null,
        iosErrorMessage: success ? null : errorMessage,
      );
    } catch (_) {
      /// Ignoring finish errors because the NFC session may already be closed.
    }
  }
}
