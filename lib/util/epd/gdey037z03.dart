
import 'package:flutter/material.dart';
import 'package:magic_epaper_app/util/epd/driver/uc8252.dart';
import 'driver/driver.dart';
import 'edp.dart';

class Gdey037z03 implements Epd {
  @override
  get width => 240; // pixels
  
  @override
  get height => 416; // pixels
  
  @override
  get colors => [Colors.black, Colors.white, Colors.red];

  @override
  get controller => Uc8252() as Driver;

  @override
  noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}