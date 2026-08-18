import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/constants/asset_paths.dart';
import 'package:magicepaperapp/util/epd/display_device.dart';
import 'package:magicepaperapp/util/epd/driver/waveform.dart';
import 'package:magicepaperapp/util/image_processing/image_processing.dart';
import 'package:magicepaperapp/view/widget/goodisplay_transfer_dialog.dart';

class GDEY029F52 extends DisplayDevice {
  @override
  int get width => 296;

  @override
  int get height => 128;

  @override
  String get name => 'Goodisplay 2.9" 4-Color';

  @override
  String get modelId => 'GDEY029F52';

  @override
  String get imgPath => ImageAssets.epaper37Bw; // Use your 2.9" display mockup

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