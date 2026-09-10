import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/constants/asset_paths.dart';
import 'package:magicepaperapp/util/epd/display_device.dart';
import 'package:magicepaperapp/util/epd/driver/waveform.dart';
import 'package:magicepaperapp/util/image_processing/image_processing.dart';
import 'package:magicepaperapp/view/widget/goodisplay_transfer_dialog.dart';

const List<ImageProcessingMethod> _bwrProcessingMethods = [
  ImageProcessing.bwrFloydSteinbergDither,
  ImageProcessing.bwrFalseFloydSteinbergDither,
  ImageProcessing.bwrStuckiDither,
  ImageProcessing.bwrTriColorAtkinsonDither,
  ImageProcessing.bwrThreshold,
  ImageProcessing.bwrBayerDither,
  ImageProcessing.bwrSierra2Dither,
];

/// GDEY0154Z90 - 1.54" 3-Color (200x200)
class GDEY0154Z90 extends DisplayDevice {
  @override
  int get width => 200;
  @override
  int get height => 200;
  @override
  String get name => 'Goodisplay 1.54" 3-Color (GDEY0154Z90)';
  @override
  String get modelId => 'GDEY0154Z90';
  @override
  String get imgPath => ImageAssets.GDEY0154Z90;
  @override
  List<Color> get colors => [Colors.white, Colors.black, Colors.red];
  @override
  List<ImageProcessingMethod> get processingMethods => _bwrProcessingMethods;
  @override
  bool get isBeta => true;

  @override
  Future<void> transfer(BuildContext context, img.Image image,
      {Waveform? waveform}) async {
    return GoodisplayTransferDialog.show(
      context,
      image,
      display: this,
    );
  }

  @override
  List<String>? get displayChips => ['FM11NT081D', 'FM1280'];
}

/// GDEY0213Z98 - 2.13" 3-Color (250x128)
class GDEY0213Z98 extends DisplayDevice {
  @override
  int get width => 250;
  @override
  int get height => 128;
  @override
  String get name => 'Goodisplay 2.13" 3-Color (GDEY0213Z98)';
  @override
  String get modelId => 'GDEY0213Z98';
  @override
  String get imgPath => ImageAssets.GDEY0213Z98;
  @override
  List<Color> get colors => [Colors.white, Colors.black, Colors.red];
  @override
  List<ImageProcessingMethod> get processingMethods => _bwrProcessingMethods;
  @override
  bool get isBeta => true;

  @override
  Future<void> transfer(BuildContext context, img.Image image,
      {Waveform? waveform}) async {
    return GoodisplayTransferDialog.show(
      context,
      image,
      display: this,
    );
  }

  @override
  List<String>? get displayChips => ['FM11NT081D', 'FM1280'];
}

/// GDEY029Z95 - 2.9" 3-Color (296x128)
class GDEY029Z95 extends DisplayDevice {
  @override
  int get width => 296;
  @override
  int get height => 128;
  @override
  String get name => 'Goodisplay 2.9" 3-Color (GDEY029Z95)';
  @override
  String get modelId => 'GDEY029Z95';
  @override
  String get imgPath => ImageAssets.GDEY029Z95;
  @override
  List<Color> get colors => [Colors.white, Colors.black, Colors.red];
  @override
  List<ImageProcessingMethod> get processingMethods => _bwrProcessingMethods;
  @override
  bool get isBeta => true;

  @override
  Future<void> transfer(BuildContext context, img.Image image,
      {Waveform? waveform}) async {
    return GoodisplayTransferDialog.show(
      context,
      image,
      display: this,
    );
  }

  @override
  List<String>? get displayChips => ['FM11NT081D', 'FM1280'];
}

/// GDEY042Z98 - 4.2" 3-Color (400x300)
class GDEY042Z98 extends DisplayDevice {
  @override
  int get width => 400;
  @override
  int get height => 300;
  @override
  String get name => 'Goodisplay 4.2" 3-Color (GDEY042Z98)';
  @override
  String get modelId => 'GDEY042Z98';
  @override
  String get imgPath => ImageAssets.GDEY042Z98;
  @override
  List<Color> get colors => [Colors.white, Colors.black, Colors.red];
  @override
  List<ImageProcessingMethod> get processingMethods => _bwrProcessingMethods;
  @override
  bool get isBeta => true;

