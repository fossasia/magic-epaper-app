import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/constants/asset_paths.dart';
import 'package:magicepaperapp/util/epd/display_device.dart';
import 'package:magicepaperapp/util/epd/driver/waveform.dart';
import 'package:magicepaperapp/util/image_processing/image_processing.dart';
import 'package:magicepaperapp/view/widget/goodisplay_transfer_dialog.dart';

class GDEY029F51 extends DisplayDevice {
  @override
  int get width => 296;

  @override
  int get height => 128;

  @override
  String get name => 'Goodisplay 2.9" 4-Color (GDEY029F51)';

  @override
  String get modelId => 'GDEY029F51';

  @override
  String get imgPath => ImageAssets.gdey037z03Display;

  @override
  List<Color> get colors => [
        Colors.white,
        Colors.black,
        Colors.red,
        Colors.yellow,
      ];

  @override
  List<ImageProcessingMethod> get processingMethods => [
        ImageProcessing.bwrFloydSteinbergDither,
        ImageProcessing.bwrFalseFloydSteinbergDither,
        ImageProcessing.bwrStuckiDither,
        ImageProcessing.bwrTriColorAtkinsonDither,
        ImageProcessing.bwrThreshold,
        ImageProcessing.bwrBayerDither,
        ImageProcessing.bwrSierra2Dither,
      ];

  @override
  Future<void> transfer(
    BuildContext context,
    img.Image image, {
    Waveform? waveform,
  }) async {
    return GoodisplayTransferDialog.show(
      context,
      image,
      width: width,
      height: height,
    );
  }

  @override
  List<String>? get displayChips => ['FM11NT081D', 'FM1280'];
}