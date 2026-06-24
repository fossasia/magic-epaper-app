import 'dart:typed_data';
import 'package:magicepaperapp/util/epd/driver/waveform.dart';
import 'package:magicepaperapp/util/protocol.dart';
import 'driver.dart';

class Uc8151dQuickLut extends Waveform {
  @override
  String get desc => "Quick waveform for UltraChip";
  @override
  String get name => "Quick Refresh";
  @override
  int get pll => 0x01;

  @override
  List<Lut> get luts => [
        Lut(
            cmd: 0x20,
            data: Uint8List.fromList([
              0x01,
              0x00,
              10,
              0x00,
              0x00,
              0x01,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
            ])),
        Lut(
            cmd: 0x21,
            data: Uint8List.fromList([
              0x01,
              0x8A,
              0x00,
              0x00,
              0x00,
              0x01,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
            ])),
        Lut(
            cmd: 0x22,
            data: Uint8List.fromList([
              0x01,
              0x8A,
              0x00,
              0x00,
              0x00,
              0x01,
              0x00,
              0x01,
              10,
              0x00,
              0x00,
              0x00,
              0x01,
              0x00,
              0x01,
              0x4A,
              5,
              0x00,
              0x00,
              0x02,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
            ])),
        Lut(
            cmd: 0x23,
            data: Uint8List.fromList([
              0x01,
              10,
              0x00,
              0x00,
              0x00,
              0x01,
              0x00,
              0x01,
              10,
              0x00,
              0x00,
              0x00,
              0x01,
              0x00,
              0x01,
              10,
              0x00,
              0x00,
              0x00,
              0x01,
              0x00,
              0x00,
              0x42,
              0x00,
              0x00,
              0x00,
              0x01,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
            ])),
        Lut(
            cmd: 0x24,
            data: Uint8List.fromList([
              0x01,
              10,
              0x00,
              0x00,
              0x00,
              0x01,
              0x00,
              0x01,
              0x4C,
              0x00,
              0x00,
              0x00,
              0x01,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
              0x00,
            ])),
      ];
}

class Uc8151d extends Driver {
  @override
  int get refresh => 0x12;

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
  int get panelSetting => 0x00;
  @override
  int get pllControl => 0x30;

  @override
  WaveformList waveforms = [Uc8151dQuickLut()];

  @override
  String get driverName => 'UC8151D';

  @override
  List<int> get transmissionLines => [0x10, 0x13];

  @override
  Future<void> setlut(Protocol p, Waveform waveform) async {
    await p.writeMsg(Uint8List.fromList([p.fw.epdCmd, pllControl]));
    await p.writeMsg(Uint8List.fromList([p.fw.epdSend, waveform.pll]));

    for (var lut in waveform.luts) {
      await p.writeMsg(Uint8List.fromList([p.fw.epdCmd, lut.cmd]));
      await p.writeMsg(Uint8List.fromList([p.fw.epdSend, ...lut.data]));
    }
  }

  @override
  Future<void> init(Protocol p, {Waveform? waveform}) async {
    await p.writeMsg(Uint8List.fromList([p.fw.epdCmd, 0x01]));
    await p.writeMsg(
        Uint8List.fromList([p.fw.epdSend, 0x03, 0x00, 0x2b, 0x2b, 0x03]));

    await p.writeMsg(Uint8List.fromList([p.fw.epdCmd, 0x06]));
    await p.writeMsg(Uint8List.fromList([p.fw.epdSend, 0x17, 0x17, 0x17]));

    await p.writeMsg(Uint8List.fromList([p.fw.epdCmd, 0x04]));
    await Future.delayed(const Duration(milliseconds: 50));

    await p.writeMsg(Uint8List.fromList([p.fw.epdCmd, 0x00]));
    if (waveform != null) {
      await p.writeMsg(Uint8List.fromList([p.fw.epdSend, 0x3f, 0x0d]));
      await setlut(p, waveform);
    } else {
      await p.writeMsg(Uint8List.fromList([p.fw.epdSend, 0xbf, 0x0d]));
    }

    await p.writeMsg(Uint8List.fromList([p.fw.epdCmd, 0x50]));
    await p.writeMsg(Uint8List.fromList([p.fw.epdSend, 0x77]));
  }
}
