import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/asset_paths.dart';
import 'package:magicepaperapp/util/epd/driver/uc8253.dart';
import 'package:magicepaperapp/util/image_processing/image_processing.dart';
import 'driver/driver.dart';
import 'epd.dart';
import 'package:image/image.dart' as img;

class Gdey037z03BW extends Epd {
  @override
  get width => 240; // pixels

  @override
  get height => 416; // pixels

  @override
  String get name => 'Magic ePaper 3.7" (WB)';
  @override
  String get modelId => 'GDEY037T03';
  @override
  String get imgPath => ImageAssets.epaper37Bw;

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
