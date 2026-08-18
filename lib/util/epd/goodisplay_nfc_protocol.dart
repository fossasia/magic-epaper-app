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

typedef GoodisplayProgressCallback = void Function(double progress, String status);

class GoodisplayNfcProtocol {
  final Duration timeout = const Duration(seconds: 8);

  // 1. Select NDEF Application (AID: D2760000850101)
  static final Uint8List selectAppletApdu = Uint8List.fromList([
    0x00, 0xA4, 0x04, 0x00, 0x07, 0xD2, 0x76, 0x00, 0x00, 0x85, 0x01, 0x01
  ]);

  // 2. Select NDEF Data File (File ID: E104)
  static final Uint8List selectNdefFileApdu = Uint8List.fromList([
    0x00, 0xA4, 0x00, 0x0C, 0x02, 0xE1, 0x04
  ]);

  String _toHex(List<int> bytes) =>
      bytes.map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase()).join(' ');

  Future<bool> _isNfcAvailable() async {
    final availability = await FlutterNfcKit.nfcAvailability;
    switch (availability) {
      case NFCAvailability.available:
        return true;
      case NFCAvailability.disabled:
        Fluttertoast.showToast(msg: appLocalizations.nfcIsDisabledPleaseEnableIt);
        if (Platform.isAndroid) {
          await NFCSettingsLauncher.openNFCSettings();
        } else if (Platform.isIOS) {
          await AppSettings.openAppSettings();
        }
        return false;
      case NFCAvailability.not_supported:
        Fluttertoast.showToast(msg: appLocalizations.thisDeviceDoesNotSupportNfc);
        return false;
    }
  }

  bool _isApduSuccess(Uint8List res) {
    if (res.length < 2) return false;
    return res[res.length - 2] == 0x90 && res[res.length - 1] == 0x00;
  }

  /// Codifica l'immagine 4 colori (296x128) in formato BWRY 2-bit per pixel
  /// Genera il payload a 2 piani separati (BW Plane + Red/Yellow Plane)
