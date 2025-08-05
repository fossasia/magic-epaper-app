// lib/waveshare/model/waveshare_2in9.dart
import 'package:magic_epaper_app/constants/asset_paths.dart';
import 'package:magic_epaper_app/util/epd/waveshare_nfc_display.dart'; // Assuming you have an image for it

class Waveshare2in9 extends WaveshareNfcDisplay {
  Waveshare2in9() : super(ePaperSizeEnum: 2);

  @override
  String get name => 'Waveshare 2.9" NFC';
  @override
  String get modelId => 'waveshare-2.9';
  @override
  int get width => 128;
  @override
  int get height => 296;
  @override
  String get imgPath => ImageAssets.epaper37Bw;
}
