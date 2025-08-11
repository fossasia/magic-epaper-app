import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/asset_paths.dart';
import 'package:magicepaperapp/util/epd/driver/uc8253.dart';
import 'package:magicepaperapp/util/image_processing/image_processing.dart';
import 'driver/driver.dart';
import 'epd.dart';

class Gdey037z03 extends Epd {
  @override
  get width => 240; // pixels

  @override
  get height => 416; // pixels

  @override
  String get name => 'E-Paper 3.7"';
  @override
  String get modelId => 'GDEY037Z03';
  @override
  String get imgPath => ImageAssets.epaper37Bwr;

  @override
  get colors => [Colors.white, Colors.black, Colors.red];

  @override
  get controller => Uc8253() as Driver;

  Gdey037z03() {
    processingMethods.add(ImageProcessing.bwrFloydSteinbergDither);
    processingMethods.add(ImageProcessing.bwrFalseFloydSteinbergDither);
    processingMethods.add(ImageProcessing.bwrStuckiDither);
    processingMethods.add(ImageProcessing.bwrTriColorAtkinsonDither);
    processingMethods.add(ImageProcessing.bwrHalftone);
    processingMethods.add(ImageProcessing.bwrThreshold);
  }
}
