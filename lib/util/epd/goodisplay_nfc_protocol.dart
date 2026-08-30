import 'dart:io';
import 'dart:typed_data';
import 'package:app_settings/app_settings.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/util/app_logger.dart';
import 'package:magicepaperapp/util/epd/display_device.dart';
import 'package:magicepaperapp/util/nfc_settings_launcher.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

typedef GoodisplayProgressCallback = void Function(
    double progress, String status);

class EpdModelConfig {
  final String model;
  final int width;
  final int height;
  final int mode; // 2: B/W, 3: B/W/R, 4: 4-Color
  final int ic; // 1 o 2

  const EpdModelConfig({
    required this.model,
    required this.width,
    required this.height,
    required this.mode,
    required this.ic,
  });

  static const Map<String, EpdModelConfig> models = {
    // 2-Color (B/W)
    "GDEY0154D67": EpdModelConfig(
        model: "GDEY0154D67", width: 200, height: 200, mode: 2, ic: 2),
    "GDEY0213B74": EpdModelConfig(
        model: "GDEY0213B74", width: 250, height: 128, mode: 2, ic: 2),
    "GDEY029T94": EpdModelConfig(
        model: "GDEY029T94", width: 296, height: 128, mode: 2, ic: 2),
    "GDEY042T81": EpdModelConfig(
        model: "GDEY042T81", width: 400, height: 300, mode: 2, ic: 2),
    "GDEW0154T8D": EpdModelConfig(
        model: "GDEW0154T8D", width: 152, height: 152, mode: 2, ic: 1),
    "GDEW0213T5D": EpdModelConfig(
        model: "GDEW0213T5D", width: 212, height: 104, mode: 2, ic: 1),
    "GDEW029T5D": EpdModelConfig(
        model: "GDEW029T5D", width: 296, height: 128, mode: 2, ic: 1),
    "GDEW042T2": EpdModelConfig(
        model: "GDEW042T2", width: 400, height: 300, mode: 2, ic: 1),
    "GDEY037T03": EpdModelConfig(
        model: "GDEY037T03", width: 416, height: 240, mode: 2, ic: 1),

    // 3-Color (B/W/R)
    "GDEY0154Z90": EpdModelConfig(
        model: "GDEY0154Z90", width: 200, height: 200, mode: 3, ic: 2),
    "GDEY0213Z98": EpdModelConfig(
        model: "GDEY0213Z98", width: 250, height: 128, mode: 3, ic: 2),
    "GDEY029Z95": EpdModelConfig(
        model: "GDEY029Z95", width: 296, height: 128, mode: 3, ic: 2),
    "GDEY042Z98": EpdModelConfig(
        model: "GDEY042Z98", width: 400, height: 300, mode: 3, ic: 2),
    "GDEW0213Z16": EpdModelConfig(
        model: "GDEW0213Z16", width: 212, height: 104, mode: 3, ic: 1),
    "GDEW029Z13": EpdModelConfig(
        model: "GDEW029Z13", width: 296, height: 128, mode: 3, ic: 1),
    "GDEQ042Z21": EpdModelConfig(
        model: "GDEQ042Z21", width: 400, height: 300, mode: 3, ic: 1),
    "GDEY037Z03": EpdModelConfig(
        model: "GDEY037Z03", width: 416, height: 240, mode: 3, ic: 1),

    // 4-Color (B/W/R/Y)
    "GDEM0097F51": EpdModelConfig(
        model: "GDEM0097F51", width: 184, height: 88, mode: 4, ic: 1),
    "GDEM0154F51H": EpdModelConfig(
        model: "GDEM0154F51H", width: 200, height: 200, mode: 4, ic: 1),
    "GDEY0213F51": EpdModelConfig(
        model: "GDEY0213F51", width: 250, height: 128, mode: 4, ic: 1),
    "GDEY0213F52": EpdModelConfig(
        model: "GDEY0213F52", width: 250, height: 128, mode: 4, ic: 1),
    "GDEY0266F51": EpdModelConfig(
        model: "GDEY0266F51", width: 296, height: 152, mode: 4, ic: 1),
    "GDEY0266F51H": EpdModelConfig(
        model: "GDEY0266F51H", width: 360, height: 184, mode: 4, ic: 1),
    "GDEY029F51": EpdModelConfig(
        model: "GDEY029F51", width: 296, height: 128, mode: 4, ic: 1),
    "GDEY029F51H": EpdModelConfig(
        model: "GDEY029F51H", width: 384, height: 168, mode: 4, ic: 1),
    "GDEM037F52": EpdModelConfig(
        model: "GDEM037F52", width: 416, height: 240, mode: 4, ic: 1),
    "GDEM042F52": EpdModelConfig(
        model: "GDEM042F52", width: 400, height: 300, mode: 4, ic: 1),
  };

