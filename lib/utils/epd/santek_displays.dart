import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/constants/asset_paths.dart';
import 'package:magicepaperapp/santek/services/santek_nfc_services.dart';
import 'package:magicepaperapp/utils/epd/display_device.dart';
import 'package:magicepaperapp/utils/epd/driver/waveform.dart';
import 'package:magicepaperapp/utils/image_processing/image_processing.dart';
import 'package:magicepaperapp/view/widgets/waveshare_transfer_dialog.dart';

import 'brand.dart';

class SantekEzSign2in13 extends DisplayDevice {
  @override
  String get name => 'Santek EZ Sign 2.13"';
  @override
  String get modelId => 'santek-ez-2.13';
  @override
  int get width => 250;
  @override
  int get height => 128;
  @override
  String get imgPath => ImageAssets.santekEzSign2_13;

  @override
  List<Color> get colors =>
      [Colors.white, Colors.black, Colors.red, Colors.yellow];

  @override
  List<String>? get displayChips => null;

  @override
  Brand get brand => Brand.santek;

  @override
  bool get isBeta => true;

  @override
  List<ImageProcessingMethod> get processingMethods => [
        ImageProcessing.bwryTriColorAtkinsonDither,
        ImageProcessing.bwryFloydSteinbergDither,
        ImageProcessing.bwryFalseFloydSteinbergDither,
        ImageProcessing.bwryStuckiDither,
        ImageProcessing.bwryThreshold,
      ];

  @override
  Future<void> transfer(BuildContext context, img.Image image,
      {Waveform? waveform}) {
    return WaveshareTransferDialog.showWithFlasher(
      context,
      image,
      (img.Image processed, onProgress) =>
          SantekNfcServices().flashImage(processed, onProgress: onProgress),
    );
  }
}