Uint8List encodeGoodisplayDualPlane(img.Image image, int width, int height) {
  final int planeSize = (width * height) ~/ 8; // 4736 byte per piano
  final Uint8List bwPlane = Uint8List(planeSize);
  final Uint8List ryPlane = Uint8List(planeSize);

  // Inizializza tutto a 1 (Bianco di default per E-Paper)
  bwPlane.fillRange(0, planeSize, 0xFF);
  ryPlane.fillRange(0, planeSize, 0x00);

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      final pixel = image.getPixel(x, y);
      final r = pixel.r.toInt();
      final g = pixel.g.toInt();
      final b = pixel.b.toInt();

      final int byteIndex = (y * width + x) ~/ 8;
      final int bitOffset = 7 - (x % 8);

      // Riconoscimento colori
      final bool isBlack = (r < 80 && g < 80 && b < 80);
      final bool isRed = (r > 160 && g < 90 && b < 90);
      final bool isYellow = (r > 160 && g > 160 && b < 90);

      if (isBlack) {
        bwPlane[byteIndex] &= ~(1 << bitOffset); // 0 = Black nel piano BW
      } else if (isRed || isYellow) {
        ryPlane[byteIndex] |= (1 << bitOffset);  // 1 = Colore nel piano Red/Yellow
        if (isYellow) {
          bwPlane[byteIndex] &= ~(1 << bitOffset); // Bitmask differenziata per Yellow
        }
      }
    }
  }

  // Unisce i due piani in un unico stream di dati continuo
  return Uint8List.fromList([...bwPlane, ...ryPlane]);
}

  Future<void> sendImage({
    required img.Image image,
    required int width,
    required int height,
    GoodisplayProgressCallback? onProgress,
  }) async {
    if (!await _isNfcAvailable()) return;

    onProgress?.call(0.0, appLocalizations.waitingForNfcTag);
    Fluttertoast.showToast(msg: appLocalizations.bringPhoneNearMagicEpaperHardware);

    // 1. Polling
    final tag = await FlutterNfcKit.poll(
      timeout: timeout,
      iosAlertMessage: appLocalizations.bringPhoneNearMagicEpaperHardware,
    );

    if (tag.type != NFCTagType.iso7816 &&
        tag.type != NFCTagType.mifare_ultralight &&
        tag.type != NFCTagType.mifare_classic) {
      await FlutterNfcKit.finish();
      throw Exception('Target is not an ISO 14443-A Goodisplay badge');
    }

    onProgress?.call(0.1, appLocalizations.tagDetectedInitializing);

    // 2. Select NDEF Application
    final selectRes = await FlutterNfcKit.transceive(selectAppletApdu, timeout: timeout);
    if (!_isApduSuccess(selectRes)) {
      await FlutterNfcKit.finish();
      throw Exception('Failed to select NDEF Applet');
    }

    // 3. Select Data File (E104)
    final selectFileRes = await FlutterNfcKit.transceive(selectNdefFileApdu, timeout: timeout);
    if (!_isApduSuccess(selectFileRes)) {
      await FlutterNfcKit.finish();
      throw Exception('Failed to select File E104');
    }

    // 4. Preparazione buffer a 2 Piani
    onProgress?.call(0.2, appLocalizations.processingImageData);
    final Uint8List rawFrame = encodeGoodisplayDualPlane(image, width, height);

    // 5. HEADER DI START (Offset 0x0000)
    // Struttura: [Magic: 0xA5, Mode/Flag: 0x01, Model: 0x29, W_H, W_L, H_H, H_L]
    final startPacket = Uint8List.fromList([
      0xA5, 0x01, 0x29,
      (width >> 8) & 0xFF, width & 0xFF,
      (height >> 8) & 0xFF, height & 0xFF,
    ]);
    final startApdu = Uint8List.fromList([
      0x00, 0xD6, 0x00, 0x00, startPacket.length, ...startPacket
    ]);
    await FlutterNfcKit.transceive(startApdu, timeout: timeout);
    await Future.delayed(const Duration(milliseconds: 30));

    // 6. INVIO CHUNKS con flag di aggiornamento a offset 0x0000
    const int dataChunkSize = 56;
    final int totalChunks = (rawFrame.length / dataChunkSize).ceil();

    for (int i = 0; i < totalChunks; i++) {
      final int start = i * dataChunkSize;
      final int end = (start + dataChunkSize > rawFrame.length)
          ? rawFrame.length
          : start + dataChunkSize;
      final Uint8List chunkData = rawFrame.sublist(start, end);

      final int packetIndex = i + 1;
      
      // Header pacchetto: [Flag: 0xA5, BlockIdx_H, BlockIdx_L, DataLen]
      final packetPayload = Uint8List.fromList([
        0xA5,
        (packetIndex >> 8) & 0xFF,
        packetIndex & 0xFF,
        chunkData.length,
        ...chunkData,
      ]);

      // Scrittura a partire dall'offset 0x0000 così l'MCU legge sia la flag che il blocco
      final apduWrite = Uint8List.fromList([
        0x00,
        0xD6,
        0x00,
        0x00, // Scrive dall'inizio della mailbox (0x0000)
        packetPayload.length,
        ...packetPayload,
      ]);

      final writeRes = await FlutterNfcKit.transceive(apduWrite, timeout: timeout);
      if (!_isApduSuccess(writeRes)) {
        await FlutterNfcKit.finish();
        throw Exception('Failed block $packetIndex/$totalChunks');
      }

      // IMPORTANTE: Pausa minima per il DMA/I2C dell'MCU Goodisplay
      await Future.delayed(const Duration(milliseconds: 18));

      final progress = 0.2 + (0.75 * ((i + 1) / totalChunks));
      onProgress?.call(progress, '${appLocalizations.writingChunk} ${i + 1}/$totalChunks');
    }

    // 7. TRIGGER DI REFRESH FINALE
    onProgress?.call(0.95, appLocalizations.refreshingDisplay);

    // Pacchetto di fine e start refresh display:
    // Offset 0x0000: [0x5A, 0xFF, 0xFF, 0x01, totalChunks_H, totalChunks_L]
    final refreshPacket = Uint8List.fromList([
      0x5A, 0xFF, 0xFF, 0x01,
      (totalChunks >> 8) & 0xFF,
      totalChunks & 0xFF,
    ]);
    final refreshApdu = Uint8List.fromList([
      0x00, 0xD6, 0x00, 0x00, refreshPacket.length, ...refreshPacket
    ]);
    await FlutterNfcKit.transceive(refreshApdu, timeout: timeout);

    // 8. Mantieni il campo RF attivo durante l'avvio del refresh fisico
    AppLogger.info('Powering EPD physical refresh via RF harvesting...');
    await Future.delayed(const Duration(seconds: 8));

    onProgress?.call(1.0, appLocalizations.transferComplete);
    await FlutterNfcKit.finish();
  }
}