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
  String get modelId => 'waveshare-2.13';
  @override
  int get width => 122;
  @override
  int get height => 250;
  @override
  String get imgPath => ImageAssets.waveshare2_13;
}

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
}

class Waveshare4in2 extends WaveshareNfcDisplay {
  Waveshare4in2() : super(ePaperSizeEnum: 3);

  @override
  String get name => 'Waveshare 4.2" NFC';
  @override
  String get modelId => 'waveshare-4.2';
  @override
  int get width => 300;
  @override
  int get height => 400;
  @override
  String get imgPath => ImageAssets.waveshare4_2;
}

class Waveshare7in5 extends WaveshareNfcDisplay {
  Waveshare7in5() : super(ePaperSizeEnum: 4);

  @override
  String get name => 'Waveshare 7.5" NFC';
  @override
  String get modelId => 'waveshare-7.5';
  @override
  int get width => 480;
  @override
  int get height => 800;
  @override
  String get imgPath => ImageAssets.waveshare7_5;
}

class Waveshare7in5HD extends WaveshareNfcDisplay {
  Waveshare7in5HD() : super(ePaperSizeEnum: 5);

  @override
  String get name => 'Waveshare 7.5" HD NFC';
  @override
  String get modelId => 'waveshare-7.5-hd';
  @override
  int get width => 528;
  @override
  int get height => 880;
  @override
  String get imgPath => ImageAssets.waveshare7_5hd;
}

class Waveshare2in7 extends WaveshareNfcDisplay {
  Waveshare2in7() : super(ePaperSizeEnum: 6);

  @override
  String get name => 'Waveshare 2.7" NFC';
  @override
  String get modelId => 'waveshare-2.7';
  @override
  int get width => 176;
  @override
  int get height => 264;
  @override
  String get imgPath => ImageAssets.waveshare2_7;
}

class Waveshare2in9b extends WaveshareNfcDisplay {
  Waveshare2in9b() : super(ePaperSizeEnum: 7);

  @override
  String get name => 'Waveshare 2.9" B NFC';
  @override
  String get modelId => 'waveshare-2.9b';
  @override
  int get width => 128;
  @override
  int get height => 296;
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
