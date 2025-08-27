import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/asset_paths.dart';
import 'package:magicepaperapp/util/epd/driver/uc8253.dart';
import 'package:magicepaperapp/util/image_processing/image_processing.dart';
import 'driver/driver.dart';
import 'epd.dart';
import 'package:image/image.dart' as img;

class Gdey037z03 extends Epd {
  @override
  int get width => 240; // pixels

  @override
  int get height => 416; // pixels

  @override
  String get name => 'Goodisplay ePaper 3.7"';

  @override
  String get modelId => 'GDEY037Z03';

  @override
  String get imgPath => ImageAssets.epaper37Bwr;

  @override
  List<Color> get colors => [Colors.white, Colors.black, Colors.red];

  @override
  Driver get controller => Uc8253();

  @override
  List<String> get displayChips => ['FOSSASIA Hardware Required'];

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
