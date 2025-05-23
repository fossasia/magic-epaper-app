import 'package:flutter/material.dart';
import 'package:magic_epaper_app/util/epd/driver/uc8253.dart';
import 'package:magic_epaper_app/util/image_processing/image_processing.dart';
import 'driver/driver.dart';
import 'epd.dart';

class Gdey037z03BW extends Epd {
  @override
  get width => 240; // pixels

  @override
  get height => 416; // pixels

  @override
  String get name => 'E-Paper 3.7"';
  @override
  String get modelId => 'GDEY037T03';
  @override
  String get imgPath => "assets/images/displays/epaper_3.7_bw.PNG";

  @override
  get colors => [Colors.black, Colors.white];

  @override
  get controller => Uc8253() as Driver;

  Gdey037z03BW() {
    processingMethods.add(ImageProcessing.bwFloydSteinbergDither);
    processingMethods.add(ImageProcessing.bwFalseFloydSteinbergDither);
    processingMethods.add(ImageProcessing.bwStuckiDither);
    processingMethods.add(ImageProcessing.bwAtkinsonDither);
    processingMethods.add(ImageProcessing.bwHalftoneDither);
    processingMethods.add(ImageProcessing.bwNoDither);
  }
}
