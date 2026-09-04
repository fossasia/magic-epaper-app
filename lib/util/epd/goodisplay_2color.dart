import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/constants/asset_paths.dart';
import 'package:magicepaperapp/util/epd/display_device.dart';
import 'package:magicepaperapp/util/epd/driver/waveform.dart';
import 'package:magicepaperapp/util/image_processing/image_processing.dart';
import 'package:magicepaperapp/view/widget/goodisplay_transfer_dialog.dart';

/// Metodi di dithering comuni per display a 2 Colori (Black & White)
const List<ImageProcessingMethod> _bwProcessingMethods = [
  ImageProcessing.bwFloydSteinbergDither,
  ImageProcessing.bwFalseFloydSteinbergDither,
  ImageProcessing.bwStuckiDither,
  ImageProcessing.bwAtkinsonDither,
  ImageProcessing.bwThreshold,
  ImageProcessing.bwBayerDither,
  ImageProcessing.bwSierra2Dither,
];

/// GDEY0154D67 - 1.54" B/W (200x200)
class GDEY0154D67 extends DisplayDevice {
  @override
  int get width => 200;
  @override
  int get height => 200;
  @override
  String get name => 'Goodisplay 1.54" B/W (GDEY0154D67)';
  @override
  String get modelId => 'GDEY0154D67';
  @override
  String get imgPath => ImageAssets.GDEY0154D67;
  @override
  List<Color> get colors => [Colors.white, Colors.black];
  @override
  List<ImageProcessingMethod> get processingMethods => _bwProcessingMethods;
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

/// GDEY0213B74 - 2.13" B/W (250x128)
class GDEY0213B74 extends DisplayDevice {
  @override
  int get width => 250;
  @override
  int get height => 128;
  @override
  String get name => 'Goodisplay 2.13" B/W (GDEY0213B74)';
  @override
  String get modelId => 'GDEY0213B74';
  @override
  String get imgPath => ImageAssets.GDEY0213B74;
  @override
  List<Color> get colors => [Colors.white, Colors.black];
  @override
  List<ImageProcessingMethod> get processingMethods => _bwProcessingMethods;
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

/// GDEY029T94 - 2.9" B/W (296x128)
class GDEY029T94 extends DisplayDevice {
  @override
  int get width => 296;
  @override
  int get height => 128;
  @override
  String get name => 'Goodisplay 2.9" B/W (GDEY029T94)';
  @override
  String get modelId => 'GDEY029T94';
  @override
  String get imgPath => ImageAssets.GDEY029T94;
  @override
  List<Color> get colors => [Colors.white, Colors.black];
  @override
  List<ImageProcessingMethod> get processingMethods => _bwProcessingMethods;
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

/// GDEY042T81 - 4.2" B/W (400x300)
class GDEY042T81 extends DisplayDevice {
  @override
  int get width => 400;
  @override
  int get height => 300;
  @override
  String get name => 'Goodisplay 4.2" B/W (GDEY042T81)';
  @override
  String get modelId => 'GDEY042T81';
  @override
  String get imgPath => ImageAssets.GDEY042T81;
  @override
  List<Color> get colors => [Colors.white, Colors.black];
  @override
  List<ImageProcessingMethod> get processingMethods => _bwProcessingMethods;
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

/// GDEW0154T8D - 1.54" B/W (152x152)
class GDEW0154T8D extends DisplayDevice {
  @override
  int get width => 152;
  @override
  int get height => 152;
  @override
  String get name => 'Goodisplay 1.54" B/W (GDEW0154T8D)';
  @override
  String get modelId => 'GDEW0154T8D';
  @override
  String get imgPath => ImageAssets.GDEW0154T8D;
  @override
  List<Color> get colors => [Colors.white, Colors.black];
  @override
  List<ImageProcessingMethod> get processingMethods => _bwProcessingMethods;
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

/// GDEW0213T5D - 2.13" B/W (212x104)
class GDEW0213T5D extends DisplayDevice {
  @override
  int get width => 212;
  @override
  int get height => 104;
  @override
  String get name => 'Goodisplay 2.13" B/W (GDEW0213T5D)';
  @override
  String get modelId => 'GDEW0213T5D';
  @override
  String get imgPath => ImageAssets.GDEW0213T5D;
  @override
  List<Color> get colors => [Colors.white, Colors.black];
  @override
  List<ImageProcessingMethod> get processingMethods => _bwProcessingMethods;
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

/// GDEW029T5D - 2.9" B/W (296x128)
class GDEW029T5D extends DisplayDevice {
  @override
  int get width => 296;
  @override
  int get height => 128;
  @override
  String get name => 'Goodisplay 2.9" B/W (GDEW029T5D)';
  @override
  String get modelId => 'GDEW029T5D';
  @override
  String get imgPath => ImageAssets.GDEW029T5D;
  @override
  List<Color> get colors => [Colors.white, Colors.black];
  @override
  List<ImageProcessingMethod> get processingMethods => _bwProcessingMethods;
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

/// GDEW042T2 - 4.2" B/W (400x300)
class GDEW042T2 extends DisplayDevice {
  @override
  int get width => 400;
  @override
  int get height => 300;
  @override
  String get name => 'Goodisplay 4.2" B/W (GDEW042T2)';
  @override
  String get modelId => 'GDEW042T2';
  @override
  String get imgPath => ImageAssets.GDEW042T2;
  @override
  List<Color> get colors => [Colors.white, Colors.black];
  @override
  List<ImageProcessingMethod> get processingMethods => _bwProcessingMethods;
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

/// GDEY037T03 - 3.7" B/W (416x240)
class GDEY037T03 extends DisplayDevice {
  @override
  int get width => 416;
  @override
  int get height => 240;
  @override
  String get name => 'Goodisplay 3.7" B/W (GDEY037T03)';
  @override
  String get modelId => 'GDEY037T03';
  @override
  String get imgPath => ImageAssets.GDEY037T03;
  @override
  List<Color> get colors => [Colors.white, Colors.black];
  @override
  List<ImageProcessingMethod> get processingMethods => _bwProcessingMethods;
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
