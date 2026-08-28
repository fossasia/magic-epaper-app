import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/constants/asset_paths.dart';
import 'package:magicepaperapp/util/epd/display_device.dart';
import 'package:magicepaperapp/util/epd/driver/waveform.dart';
import 'package:magicepaperapp/util/image_processing/image_processing.dart';
import 'package:magicepaperapp/view/widget/goodisplay_transfer_dialog.dart';

const List<ImageProcessingMethod> _bwryProcessingMethods = [
  ImageProcessing.bwryFloydSteinbergDither,
  ImageProcessing.bwryFalseFloydSteinbergDither,
  ImageProcessing.bwryStuckiDither,
  ImageProcessing.bwryTriColorAtkinsonDither,
  ImageProcessing.bwryThreshold,
  ImageProcessing.bwryBayerDither,
  ImageProcessing.bwrySierra2Dither,
];

/// GDEM0097F51 - 0.97" 4-Color (184x88)
class GDEM0097F51 extends DisplayDevice {
  @override
  int get width => 184;
  @override
  int get height => 88;
  @override
  String get name => 'Goodisplay 0.97" 4-Color (GDEM0097F51)';
  @override
  String get modelId => 'GDEM0097F51';
  @override
  String get imgPath => ImageAssets.GDEM0097F51;
  @override
  List<Color> get colors =>
      [Colors.white, Colors.black, Colors.red, Colors.yellow];
  @override
  List<ImageProcessingMethod> get processingMethods => _bwryProcessingMethods;

  @override
  Future<void> transfer(BuildContext context, img.Image image,
      {Waveform? waveform}) async {
    return GoodisplayTransferDialog.show(context, image,
        width: width, height: height);
  }

  @override
  List<String>? get displayChips => ['FM11NT081D', 'FM1280'];
}

/// GDEM0154F51H - 1.54" 4-Color (200x200)
class GDEM0154F51H extends DisplayDevice {
  @override
  int get width => 200;
  @override
  int get height => 200;
  @override
  String get name => 'Goodisplay 1.54" 4-Color (GDEM0154F51H)';
  @override
  String get modelId => 'GDEM0154F51H';
  @override
  String get imgPath => ImageAssets.GDEM0154F51H;
  @override
  List<Color> get colors =>
      [Colors.white, Colors.black, Colors.red, Colors.yellow];
  @override
  List<ImageProcessingMethod> get processingMethods => _bwryProcessingMethods;

  @override
  Future<void> transfer(BuildContext context, img.Image image,
      {Waveform? waveform}) async {
    return GoodisplayTransferDialog.show(context, image,
        width: width, height: height);
  }

  @override
  List<String>? get displayChips => ['FM11NT081D', 'FM1280'];
}

/// GDEY0213F52 - 2.13" 4-Color (250x128)
class GDEY0213F52 extends DisplayDevice {
  @override
  int get width => 250;
  @override
  int get height => 128;
  @override
  String get name => 'Goodisplay 2.13" 4-Color (GDEY0213F52)';
  @override
  String get modelId => 'GDEY0213F52';
  @override
  String get imgPath => ImageAssets.GDEY0213F52;
  @override
  List<Color> get colors =>
      [Colors.white, Colors.black, Colors.red, Colors.yellow];
  @override
  List<ImageProcessingMethod> get processingMethods => _bwryProcessingMethods;

  @override
  Future<void> transfer(BuildContext context, img.Image image,
      {Waveform? waveform}) async {
    return GoodisplayTransferDialog.show(context, image,
        width: width, height: height);
  }

  @override
  List<String>? get displayChips => ['FM11NT081D', 'FM1280'];
}

/// GDEY0266F51 - 2.66" 4-Color (296x152)
class GDEY0266F51 extends DisplayDevice {
  @override
  int get width => 296;
  @override
  int get height => 152;
  @override
  String get name => 'Goodisplay 2.66" 4-Color (GDEY0266F51)';
  @override
  String get modelId => 'GDEY0266F51';
  @override
  String get imgPath => ImageAssets.GDEY0266F51;
  @override
  List<Color> get colors =>
      [Colors.white, Colors.black, Colors.red, Colors.yellow];
  @override
  List<ImageProcessingMethod> get processingMethods => _bwryProcessingMethods;

