import 'package:flutter/material.dart';
import 'package:magicepaperapp/util/epd/configurable_editor.dart';
import 'package:magicepaperapp/util/epd/display_device.dart';
import 'package:magicepaperapp/util/epd/gdey037z03.dart';
import 'package:magicepaperapp/util/epd/gdey037z03bw.dart';
import 'package:magicepaperapp/util/epd/waveshare_displays.dart';
import 'package:magicepaperapp/util/epd/gdeq031t10.dart';

class EpdUtils {
  static final List<DisplayDevice Function()> _deviceFactories = [
    () => Gdey037z03(),
    () => Gdey037z03BW(),
    () => GDEQ031T10(),
    () => Waveshare2in9(),
    () => Waveshare2in9b(),
    () => Waveshare2in13(),
    () => Waveshare2in7(),
    () => Waveshare4in2(),
    () => Waveshare7in5(),
    () => Waveshare7in5HD(),
  ];

  static DisplayDevice getEpdFromMetadata(Map<String, dynamic>? metadata) {
    final String? epdModel = metadata?['epdModel']?.toString();
    if (epdModel != null && epdModel.isNotEmpty) {
      for (final make in _deviceFactories) {
        final device = make();
        if (device.modelId == epdModel) return device;
      }
    }

    final custom = _reconstructCustomDevice(metadata, epdModel);
    if (custom != null) return custom;

    switch (epdModel) {
      case 'GDEY037Z03':
        return Gdey037z03();
      case 'GDEY037T03':
        return Gdey037z03BW();
      case '17746':
      case 'waveshare-2.9':
        return Waveshare2in9();
      case '13339':
      case 'waveshare-2.9b':
        return Waveshare2in9b();
      case '17745':
      case 'waveshare-2.13':
        return Waveshare2in13();
      case '18136':
      case 'waveshare-2.7':
        return Waveshare2in7();
      case '17341':
      case 'waveshare-4.2':
        return Waveshare4in2();
      case '17675':
      case 'waveshare-7.5':
        return Waveshare7in5();
      case '18082':
      case 'waveshare-7.5-hd':
        return Waveshare7in5HD();
      case 'GDEQ031T10':
        return GDEQ031T10();
      default:
        return Gdey037z03();
    }
  }

  static DisplayDevice? _reconstructCustomDevice(
      Map<String, dynamic>? metadata, String? epdModel) {
    final width = metadata?['epdWidth'];
    final height = metadata?['epdHeight'];
    final rawColors = metadata?['epdColors'];
    if (width is! int || height is! int || rawColors is! List) return null;
    return ConfigurableEpd(
      width: width,
      height: height,
      colors: [for (final c in rawColors) Color(c as int)],
      modelId: (epdModel == null || epdModel.isEmpty) ? 'NA' : epdModel,
    );
  }
}
