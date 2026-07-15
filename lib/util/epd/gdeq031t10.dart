import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/asset_paths.dart';
import 'package:magicepaperapp/util/epd/driver/uc8253.dart';
import 'package:magicepaperapp/util/image_processing/image_processing.dart';
import 'driver/driver.dart';
import 'epd.dart';

class GDEQ031T10 extends Epd {
  @override
  int get width => 320;

  @override
  int get height => 240;

  @override
  String get name => 'Magic ePaper 3.1" (WB)';

  @override
  String get modelId => 'GDEQ031T10';

  @override
  String get imgPath => ImageAssets.gdeq031t10Display;

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
        ImageProcessing.bwBayerDither,
      ];
}
