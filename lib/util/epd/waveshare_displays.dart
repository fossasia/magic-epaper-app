import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/constants/asset_paths.dart';
import 'package:magicepaperapp/util/epd/waveshare_nfc_display.dart';
import 'package:magicepaperapp/util/image_processing/image_processing.dart';

class Waveshare2in13 extends WaveshareNfcDisplay {
  Waveshare2in13() : super(ePaperSizeEnum: 1);

  @override
  String get name => 'Waveshare 2.13" NFC';
  @override
  String get modelId => '17745';
  @override
  int get width => 250;
  @override
  int get height => 122;
  @override
  String get imgPath => ImageAssets.waveshare2_13;
}

class Waveshare2in9 extends WaveshareNfcDisplay {
  Waveshare2in9() : super(ePaperSizeEnum: 2);

  @override
  String get name => 'Waveshare 2.9" NFC';
  @override
  String get modelId => '17746';
  @override
  int get width => 296;
  @override
  int get height => 128;
  @override
  String get imgPath => ImageAssets.waveshare2_9;
}

class Waveshare4in2 extends WaveshareNfcDisplay {
  Waveshare4in2() : super(ePaperSizeEnum: 3);

  @override
  String get name => 'Waveshare 4.2" NFC';
  @override
  String get modelId => '17341';
  @override
  int get width => 400;
  @override
  int get height => 300;
  @override
  String get imgPath => ImageAssets.waveshare4_2;
}

class Waveshare7in5 extends WaveshareNfcDisplay {
  Waveshare7in5() : super(ePaperSizeEnum: 4);

  @override
  String get name => 'Waveshare 7.5" NFC';
  @override
  String get modelId => '17675';
  @override
  int get width => 800;
  @override
  int get height => 480;
  @override
  String get imgPath => ImageAssets.waveshare7_5;
}

class Waveshare7in5HD extends WaveshareNfcDisplay {
  Waveshare7in5HD() : super(ePaperSizeEnum: 5);

  @override
  String get name => 'Waveshare 7.5" HD NFC';
  @override
  String get modelId => '18082';
  @override
  int get width => 880;
  @override
  int get height => 528;
  @override
  String get imgPath => ImageAssets.waveshare7_5hd;
}

class Waveshare2in7 extends WaveshareNfcDisplay {
  Waveshare2in7() : super(ePaperSizeEnum: 6);

  @override
  String get name => 'Waveshare 2.7" NFC';
  @override
  String get modelId => '18136';
  @override
  int get width => 264;
  @override
  int get height => 176;
  @override
  String get imgPath => ImageAssets.waveshare2_7;
}

class Waveshare2in9b extends WaveshareNfcDisplay {
  Waveshare2in9b() : super(ePaperSizeEnum: 7);

  @override
  String get name => 'Waveshare 2.9" B NFC';
  @override
  String get modelId => '13339';
  @override
  int get width => 296;
  @override
  int get height => 128;
  @override
  String get imgPath => ImageAssets.waveshare2_9b;

  @override
  List<Color> get colors => [Colors.white, Colors.black, Colors.red];

  @override
  List<img.Image Function(img.Image)> get processingMethods => [
        ImageProcessing.bwrFloydSteinbergDither,
        ImageProcessing.bwrFalseFloydSteinbergDither,
        ImageProcessing.bwrStuckiDither,
        ImageProcessing.bwrTriColorAtkinsonDither,
        ImageProcessing.bwrHalftone,
        ImageProcessing.bwrThreshold,
      ];
}
