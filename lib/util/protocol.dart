import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:image/image.dart' as img;
import 'package:magic_epaper_app/util/epd/edp.dart';
import 'package:magic_epaper_app/util/magic_epaper_firmware.dart';

class Protocol {
  final fw = MagicEpaperFirmware();
  final Epd epd;
  final timeout = const Duration(seconds: 5);

  Protocol({required this.epd});

  Future<Uint8List> _transceive(nfcvCmd, Uint8List tagId, Uint8List msg) async {
    final raw = fw.tagChip.buildMessage(nfcvCmd, tagId, msg);
    return await FlutterNfcKit.transceive(raw, timeout: timeout);
  }

  Future<Uint8List> _writeMsg(Uint8List tagId, Uint8List msg) async {
    return await _transceive(fw.tagChip.writeMsgCmd, tagId, msg);
  }

  Future<Uint8List> _readDynCfg(Uint8List tagId, int address) async {
    final raw = fw.tagChip.buildReadDynCfgCmd(tagId, address);
    return await FlutterNfcKit.transceive(raw, timeout: timeout);
  }

  Future<Uint8List> _writeDynCfg(
      Uint8List tagId, int address, int value) async {
    final raw = fw.tagChip.buildWriteDynCfgCmd(tagId, address, value);
    return await FlutterNfcKit.transceive(raw, timeout: timeout);
  }

  Future<bool> hasI2cGatheredMsg(Uint8List tagId) async {
    return ((await _readDynCfg(tagId, 0x0d)).elementAt(1) & 0x04) != 0x04;
  }

  Future<Uint8List> enableEnergyHarvesting(Uint8List tagId) async {
    return await _writeDynCfg(tagId, 0x02, 0x01);
  }

  Future<void> _sleep() async {
    await Future.delayed(const Duration(milliseconds: 20));
  }

  Future<void> wait4msgGathered(Uint8List tagId) async {
    var attempt = 4;
    while (attempt > 0) {
      try {
        if (await hasI2cGatheredMsg(tagId)) {
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

  Future<void> writeFrame(Uint8List id, Uint8List frame, int cmd) async {
    final chunks = _split(data: frame);
    await _writeMsg(
        id, Uint8List.fromList([fw.epdCmd, cmd])); // enter transmission 1
    await _sleep();
    for (int i = 0; i < chunks.length; i++) {
      Uint8List chunk = chunks[i];
      debugPrint(
          "Writing chunk ${i + 1}/${chunks.length} len ${chunk.lengthInBytes}: ${chunk.map((e) => e.toRadixString(16)).toList()}");

      await _writeMsg(id, chunk);
      await wait4msgGathered(id);
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

  void writeImages(img.Image image) async {
    var availability = await FlutterNfcKit.nfcAvailability;
    if (availability != NFCAvailability.available) {
      throw "NFC is not available";
    }

    debugPrint("Bring your phone near to the Magic Epaper Hardware");
    final tag = await FlutterNfcKit.poll(timeout: timeout);
    debugPrint("Got a tag!");

    var id = Uint8List.fromList(hex.decode(tag.id));
    if (tag.type != NFCTagType.iso15693) {
      throw "Not a Magic Epaper Hardware";
    }

    await enableEnergyHarvesting(id);
    await Future.delayed(
        const Duration(seconds: 2)); // waiting for the power supply stable

    final epdColors = epd.extractEpaperColorFrames(image);
    final transmissionLines = epd.controller.transmissionLines.iterator;
    for (final c in epdColors) {
      transmissionLines.moveNext();
      await writeFrame(id, c, transmissionLines.current);
    }

    await _writeMsg(
        id, Uint8List.fromList([fw.epdCmd, epd.controller.refresh]));
    await FlutterNfcKit.finish();
  }
}
