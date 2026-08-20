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
  static const _retryPollTimeout = Duration(seconds: 8);
  static const _recoveryWindow = Duration(seconds: 12);
  static const _maxAttempts = 3;

  static const _retryableCodes = {'NFC_COMMUNICATION', 'FLASH_FAILED'};

  Future<void> flashImage(
    img.Image image,
    int ePaperSize, {
    WaveshareProgressCallback? onProgress,
    void Function()? onWaitingForTag,
  }) async {
    try {
      final profile = WaveshareNfcProfile.fromType(ePaperSize);
      final imageData = WaveshareImageCodec().encode(profile, image);

      await _ensureNfcAvailable();
      onProgress?.call(0);

      DateTime? recoveryDeadline;
      WaveshareNfcException? lastError;

      for (var attempt = 1; attempt <= _maxAttempts; attempt++) {
        onWaitingForTag?.call();
        try {
          await _flashOnce(profile, imageData, attempt, onProgress: onProgress);
          return;
        } on WaveshareNfcException catch (error) {
          if (!_retryableCodes.contains(error.code)) {
            throw PlatformException(code: error.code);
          }
          lastError = error;
          recoveryDeadline ??= DateTime.now().add(_recoveryWindow);
        } on PlatformException {
          if (recoveryDeadline == null) {
            rethrow;
          }
        }

        if (DateTime.now().isAfter(recoveryDeadline)) {
          throw PlatformException(code: lastError?.code ?? 'FLASH_FAILED');
        }

        onProgress?.call(0);
        await Future.delayed(const Duration(milliseconds: 150));
      }

      throw PlatformException(code: lastError?.code ?? 'FLASH_FAILED');
    } on PlatformException {
      rethrow;
    } catch (error) {
      throw PlatformException(
        code: 'NFC_ERROR',
        details: error.toString(),
      );
    } finally {
      await restoreSilentReaderMode();
    }
  }

  Future<void> _flashOnce(
    WaveshareNfcProfile profile,
    WaveshareImageData imageData,
    int attempt, {
    WaveshareProgressCallback? onProgress,
  }) async {
    var sessionStarted = false;
    try {
      await _pauseSilentReaderMode();

      final tag = await FlutterNfcKit.poll(
        timeout: attempt == 1 ? _pollTimeout : _retryPollTimeout,
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
          'NFC tag type not supported: ${tag.type}',
        );
      }

      final bool isIsoDep = tag.type == NFCTagType.iso7816;
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
        isIsoDep: isIsoDep,
      );

      if (!success) {
        throw WaveshareNfcException(
          'FLASH_FAILED',
          'Failed to write over NFC, unknown reason.',
        );
      }
    } finally {
      if (sessionStarted) {
        await _finishSession();
      }
      await restoreSilentReaderMode();
    }
  }

  Future<void> _pauseSilentReaderMode() async {
    try {
      await platform.invokeMethod('pauseNfcReaderMode');
    } on MissingPluginException {
      return;
    } on PlatformException {
      return;
    }
  }

  Future<void> restoreSilentReaderMode() async {
    try {
      await platform.invokeMethod('resumeNfcReaderMode');
    } on MissingPluginException {
      // Ignoring exception on platforms without the Android NFC bridge.
    } on PlatformException {
      // Ignoring exception
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
        tag.type == NFCTagType.iso7816 ||
        tag.type == NFCTagType.mifare_ultralight ||
        tag.type == NFCTagType.mifare_classic ||
        tag.type == NFCTagType.mifare_desfire ||
        tag.type == NFCTagType.mifare_plus;
  }

  Future<void> _finishSession() async {
    try {
      await FlutterNfcKit.finish();
    } catch (_) {
      // Ignoring finish errors because the NFC session may already be closed.
    }
  }
}
