import 'package:magicepaperapp/constants/asset_paths.dart';
import 'package:magicepaperapp/util/epd/waveshare_nfc_display.dart';

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
  String get imgPath => ImageAssets.waveshare2_9;
  @override
  List<String> get displayChips => ['Waveshare Display'];
}
