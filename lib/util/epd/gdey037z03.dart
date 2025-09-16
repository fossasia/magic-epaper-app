import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/asset_paths.dart';
import 'package:magicepaperapp/util/epd/driver/uc8253.dart';
import 'package:magicepaperapp/util/image_processing/image_processing.dart';
import 'driver/driver.dart';
import 'epd.dart';
import 'package:image/image.dart' as img;

class Gdey037z03 extends Epd {
  @override
  @override
  int get width => 416; // pixels

  @override
  int get height => 240; // pixels

  @override
  String get name => 'Magic ePaper 3.7" (WBR)';

  @override
  String get modelId => 'GDEY037Z03';

  @override
  String get imgPath => ImageAssets.epaper37Bwr;

  @override
  List<Color> get colors => [Colors.white, Colors.black, Colors.red];

  @override
  Driver get controller => Uc8253();

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
