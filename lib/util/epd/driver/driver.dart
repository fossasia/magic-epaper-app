import 'waveform.dart';
import 'package:magicepaperapp/util/protocol.dart';

abstract class Driver {
  String get driverName;
  List<int> get transmissionLines;
  int get refresh;
  int get vcomLut;
  int get wwLut;
  int get bwLut;
  int get wbLut;
  int get bbLut;
  int get panelSetting;
  int get pllControl;
  WaveformList get waveforms;
  Future<void> setlut(Protocol p, Waveform waveform);

  Future<void> init(Protocol p, {Waveform? waveform});
}
