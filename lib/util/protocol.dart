import 'dart:io';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/util/epd/driver/waveform.dart';
import 'package:magicepaperapp/util/epd/epd.dart';
import 'package:app_settings/app_settings.dart';
import 'package:magicepaperapp/util/magic_epaper_firmware.dart';
import 'package:magicepaperapp/util/nfc_settings_launcher.dart';

typedef ProgressCallback = void Function(double progress, String status);
typedef TagDetectedCallback = void Function();

class Protocol {
  final fw = MagicEpaperFirmware();
  final Epd epd;
  final timeout = const Duration(seconds: 5);
  late Uint8List tagId;

  Protocol({required this.epd});

  Future<Uint8List> _transceive(nfcvCmd, Uint8List msg) async {
    final raw = fw.tagChip.buildMessage(nfcvCmd, tagId, msg);
    return await FlutterNfcKit.transceive(raw, timeout: timeout);
  }

  Future<Uint8List> writeMsg(Uint8List msg) async {
    return await _transceive(fw.tagChip.writeMsgCmd, msg);
  }

  Future<Uint8List> _readDynCfg(int address) async {
    final raw = fw.tagChip.buildReadDynCfgCmd(tagId, address);
    return await FlutterNfcKit.transceive(raw, timeout: timeout);
  }

  Future<Uint8List> _writeDynCfg(int address, int value) async {
    final raw = fw.tagChip.buildWriteDynCfgCmd(tagId, address, value);
    return await FlutterNfcKit.transceive(raw, timeout: timeout);
  }

  Future<bool> hasI2cGatheredMsg() async {
    return ((await _readDynCfg(0x0d)).elementAt(1) & 0x04) != 0x04;
  }

  Future<Uint8List> enableEnergyHarvesting() async {
    return await _writeDynCfg(0x02, 0x01);
  }

  Future<void> _sleep() async {
    await Future.delayed(const Duration(milliseconds: 20));
  }

  Future<void> wait4msgGathered() async {
    var attempt = 4;
    while (attempt > 0) {
      try {
        if (await hasI2cGatheredMsg()) {
          return; // Exit successfully if message is gathered
        }
      } catch (e) {
        throw Exception("Error checking message: $e");
      }
      attempt--;
      await _sleep(); // Wait before the next attempt
    }

    // If the loop completes without returning, it means the attempts timed out
    throw Exception("Timeout waiting for I2C message");
  }

  Future<void> writeFrame(Uint8List id, Uint8List frame, int cmd,
      {ProgressCallback? onProgress}) async {
    final chunks = _split(data: frame);
    await writeMsg(
        Uint8List.fromList([fw.epdCmd, cmd])); // enter transmission 1
    await _sleep();
    for (int i = 0; i < chunks.length; i++) {
      Uint8List chunk = chunks[i];
      debugPrint(
          "Writing chunk ${i + 1}/${chunks.length} len ${chunk.lengthInBytes}: ${chunk.map((e) => e.toRadixString(16)).toList()}");

      await writeMsg(chunk);
      await wait4msgGathered();
      if (onProgress != null) {
        final progress = (i + 1) / chunks.length;
        onProgress(progress, "Writing chunk ${i + 1}/${chunks.length}");
      }
    }
    debugPrint("Transferred successfully.");
  }

  List<Uint8List> _split({required Uint8List data, int chunkSize = 220}) {
    List<Uint8List> chunks = [];
    for (int i = 0; i < data.length; i += chunkSize) {
      int end = (i + chunkSize > data.length) ? data.length : i + chunkSize;
      Uint8List chunk =
          Uint8List.fromList([fw.epdSend, ...data.sublist(i, end)]);
      chunks.add(chunk);
    }
    return chunks;
  }

  Future<void> writeImages(
    img.Image image, {
    ProgressCallback? onProgress,
    TagDetectedCallback? onTagDetected,
    Waveform? waveform,
  }) async {
    var availability = await FlutterNfcKit.nfcAvailability;
    switch (availability) {
      case NFCAvailability.available:
        break;
      case NFCAvailability.disabled:
        Fluttertoast.showToast(msg: "NFC is disabled. Please enable it.");
        if (Platform.isAndroid) {
          await NFCSettingsLauncher.openNFCSettings();
        } else if (Platform.isIOS) {
          await AppSettings.openAppSettings();
        }
        return;
      case NFCAvailability.not_supported:
        Fluttertoast.showToast(msg: "This device does not support NFC.");
        return;
    }

    onProgress?.call(0.0, "Waiting for NFC tag...");
    Fluttertoast.showToast(
        msg: "Bring your phone near to the Magic Epaper Hardware");
    debugPrint("Bring your phone near to the Magic Epaper Hardware");
    final tag = await FlutterNfcKit.poll(timeout: timeout);
    debugPrint("Got a tag!");
    onTagDetected?.call();
    onProgress?.call(0.1, "Tag detected! Initializing...");

    tagId = Uint8List.fromList(hex.decode(tag.id));
    if (tag.type != NFCTagType.iso15693) {
      throw "Not a Magic Epaper Hardware";
    }

    onProgress?.call(0.15, "Enabling energy harvesting...");
    await enableEnergyHarvesting();
    await Future.delayed(
        const Duration(seconds: 2)); // waiting for the power supply stable

    await epd.controller.init(this, waveform: waveform);

    onProgress?.call(0.2, "Processing image data...");

    final epdColors = epd.extractEpaperColorFrames(image);
    final transmissionLines = epd.controller.transmissionLines.iterator;
    double baseProgress = 0.2;
    double frameProgressStep = 0.7 / epdColors.length;
    int frameIndex = 0;
    for (final c in epdColors) {
      transmissionLines.moveNext();
      final frameStartProgress =
          baseProgress + (frameIndex * frameProgressStep);
      await writeFrame(tagId, c, transmissionLines.current,
          onProgress: (chunkProgress, chunkStatus) {
        final totalProgress =
            frameStartProgress + (chunkProgress * frameProgressStep);
        onProgress?.call(totalProgress,
            "Frame ${frameIndex + 1}/${epdColors.length}: $chunkStatus");
      });
      frameIndex++;
    }
    onProgress?.call(0.95, "Refreshing display...");
    await writeMsg(Uint8List.fromList([fw.epdCmd, epd.controller.refresh]));
    onProgress?.call(1.0, "Transfer complete!");
    await FlutterNfcKit.finish();
  }
}
