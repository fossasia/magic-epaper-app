import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/asset_paths.dart';
import 'package:magicepaperapp/util/epd/driver/uc8253.dart';
import 'package:magicepaperapp/util/image_processing/image_processing.dart';
import 'driver/driver.dart';
import 'epd.dart';

class Gdey037z03BW extends Epd {
  @override
  int get width => 416;

  @override
  int get height => 240;

  @override
  String get name => 'Magic ePaper 3.7" (WB)';

  @override
  String get modelId => 'GDEY037T03';

  @override
  String get imgPath => ImageAssets.epaper37Bw;

  @override
  List<Color> get colors => [Colors.white, Colors.black];

  @override
  Driver get controller => Uc8253();

  @override
  List<ImageProcessingMethod> get processingMethods => [
        ImageProcessing.bwFloydSteinbergDither,
        ImageProcessing.bwFalseFloydSteinbergDither,
        ImageProcessing.bwStuckiDither,
        ImageProcessing.bwAtkinsonDither,
        ImageProcessing.bwHalftoneDither,
        ImageProcessing.bwThreshold,
      ];
}
