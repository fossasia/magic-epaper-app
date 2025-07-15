import 'dart:typed_data';

// Single lut for a specific color
class Lut {
  int cmd;
  Uint8List data;

  Lut({required this.cmd, required this.data});
}

// A set of luts for a display
abstract class Waveform {
  String get desc;
  String get name;
  int get pll;
  List<Lut> get luts;
}

// A list of waveform a display may have and to be selected depends on the
// current sensing resistor and the PLL setting
typedef WaveformList = List<Waveform>;
