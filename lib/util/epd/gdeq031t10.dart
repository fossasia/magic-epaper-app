import 'package:flutter/material.dart';
import 'package:magic_epaper_app/constants/asset_paths.dart';
import 'package:magic_epaper_app/util/epd/driver/uc8253.dart';
import 'package:magic_epaper_app/util/image_processing/image_processing.dart';
import 'driver/driver.dart';
import 'epd.dart';

class GDEQ031T10 extends Epd {
  @override
  get width => 320;

  @override
  get height => 240;

  @override
  String get name => 'E-Paper 3.1"';
  @override
  String get modelId => 'GDEQ031T10';
  @override
  String get imgPath => ImageAssets.GDEQ031T10Display;

  @override
  get colors => [Colors.white, Colors.black];

  @override
  get controller => Uc8253() as Driver;

  GDEQ031T10() {
    processingMethods.add(ImageProcessing.bwrFloydSteinbergDither);
    processingMethods.add(ImageProcessing.bwrFalseFloydSteinbergDither);
    processingMethods.add(ImageProcessing.bwrStuckiDither);
    processingMethods.add(ImageProcessing.bwrTriColorAtkinsonDither);
    processingMethods.add(ImageProcessing.bwrHalftone);
    processingMethods.add(ImageProcessing.bwrThreshold);
  }
}
