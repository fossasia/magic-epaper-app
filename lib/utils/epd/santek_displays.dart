import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/constants/asset_paths.dart';
import 'package:magicepaperapp/santek/widgets/santek_transfer_dialog.dart';
import 'package:magicepaperapp/utils/epd/brand.dart';
import 'package:magicepaperapp/utils/epd/display_device.dart';
import 'package:magicepaperapp/utils/epd/driver/waveform.dart';
import 'package:magicepaperapp/utils/image_processing/image_processing.dart';

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
  Brand get brand => Brand.santek;
  @override
  List<Color> get colors =>
      [Colors.black, Colors.white, Colors.yellow, Colors.red];
  @override
  List<String>? get displayChips => null;

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
    return SantekTransferDialog.show(context, image);
  }
}
