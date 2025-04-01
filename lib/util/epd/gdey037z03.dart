import 'package:flutter/material.dart';
import 'package:magic_epaper_app/util/epd/driver/uc8252.dart';
import 'package:magic_epaper_app/util/image_processing/image_processing.dart';
import 'driver/driver.dart';
import 'edp.dart';

class Gdey037z03 extends Epd {
  @override
  String get description => '240x416 BWR (UC8252)';

  @override
  get width => 240; // pixels
  
  @override
  get height => 416; // pixels
  
  @override
  get colors => [Colors.black, Colors.white, Colors.red];

  @override
  get controller => Uc8252() as Driver;

  Gdey037z03() {
    processingMethods.add(ImageProcessing.rwbTriColorDither);
    processingMethods.add(ImageProcessing.colorHalftone);
  }
}