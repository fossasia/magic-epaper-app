import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:magicepaperapp/util/epd/driver/driver.dart';
import 'package:magicepaperapp/util/epd/driver/waveform.dart';
import 'package:magicepaperapp/util/protocol.dart';

class Gdey029f52Driver extends Driver {
  @override
  String get driverName => 'GDEY029F52_Driver';

  @override
  int get refresh => 0x12; // Display Refresh

  @override
  int get panelSetting => 0x00;

  @override
  int get pllControl => 0x30;

  @override
  int get vcomLut => 0x20;
  @override
  int get wwLut => 0x21;
  @override
  int get bwLut => 0x22;
  @override
  int get wbLut => 0x23;
  @override
  int get bbLut => 0x24;

  @override
  WaveformList get waveforms => [];

  // Transmission commands for BW plane and Red/Yellow plane
  @override
  List<int> get transmissionLines => [0x10, 0x13];

  @override
  Future<void> setlut(Protocol p, Waveform waveform) async {}

  @override
  Future<void> init(Protocol p, {Waveform? waveform}) async {
    // Panel initialization sequence
    await p.writeMsg(Uint8List.fromList([p.fw.epdCmd, 0x04])); // Power on
    await p.writeMsg(Uint8List.fromList([p.fw.epdCmd, 0x00])); // Panel setting
    await p.writeMsg(Uint8List.fromList([p.fw.epdSend, 0x0F, 0x89]));
  }
}
