import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as img;
import 'package:app_settings/app_settings.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/util/app_logger.dart';
import 'package:magicepaperapp/util/nfc_settings_launcher.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

typedef GoodisplayProgressCallback = void Function(
    double progress, String status);

class GoodisplayNfcProtocol {
  final Duration timeout = const Duration(seconds: 50);

  Uint8List _hexToBytes(String hex) {
    hex = hex.replaceAll(' ', '');
    final result = Uint8List(hex.length ~/ 2);
    for (int i = 0; i < hex.length; i += 2) {
      result[i ~/ 2] = int.parse(hex.substring(i, i + 2), radix: 16);
    }
    return result;
  }

  Future<bool> _isNfcAvailable() async {
    final availability = await FlutterNfcKit.nfcAvailability;
    switch (availability) {
      case NFCAvailability.available:
        return true;
      case NFCAvailability.disabled:
        Fluttertoast.showToast(
            msg: appLocalizations.nfcIsDisabledPleaseEnableIt);
        if (Platform.isAndroid) {
          await NFCSettingsLauncher.openNFCSettings();
        } else if (Platform.isIOS) {
          await AppSettings.openAppSettings();
        }
        return false;
      case NFCAvailability.not_supported:
        Fluttertoast.showToast(
            msg: appLocalizations.thisDeviceDoesNotSupportNfc);
        return false;
    }
  }

  Uint8List encodeGoodisplay4G(img.Image bitmap) {
    final int width = bitmap.width;
    final int height = bitmap.height;
    final Uint8List imageBuffer = Uint8List(100000);
    int num = 0;

    for (int num2 = width - 1; num2 >= 0; num2--) {
      for (int i = 0; i <= (height ~/ 4) - 1; i++) {
        int b = 0;
        for (int j = 0; j < 4; j++) {
          b = (b * 4) & 0xFF;
          final pixel = bitmap.getPixel(num2, i * 4 + j);

          final int r = pixel.r.toInt();
          final int g = pixel.g.toInt();
          final int bCol = pixel.b.toInt();

          if (r <= 100 && g <= 100 && bCol <= 100) {
            continue;
          }
          if (r >= 200 && g >= 200 && bCol >= 200) {
            b = (b + 1) & 0xFF;
            continue;
          }

          final int avg = (r + g + bCol) ~/ 3;
          b = (avg > 127 ? (b + 2) : (b + 3)) & 0xFF;
        }
        imageBuffer[num] = b;
        num++;
      }
    }
    return imageBuffer;
  }

  Future<void> sendImage({
    required img.Image image,
    required int width,
    required int height,
    GoodisplayProgressCallback? onProgress,
  }) async {
    if (!await _isNfcAvailable()) return;

    onProgress?.call(0.0, appLocalizations.waitingForNfcTag);
    Fluttertoast.showToast(
        msg: appLocalizations.bringPhoneNearMagicEpaperHardware);

    await FlutterNfcKit.poll(
      timeout: timeout,
      iosAlertMessage: appLocalizations.bringPhoneNearMagicEpaperHardware,
    );

    try {
      onProgress?.call(0.05, appLocalizations.tagDetectedInitializing);

      await FlutterNfcKit.transceive('F0DB020000');
      await Future.delayed(const Duration(milliseconds: 10));

      const String initCmd0 =
          "F0DB00007AA006012001000128A40108A5020028A4010CA5020028A40103A1024D78A103000F29A103010700A10403105444A1080605003F0A25121AA1025037A103600202A1056100800128A102E71CA102E322A102B4D0A102B503A102E901A1023008A10104A40103A30110A2021200A40103A2020200A40103A20207A5";
      const String initCmd1 = "F0DA000003F00120";

      await FlutterNfcKit.transceive(initCmd0);
      await Future.delayed(const Duration(milliseconds: 10));
      await FlutterNfcKit.transceive(initCmd1);
      await Future.delayed(const Duration(milliseconds: 100));

      onProgress?.call(0.20, appLocalizations.processingImageData);

      final panelImage = img.copyResize(image, width: 296, height: 128);
      final imageBuffer = encodeGoodisplay4G(panelImage);
      final int totalBytes = (panelImage.width * panelImage.height) ~/ 4;

      const int chunkSize = 250;
      final int totalChunks = totalBytes ~/ chunkSize;
      const int screenIndexBW = 0;

      for (int i = 0; i < totalChunks; i++) {
        final packet = Uint8List(255);
        packet[0] = 240;
        packet[1] = 210;
        packet[2] = screenIndexBW;
        packet[3] = i;
        packet[4] = 250;

        for (int j = 0; j < 250; j++) {
          packet[j + 5] = imageBuffer[j + (250 * i)];
        }

        await FlutterNfcKit.transceive(
          packet.map((b) => b.toRadixString(16).padLeft(2, '0')).join(),
        );
        await Future.delayed(const Duration(milliseconds: 50));

        final double progress = 0.20 + (0.70 * ((250 * i) / totalBytes));
        onProgress?.call(
            progress, '${appLocalizations.writingChunk} ${i + 1}/$totalChunks');
      }

      if (totalBytes % chunkSize != 0) {
        final packet = Uint8List(255);
        packet[0] = 240;
        packet[1] = 210;
        packet[2] = screenIndexBW;
        packet[3] = totalChunks;
        packet[4] = 250;

        for (int k = 0; k < 250; k++) {
          final int srcIdx = k + (250 * totalChunks);
          packet[k + 5] = srcIdx < imageBuffer.length ? imageBuffer[srcIdx] : 0;
        }

        await FlutterNfcKit.transceive(
          packet.map((b) => b.toRadixString(16).padLeft(2, '0')).join(),
        );
      }

      onProgress?.call(0.95, appLocalizations.refreshingDisplay);

      final refreshCmd = Uint8List.fromList([240, 212, 133, 128, 0]);
      final respHex = await FlutterNfcKit.transceive(
        refreshCmd.map((b) => b.toRadixString(16).padLeft(2, '0')).join(),
      );

      final respBytes = _hexToBytes(respHex);
      if (respBytes.isNotEmpty && respBytes[0] == 144) {
        AppLogger.info(
            'RF power for refresh completion (24s for GDEY029F51)...');

        const int refreshDurationSeconds = 24;
        for (int s = 1; s <= refreshDurationSeconds; s++) {
          await Future.delayed(const Duration(seconds: 1));
          onProgress?.call(0.95 + (0.05 * (s / refreshDurationSeconds)),
              '${appLocalizations.refreshingDisplay} (${s}s/$refreshDurationSeconds)');
        }
      }

      onProgress?.call(1.0, appLocalizations.transferComplete);
    } finally {
      await FlutterNfcKit.finish();
    }
  }
}
