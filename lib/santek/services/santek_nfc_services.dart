import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/santek/models/santek_nfc_exception.dart';
import 'package:magicepaperapp/santek/services/santek_image_codec.dart';
import 'package:magicepaperapp/santek/services/santek_nfc_protocol.dart';

typedef SantekProgressCallback = void Function(int progress);

class SantekNfcServices {
  static const _platform = MethodChannel('org.fossasia.magicepaperapp/nfc');
  static const _tagWaitTimeout = Duration(minutes: 2);

  Future<void> flashImage(
    img.Image image, {
    SantekProgressCallback? onProgress,
  }) async {
    try {
      final landscape =
          image.width < image.height ? img.copyRotate(image, angle: 90) : image;
      final data = SantekImageCodec().encode(landscape);

      await _ensureNfcAvailable();

      if (!await _isTagConnected()) {
        await _resetTag();
      }

      await _waitForTag(_tagWaitTimeout);
      onProgress?.call(0);

      final protocol = SantekNfcProtocol(
        transceive: (cmd, timeout) async {
          final response = await _platform.invokeMethod<Uint8List>(
            'transceive',
            {'data': cmd},
          );
          return response ?? Uint8List(0);
        },
      );

      await protocol.writeAndRefresh(data, onProgress: onProgress);
    } on SantekNfcException catch (e) {
      throw PlatformException(code: e.code, message: _friendlyMessage(e));
    } on PlatformException {
      rethrow;
    } catch (e) {
      throw PlatformException(
        code: 'NFC_ERROR',
        message:
            'Transfer failed. Keep the phone flat on the badge and try again.',
      );
    }
  }

  String _friendlyMessage(SantekNfcException e) {
    switch (e.code) {
      case 'TAG_TIMEOUT':
        return 'No display detected. Hold your phone on the badge and keep it still.';
      case 'AUTH_FAILED':
        return 'The badge did not respond. Re-position your phone over the display and try again.';
      case 'REFRESH_FAILED':
        return 'The image was sent but the display did not refresh. Hold the phone still and retry.';
      case 'NFC_ERROR':
        return e.message;
      case 'NFC_COMMUNICATION':
        return 'Lost connection to the badge mid-transfer. Keep the phone flat and steady on it, then try again.';
      default:
        return e.message;
    }
  }

  Future<void> _resetTag() async {
    try {
      await _platform.invokeMethod('resetTag');
    } on MissingPluginException {
      return;
    } on PlatformException {
      return;
    }
  }

  Future<bool> _isTagConnected() async {
    try {
      return await _platform.invokeMethod<bool>('isTagConnected') ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<void> _ensureNfcAvailable() async {
    final availability = await FlutterNfcKit.nfcAvailability;
    switch (availability) {
      case NFCAvailability.available:
        return;
      case NFCAvailability.disabled:
      case NFCAvailability.not_supported:
        throw const SantekNfcException(
            'NFC_ERROR', 'NFC is not available or not enabled.');
    }
  }

  Future<void> _waitForTag(Duration timeout) async {
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      if (await _isTagConnected()) return;
      await Future<void>.delayed(const Duration(milliseconds: 150));
    }
    throw const SantekNfcException(
      'TAG_TIMEOUT',
      'No display detected. Hold your phone steady on the badge.',
    );
  }
}