  static List<String> getInitCommands(String epd) {
    switch (epd) {
      case "GDEW0154T8D":
        return [
          "F0DB000068A006022000980098A4010CA502000AA40108A502000AA4010CA502000AA40108A502000AA4010CA502000AA40108A502000AA4010CA502000AA40103A102001FA10461980098A1025097A10104A40103A3021013A20112A502000AA40103A20102A40103A20207A5",
          "F0DA000003F00220"
        ];
      case "GDEW0213T5D":
        return [
          "F0DB000068A0061020006800D4A4010CA502000AA40108A502000AA4010CA502000AA40108A502000AA4010CA502000AA40108A502000AA4010CA502000AA40103A102001FA104616800D4A1025097A10104A40103A3021013A20112A502000AA40103A20102A40103A20207A5",
          "F0DA000003F01020"
        ];
      case "GDEW029T5D":
        return [
          "F0DB000068A006012000800128A4010CA502000AA40108A502000AA4010CA502000AA40108A502000AA4010CA502000AA40108A502000AA4010CA502000AA40103A102001FA10461800128A1025097A10104A40103A3021013A20112A502000AA40103A20102A40103A20207A5",
          "F0DA000003F00120"
        ];
      case "GDEY037T03":
        return [
          "F0DB00005EA006512000F001A0A4010CA502000AA40108A502000AA4010CA502000AA40108A502000AA4010CA502000AA40108A502000AA4010CA502000AA40103A102001FA10104A40103A3021013A20112A502000AA40103A20102A40103A20207A5",
          "F0DA000003F05120"
        ];
      case "GDEW042T2":
        return [
          "F0DB000069A00603200190012CA4010CA502000AA40108A502000AA4010CA502000AA40108A502000AA4010CA502000AA40108A502000AA4010CA502000AA40103A102001FA105610190012CA1025097A10104A40103A3021013A20112A502000AA40103A20102A40103A20207A5",
          "F0DA000003F00320"
        ];
      case "GDEW0213Z16":
        return [
          "F0DB000068A0061030006800D4A4010CA502000AA40108A502000AA4010CA502000AA40108A502000AA4010CA502000AA40108A502000AA4010CA502000AA40103A102000FA104616800D4A1025077A10104A40103A3021013A20112A502000AA40103A20102A40103A20207A5",
          "F0DA000003F01030"
        ];
      case "GDEW029Z13":
        return [
          "F0DB000068A006013000800128A4010CA502000AA40108A502000AA4010CA502000AA40108A502000AA4010CA502000AA40108A502000AA4010CA502000AA40103A102000FA10461800128A1025077A10104A40103A3021013A20112A502000AA40103A20102A40103A20207A5",
          "F0DA000003F00130"
        ];
      case "GDEQ042Z21":
        return [
          "F0DB000069A00603300190012CA4010CA502000AA40108A502000AA4010CA502000AA40108A502000AA4010CA502000AA40108A502000AA4010CA502000AA40103A102000FA105610190012CA1025077A10104A40103A3021013A20112A502000AA40103A20102A40103A20207A5",
          "F0DA000003F00330"
        ];
      case "GDEY0154D67":
        return [
          "F0DB000062A006122000C800C8A4010CA502000AA40108A502000AA4010CA502000AA40102A10112A40102A10401C70001A1021101A103440018A10545C7000000A1023C05A1021880A1024E00A1034FC700A30124A20222F7A20120A40102A2021001A502000A",
          "F0DA000003F01220"
        ];
      case "GDEY0213B74":
        return [
          "F0DB000067A0060020007A00FAA4010CA502000AA40108A502000AA4010CA502000AA40102A10112A40102A10401270101A1021101A10344000FA1054527010000A1023C05A103210080A1021880A1024E00A1034F2701A30124A20222F7A20120A40102A2021001A502000A",
          "F0DA000003F00020"
        ];
      case "GDEY029T94":
        return [
          "F0DB000067A006012000800128A4010CA502000AA40108A502000AA4010CA502000AA40102A10112A40102A10401270101A1021101A10344000FA1054527010000A1023C05A103210080A1021880A1024E00A1034F2701A30124A20222F7A20120A40102A2021001A502000A",
          "F0DA000003F00120"
        ];
      case "GDEY042T81":
        return [
          "F0DB000063A00603300190012CA4010CA502000AA40108A502000AA4010CA502000AA40102A10112A40102A104012B0101A1021101A103440031A105452B010000A1023C01A1021880A1024E00A1034F2B01A3022426A20222F7A20120A40102A2021001A502000A",
          "F0DA000003F00330"
        ];
      case "GDEY0154Z90":
        return [
          "F0DB000063A006123000C800C8A4010CA502000AA40108A502000AA4010CA502000AA40102A10112A40102A10401C70001A1021101A103440018A10545C7000000A1023C05A1021880A1024E00A1034FC700A3022426A20222F7A20120A40102A2021001A502000A",
          "F0DA000003F01230"
        ];
      case "GDEY0213Z98":
        return [
          "F0DB000068A0060030007A00FAA4010CA502000AA40108A502000AA4010CA502000AA40102A10112A40102A10401270101A1021101A10344000FA1054527010000A1023C05A103210080A1021880A1024E00A1034F2701A3022426A20222F7A20120A40102A2021001A502000A",
          "F0DA000003F00030"
        ];
      case "GDEY029Z95":
        return [
          "F0DB000068A006013000800128A4010CA502000AA40108A502000AA4010CA502000AA40102A10112A40102A10401270101A1021101A10344000FA1054527010000A1023C05A103210080A1021880A1024E00A1034F2701A3022426A20222F7A20120A40102A2021001A502000A",
          "F0DA000003F00130"
        ];
      case "GDEY042Z98":
        return [
          "F0DB000063A00603300190012CA4010CA502000AA40108A502000AA4010CA502000AA40102A10112A40102A104012B0101A1021101A103440031A105452B010000A1023C01A1021880A1024E00A1034F2B01A3022426A20222F7A20120A40102A2021001A502000A",
          "F0DA000003F00330"
        ];
      case "GDEY037Z03":
        return [
          "F0DB00005EA006513000F001A0A4010CA502000AA40108A502000AA4010CA502000AA40108A502000AA4010CA502000AA40108A502000AA4010CA502000AA40103A102000FA10104A40103A3021013A20112A502000AA40103A20102A40103A20207A5",
          "F0DA000003F05130"
        ];
      case "GDEM0097F51":
        return [
          "F0DB000076A006072000B000B8A40108A5020028A4010CA5020028A40103A1024D78A103000F29A103010700A10403105444A1080605003F0A25121AA1025037A103600202A10561005800B8A102E71CA102E322A102B4D0A102E901A1023008A10104A40103A30110A2021200A40103A2020200A40103A20207A5",
          "F0DA000003F00720"
        ];
      case "GDEM0154F51H":
        return [
          "F0DB00005AA0061220019000C8A40108A5020028A4010CA5020028A40103A1024D78A103000F29A108060D123020192A22A1025037A1056100C800C8A102E901A1023008A10104A40103A30110A2021200A40103A2020200A40103A20207A5",
          "F0DA000003F01220"
        ];
      case "GDEY0213F51":
        return [
          "F0DB00007AA0060020010000FAA40108A5020028A4010CA5020028A40103A1024D78A103000F29A103010700A10403105444A1080605003F0A25121AA1025037A103600202A10561008000FAA102E71CA102E322A102B4D0A102B503A102E901A1023008A10104A40103A30110A2021200A40103A2020200A40103A20207A5",
          "F0DA000003F00020"
        ];
      case "GDEY0213F52":
        return [
          "F0DB000038A0060020010000FAA40108A5020028A4010CA5020028A40103A102E901A10104A40103A30110A2021200A40103A2020200A40103A20207A5",
          "F0DA000003F00020"
        ];
      case "GDEY0266F51":
        return [
          "F0DB00007AA006062001300128A40108A5020028A4010CA5020028A40103A1024D78A103000F29A103010700A10403105444A1080605003F0A25121AA1025037A103600202A1056100980128A102E71CA102E322A102B4D0A102B503A102E901A1023008A10104A40103A30110A2021200A40103A2020200A40103A20207A5",
          "F0DA000003F00620"
        ];
      case "GDEY0266F51H":
        return [
          "F0DB00007AA006062001700168A40108A5020028A4010CA5020028A40103A1024D78A103000F29A103010700A10403105444A1080605003F0A25121AA1025037A103600202A1056100B80168A102E71CA102E322A102B4D0A102B503A102E901A1023008A10104A40103A30110A2021200A40103A2020200A40103A20207A5",
          "F0DA000003F00620"
        ];
      case "GDEY029F51":
        return [
          "F0DB00007AA006012001000128A40108A5020028A4010CA5020028A40103A1024D78A103000F29A103010700A10403105444A1080605003F0A25121AA1025037A103600202A1056100800128A102E71CA102E322A102B4D0A102B503A102E901A1023008A10104A40103A30110A2021200A40103A2020200A40103A20207A5",
          "F0DA000003F00120"
        ];
      case "GDEY029F51H":
        return [
          "F0DB00007AA006012001500180A40108A5020028A4010CA5020028A40103A1024D78A103000F29A103010700A10403105444A1080605003F0A25121AA1025037A103600202A1056100A80180A102E71CA102E322A102B4D0A102B503A102E901A1023008A10104A40103A30110A2021200A40103A2020200A40103A20207A5",
          "F0DA000003F00120"
        ];
      case "GDEM037F52":
        return [
          "F0DB0000A5A006512001E001A0A40108A5020028A4010CA5020028A40103A103000F29A10701070022780A22A10403105444A10406C0C0C0A1023008A1024100A1025037A103600202A1056100F001A0A1056500000000A102E71CA102E322A102FFA5A107EF011E0A1B0B17A108C3FDDC01DD08DE41A10301E803A102DA07A102C900A102A80FA102FFE3A102E901A10104A40103A30110A2021200A40103A2020200A40103A20207A5",
          "F0DA000003F05120"
        ];
      case "GDEM042F52":
        return [
          "F0DB00006AA00603300190012CA40108A5020028A4010CA5020028A40103A1024D78A103000F29A108060D122425122910A1023008A1025037A10561012C0190A102AECFA102B013A102BD07A102BEFEA102E901A10104A40103A30110A2021200A40103A2020200A40103A20207A5",
          "F0DA000003F00330"
        ];
      default:
        return [];
    }
  }