  @override
  Future<void> transfer(BuildContext context, img.Image image,
      {Waveform? waveform}) async {
    return GoodisplayTransferDialog.show(context, image,
        width: width, height: height);
  }

  @override
  List<String>? get displayChips => ['FM11NT081D', 'FM1280'];
}

/// GDEY0266F51H - 2.66" 4-Color HD (360x184)
class GDEY0266F51H extends DisplayDevice {
  @override
  int get width => 360;
  @override
  int get height => 184;
  @override
  String get name => 'Goodisplay 2.66" 4-Color HD (GDEY0266F51H)';
  @override
  String get modelId => 'GDEY0266F51H';
  @override
  String get imgPath => ImageAssets.GDEY0266F51H;
  @override
  List<Color> get colors =>
      [Colors.white, Colors.black, Colors.red, Colors.yellow];
  @override
  List<ImageProcessingMethod> get processingMethods => _bwryProcessingMethods;

  @override
  Future<void> transfer(BuildContext context, img.Image image,
      {Waveform? waveform}) async {
    return GoodisplayTransferDialog.show(context, image,
        width: width, height: height);
  }

  @override
  List<String>? get displayChips => ['FM11NT081D', 'FM1280'];
}

/// GDEY029F51H - 2.9" 4-Color HD (384x168)
class GDEY029F51H extends DisplayDevice {
  @override
  int get width => 384;
  @override
  int get height => 168;
  @override
  String get name => 'Goodisplay 2.9" 4-Color HD (GDEY029F51H)';
  @override
  String get modelId => 'GDEY029F51H';
  @override
  String get imgPath => ImageAssets.GDEY029F51H;
  @override
  List<Color> get colors =>
      [Colors.white, Colors.black, Colors.red, Colors.yellow];
  @override
  List<ImageProcessingMethod> get processingMethods => _bwryProcessingMethods;

  @override
  Future<void> transfer(BuildContext context, img.Image image,
      {Waveform? waveform}) async {
    return GoodisplayTransferDialog.show(context, image,
        width: width, height: height);
  }

  @override
  List<String>? get displayChips => ['FM11NT081D', 'FM1280'];
}

/// GDEM037F52 - 3.7" 4-Color (416x240)
class GDEM037F52 extends DisplayDevice {
  @override
  int get width => 416;
  @override
  int get height => 240;
  @override
  String get name => 'Goodisplay 3.7" 4-Color (GDEM037F52)';
  @override
  String get modelId => 'GDEM037F52';
  @override
  String get imgPath => ImageAssets.GDEM037F52;
  @override
  List<Color> get colors =>
      [Colors.white, Colors.black, Colors.red, Colors.yellow];
  @override
  List<ImageProcessingMethod> get processingMethods => _bwryProcessingMethods;

  @override
  Future<void> transfer(BuildContext context, img.Image image,
      {Waveform? waveform}) async {
    return GoodisplayTransferDialog.show(context, image,
        width: width, height: height);
  }

  @override
  List<String>? get displayChips => ['FM11NT081D', 'FM1280'];
}

/// GDEM042F52 - 4.2" 4-Color (400x300)
class GDEM042F52 extends DisplayDevice {
  @override
  int get width => 400;
  @override
  int get height => 300;
  @override
  String get name => 'Goodisplay 4.2" 4-Color (GDEM042F52)';
  @override
  String get modelId => 'GDEM042F52';
  @override
  String get imgPath => ImageAssets.GDEM042F52;
  @override
  List<Color> get colors =>
      [Colors.white, Colors.black, Colors.red, Colors.yellow];
  @override
  List<ImageProcessingMethod> get processingMethods => _bwryProcessingMethods;

  @override
  Future<void> transfer(BuildContext context, img.Image image,
      {Waveform? waveform}) async {
    return GoodisplayTransferDialog.show(context, image,
        width: width, height: height);
  }

  @override
  List<String>? get displayChips => ['FM11NT081D', 'FM1280'];
}
