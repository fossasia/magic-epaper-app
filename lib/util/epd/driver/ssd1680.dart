import 'dart:typed_data';
import 'package:magicepaperapp/util/epd/driver/waveform.dart';
import 'package:magicepaperapp/util/protocol.dart';
import 'driver.dart';

class SsdQuickLut extends Waveform {
  @override
  String get desc => "Generic Fast Partial Refresh for SSD1680";
  @override
  String get name => "Quick Refresh";
  @override
  int get pll => 0x3C;

  @override
  List<Lut> get luts => [
        Lut(
          cmd: 0x32,
          data: Uint8List.fromList([
            0x80,
            0x4A,
            0x40,
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
            0x80,
            0x4A,
            0x40,
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
            0x22,
            0x22,
            0x22,
            0x22,
            0x22,
            0x22,
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
            0x00
          ]),
        )
      ];
}

class Ssd1680 extends Driver {
  @override
  int get refresh => 0x20;

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
  WaveformList waveforms = [SsdQuickLut()];

  @override
  String get driverName => 'SSD1680';

  @override
  List<int> get transmissionLines => [0x24, 0x26];

  @override
  Future<void> setlut(Protocol p, Waveform waveform) async {
    for (var lut in waveform.luts) {
      await p.writeMsg(Uint8List.fromList([p.fw.epdCmd, lut.cmd]));
      await p.writeMsg(Uint8List.fromList([p.fw.epdSend, ...lut.data]));
    }
  }

  @override
  Future<void> init(Protocol p, {Waveform? waveform}) async {
    await p.writeMsg(Uint8List.fromList([p.fw.epdCmd, 0x12]));
    await Future.delayed(const Duration(milliseconds: 20));

    await p.writeMsg(Uint8List.fromList([p.fw.epdCmd, 0x11]));
    await p.writeMsg(Uint8List.fromList([p.fw.epdSend, 0x03]));

    await p.writeMsg(Uint8List.fromList([p.fw.epdCmd, 0x3C]));
    await p.writeMsg(Uint8List.fromList([p.fw.epdSend, 0x05]));

    await p.writeMsg(Uint8List.fromList([p.fw.epdCmd, 0x22]));
    if (waveform != null) {
      await p.writeMsg(Uint8List.fromList([p.fw.epdSend, 0xCC]));
      await setlut(p, waveform);
    } else {
      await p.writeMsg(Uint8List.fromList([p.fw.epdSend, 0xF7]));
    }
  }
}