  @override
  Future<void> transfer(BuildContext context, img.Image image,
      {Waveform? waveform}) async {
    return GoodisplayTransferDialog.show(
      context,
      image,
      display: this,
    );
  }

  @override
  List<String>? get displayChips => ['FM11NT081D', 'FM1280'];
}

/// GDEW0213Z16 - 2.13" 3-Color (212x104)
class GDEW0213Z16 extends DisplayDevice {
  @override
  int get width => 212;
  @override
  int get height => 104;
  @override
  String get name => 'Goodisplay 2.13" 3-Color (GDEW0213Z16)';
  @override
  String get modelId => 'GDEW0213Z16';
  @override
  String get imgPath => ImageAssets.GDEW0213Z16;
  @override
  List<Color> get colors => [Colors.white, Colors.black, Colors.red];
  @override
  List<ImageProcessingMethod> get processingMethods => _bwrProcessingMethods;
  @override
  bool get isBeta => true;

  @override
  Future<void> transfer(BuildContext context, img.Image image,
      {Waveform? waveform}) async {
    return GoodisplayTransferDialog.show(
      context,
      image,
      display: this,
    );
  }

  @override
  List<String>? get displayChips => ['FM11NT081D', 'FM1280'];
}

/// GDEW029Z13 - 2.9" 3-Color (296x128)
class GDEW029Z13 extends DisplayDevice {
  @override
  int get width => 296;
  @override
  int get height => 128;
  @override
  String get name => 'Goodisplay 2.9" 3-Color (GDEW029Z13)';
  @override
  String get modelId => 'GDEW029Z13';
  @override
  String get imgPath => ImageAssets.GDEW029Z13;
  @override
  List<Color> get colors => [Colors.white, Colors.black, Colors.red];
  @override
  List<ImageProcessingMethod> get processingMethods => _bwrProcessingMethods;
  @override
  bool get isBeta => true;

  @override
  Future<void> transfer(BuildContext context, img.Image image,
      {Waveform? waveform}) async {
    return GoodisplayTransferDialog.show(
      context,
      image,
      display: this,
    );
  }

  @override
  List<String>? get displayChips => ['FM11NT081D', 'FM1280'];
}

/// GDEQ042Z21 - 4.2" 3-Color (400x300)
class GDEQ042Z21 extends DisplayDevice {
  @override
  int get width => 400;
  @override
  int get height => 300;
  @override
  String get name => 'Goodisplay 4.2" 3-Color (GDEQ042Z21)';
  @override
  String get modelId => 'GDEQ042Z21';
  @override
  String get imgPath => ImageAssets.GDEQ042Z21;
  @override
  List<Color> get colors => [Colors.white, Colors.black, Colors.red];
  @override
  List<ImageProcessingMethod> get processingMethods => _bwrProcessingMethods;
  @override
  bool get isBeta => true;

  @override
  Future<void> transfer(BuildContext context, img.Image image,
      {Waveform? waveform}) async {
    return GoodisplayTransferDialog.show(
      context,
      image,
      display: this,
    );
  }

  @override
  List<String>? get displayChips => ['FM11NT081D', 'FM1280'];
}

/// GDEY037Z03 - 3.7" 3-Color (416x240)
class GDEY037Z03 extends DisplayDevice {
  @override
  int get width => 416;
  @override
  int get height => 240;
  @override
  String get name => 'Goodisplay 3.7" 3-Color (GDEY037Z03)';
  @override
  String get modelId => 'GDEY037Z03';
  @override
  String get imgPath => ImageAssets.GDEY037Z03;
  @override
  List<Color> get colors => [Colors.white, Colors.black, Colors.red];
  @override
  List<ImageProcessingMethod> get processingMethods => _bwrProcessingMethods;
  @override
  bool get isBeta => true;

  @override
  Future<void> transfer(BuildContext context, img.Image image,
      {Waveform? waveform}) async {
    return GoodisplayTransferDialog.show(
      context,
      image,
      display: this,
    );
  }

  @override
  List<String>? get displayChips => ['FM11NT081D', 'FM1280'];
}
