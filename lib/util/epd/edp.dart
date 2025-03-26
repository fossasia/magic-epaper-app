import 'driver/driver.dart';
import 'package:flutter/material.dart';

abstract class Epd {
  int get width;
  int get height;
  List<Color> get colors;
  Driver get controller;
  // void howToWrite ???
  // void howToAdjust ???
}