  static int getRefreshDuration(String epd) {
    if (["GDEY0154D67", "GDEY0213B74", "GDEY029T94"].contains(epd)) return 2;
    if ([
      "GDEY042T81",
      "GDEW0154T8D",
      "GDEW0213T5D",
      "GDEW029T5D",
      "GDEW042T2",
      "GDEY037T03"
    ].contains(epd)) return 3;
    if (["GDEY0213F52"].contains(epd)) return 16;
    if (["GDEY0266F51", "GDEY029F51", "GDEY0266F51H", "GDEY029F51H"]
        .contains(epd)) return 24;
    return 20;
  }
}

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

  Future<void> _checkNfcAvailability() async {
    final availability = await FlutterNfcKit.nfcAvailability;
    switch (availability) {
      case NFCAvailability.available:
        return;
      case NFCAvailability.disabled:
        Fluttertoast.showToast(
            msg: appLocalizations.nfcIsDisabledPleaseEnableIt);
        if (Platform.isAndroid) {
          await NFCSettingsLauncher.openNFCSettings();
        } else if (Platform.isIOS) {
          await AppSettings.openAppSettings();
        }
        throw Exception(appLocalizations.nfcIsDisabledPleaseEnableIt);
      case NFCAvailability.not_supported:
        Fluttertoast.showToast(
            msg: appLocalizations.thisDeviceDoesNotSupportNfc);
        throw Exception(appLocalizations.thisDeviceDoesNotSupportNfc);
    }
  }

  Uint8List _getPictureDataSsd(img.Image bitmap, int mode) {
    final int width = bitmap.width;
    final int height = bitmap.height;
    final int bytesPerColumn = (height + 7) ~/ 8;
    final int totalBytes = width * bytesPerColumn;
    final Uint8List buffer = Uint8List(totalBytes)
      ..fillRange(0, totalBytes, 0xFF);
    int num = 0;

    for (int col = width - 1; col >= 0; col--) {
      for (int i = 0; i < bytesPerColumn; i++) {
        int b = 0;
        for (int j = 0; j < 8; j++) {
          b = (b << 1) & 0xFF;
          final int y = i * 8 + j;

          if (y < height) {
            final pixel = bitmap.getPixel(col, y);
            final int r = pixel.r.toInt();
            final int g = pixel.g.toInt();
            final int bCol = pixel.b.toInt();

            if (mode == 0) {
              if (r > 100 || g > 100 || bCol > 100) b = (b | 1) & 0xFF;
            } else if (mode == 1) {
              if (r < 100 || g > 100 || bCol > 100) b = (b | 1) & 0xFF;
            }
          } else {
            b = (b | 1) & 0xFF;
          }
        }
        buffer[num++] = b;
      }
    }
    return buffer;
  }

  Uint8List _encodeGoodisplay4G(img.Image bitmap) {
    final int width = bitmap.width;
    final int height = bitmap.height;
    final int bytesPerColumn = (height + 3) ~/ 4;
    final int totalBytes = width * bytesPerColumn;

    final Uint8List imageBuffer = Uint8List(totalBytes)
      ..fillRange(0, totalBytes, 0x55);
    int num = 0;

    for (int num2 = width - 1; num2 >= 0; num2--) {
      for (int i = 0; i < bytesPerColumn; i++) {
        int b = 0;
        for (int j = 0; j < 4; j++) {
          b = (b << 2) & 0xFF;
          final int y = i * 4 + j;

          if (y < height) {
            final pixel = bitmap.getPixel(num2, y);
            final int r = pixel.r.toInt();
            final int g = pixel.g.toInt();
            final int bCol = pixel.b.toInt();

            if (r <= 100 && g <= 100 && bCol <= 100) {
              continue;
            }
            if (r >= 200 && g >= 200 && bCol >= 200) {
              b = (b | 1) & 0xFF;
              continue;
            }

            final int avg = (r + g + bCol) ~/ 3;
            b = (b | (avg > 127 ? 2 : 3)) & 0xFF;
          } else {
            b = (b | 1) & 0xFF;
          }
        }
        imageBuffer[num++] = b;
      }
    }
    return imageBuffer;
  }

  Future<void> sendImage({
    required img.Image image,
    required DisplayDevice display,
    GoodisplayProgressCallback? onProgress,
  }) async {
    await _checkNfcAvailability();

    final config = EpdModelConfig.models[display.modelId];
    if (config == null) {
      throw Exception('Display model "${display.modelId}" is not configured.');
    }

    final initCmds = EpdModelConfig.getInitCommands(display.modelId);
    if (initCmds.isEmpty) {
      throw Exception('Missing init commands for "${display.modelId}".');
    }

    onProgress?.call(0.0, appLocalizations.waitingForNfcTag);
    Fluttertoast.showToast(
        msg: appLocalizations.bringPhoneNearMagicEpaperHardware);

    await FlutterNfcKit.poll(
      timeout: timeout,
      iosAlertMessage: appLocalizations.bringPhoneNearMagicEpaperHardware,
    );

    try {
      onProgress?.call(0.05, appLocalizations.tagDetectedInitializing);

      // Handshake
      await FlutterNfcKit.transceive('F0DB020000');
      await Future.delayed(const Duration(milliseconds: 10));

      // Init hardware
      for (final cmd in initCmds) {
        await FlutterNfcKit.transceive(cmd);
        await Future.delayed(const Duration(milliseconds: 10));
      }
      await Future.delayed(const Duration(milliseconds: 100));

      onProgress?.call(0.20, appLocalizations.processingImageData);

      final targetWidth = display.width;
      final targetHeight = display.height;

      img.Image panelImage = image;
      if (panelImage.width != targetWidth ||
          panelImage.height != targetHeight) {
        panelImage = img.copyResize(
          panelImage,
          width: targetWidth,
          height: targetHeight,
        );
      }

      const int screenIndexBW = 0;
      const int screenIndexR = 1;

      if (config.ic == 2) {
        if (config.mode == 2) {
          final buf = _getPictureDataSsd(panelImage, 0);
          final int total = buf.length;
          await _sendChunks(buf, total, screenIndexBW, 1.0, 0, onProgress);
        } else if (config.mode == 3) {
          final bufBw = _getPictureDataSsd(panelImage, 0);
          final int total = bufBw.length;
          await _sendChunks(bufBw, total, screenIndexBW, 2.0, 0, onProgress);

          await Future.delayed(const Duration(milliseconds: 10));

          final bufR = _getPictureDataSsd(panelImage, 1);
          await _sendChunks(bufR, total, screenIndexR, 2.0, total, onProgress,
              invert: true);
        }
      } else if (config.ic == 1) {
        if (config.mode == 2) {
          final buf = _getPictureDataSsd(panelImage, 0);
          final int total = buf.length;
          final empty = Uint8List(total)..fillRange(0, total, 255);
          await _sendChunks(empty, total, screenIndexBW, 2.0, 0, onProgress);
          await _sendChunks(buf, total, screenIndexR, 2.0, total, onProgress);
        } else if (config.mode == 3) {
          final bufBw = _getPictureDataSsd(panelImage, 0);
          final int total = bufBw.length;
          await _sendChunks(bufBw, total, screenIndexBW, 2.0, 0, onProgress);

          await Future.delayed(const Duration(milliseconds: 10));

          final bufR = _getPictureDataSsd(panelImage, 1);
          final bool invert = (config.model == "GDEY037Z03");
          await _sendChunks(bufR, total, screenIndexR, 2.0, total, onProgress,
              invert: invert);
        } else if (config.mode == 4) {
          final buf4G = _encodeGoodisplay4G(panelImage);
          final int total = buf4G.length;
          await _sendChunks(buf4G, total, screenIndexBW, 1.0, 0, onProgress,
              delayMs: 50);
        }
      }

      onProgress?.call(0.95, appLocalizations.refreshingDisplay);

      final refreshCmd = (config.mode == 4)
          ? Uint8List.fromList([240, 212, 133, 128, 0])
          : Uint8List.fromList([240, 212, 5, 128, 0]);

      final respHex = await FlutterNfcKit.transceive(
        refreshCmd.map((b) => b.toRadixString(16).padLeft(2, '0')).join(),
      );

      final respBytes = _hexToBytes(respHex);
      if (respBytes.isNotEmpty && respBytes[0] == 144) {
        AppLogger.info('RF power for refresh completion...');
        final int refreshSeconds =
            EpdModelConfig.getRefreshDuration(config.model);
        for (int s = 1; s <= refreshSeconds; s++) {
          await Future.delayed(const Duration(seconds: 1));
          onProgress?.call(0.95 + (0.05 * (s / refreshSeconds)),
              '${appLocalizations.refreshingDisplay} (${s}s/$refreshSeconds)');
        }
      }

      onProgress?.call(1.0, appLocalizations.transferComplete);
    } finally {
      await FlutterNfcKit.finish();
    }
  }

  Future<void> _sendChunks(
    Uint8List buffer,
    int totalBytes,
    int screenIndex,
    double progressDivisor,
    int baseOffset,
    GoodisplayProgressCallback? onProgress, {
    bool invert = false,
    int delayMs = 0,
  }) async {
    const int chunkSize = 250;
    final int totalChunks = totalBytes ~/ chunkSize;

    for (int i = 0; i < totalChunks; i++) {
      final packet = Uint8List(255);
      packet[0] = 240;
      packet[1] = 210;
      packet[2] = screenIndex;
      packet[3] = i;
      packet[4] = 250;

      for (int j = 0; j < 250; j++) {
        final val = buffer[j + (250 * i)];
        packet[j + 5] = invert ? (255 - val) : val;
      }

      await FlutterNfcKit.transceive(
        packet.map((b) => b.toRadixString(16).padLeft(2, '0')).join(),
      );

      if (delayMs > 0) {
        await Future.delayed(Duration(milliseconds: delayMs));
      }

      final double progress = 0.20 +
          (0.70 * ((250 * i + baseOffset) / (totalBytes * progressDivisor)));
      onProgress?.call(progress,
          '${appLocalizations.transferToEpaper} ${((i + 1) / totalChunks * 100).toInt()}%');
    }

    if (totalBytes % chunkSize != 0) {
      final packet = Uint8List(255);
      packet[0] = 240;
      packet[1] = 210;
      packet[2] = screenIndex;
      packet[3] = totalChunks;
      packet[4] = 250;

      for (int k = 0; k < 250; k++) {
        final int srcIdx = k + (250 * totalChunks);
        final val = srcIdx < buffer.length ? buffer[srcIdx] : 0;
        packet[k + 5] = invert ? (255 - val) : val;
      }

      await FlutterNfcKit.transceive(
        packet.map((b) => b.toRadixString(16).padLeft(2, '0')).join(),
      );
    }
  }
}
