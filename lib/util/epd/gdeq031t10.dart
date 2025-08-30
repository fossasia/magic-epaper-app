import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/asset_paths.dart';
import 'package:magicepaperapp/util/epd/driver/uc8253.dart';
import 'package:magicepaperapp/util/image_processing/image_processing.dart';
import 'package:image/image.dart' as img;
import 'driver/driver.dart';
import 'epd.dart';

class GDEQ031T10 extends Epd {
  @override
  get width => 240;

  @override
  get height => 320;

  @override
  String get name => 'Goodisplay ePaper 3.1"';
  @override
  String get modelId => 'GDEQ031T10';
  @override
  String get imgPath => ImageAssets.GDEQ031T10Display;

  @override
  get colors => [Colors.white, Colors.black];

  @override
  get controller => Uc8253() as Driver;

  @override
  List<img.Image Function(img.Image)> get processingMethods => [
        ImageProcessing.bwFloydSteinbergDither,
        ImageProcessing.bwFalseFloydSteinbergDither,
        ImageProcessing.bwStuckiDither,
        ImageProcessing.bwAtkinsonDither,
        ImageProcessing.bwHalftoneDither,
        ImageProcessing.bwThreshold,
      ];
}
