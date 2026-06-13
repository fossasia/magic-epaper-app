import 'package:flutter/material.dart';
import 'package:magicepaperapp/util/epd/configurable_editor.dart';
import 'package:magicepaperapp/util/epd/driver/driver.dart';
import 'package:magicepaperapp/util/epd/driver/uc8253.dart';
import 'package:magicepaperapp/util/epd/driver/ssd1680.dart';
import 'package:magicepaperapp/util/epd/driver/ssd1681.dart';
import 'package:magicepaperapp/util/epd/driver/uc8151d.dart';

enum DriverIC { uc8253, ssd1680, ssd1681, uc8151d }

class DynamicDisplay extends ConfigurableEpd {
  final DriverIC icType;

  DynamicDisplay({
    required super.name,
    required super.width,
    required super.height,
    required super.colors,
    required this.icType,
  }) : super(
          modelId: 'DYNAMIC_CONFIG',
        );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'width': width,
      'height': height,
      'colors': colors.map((c) => c.toARGB32()).toList(),
      'icType': icType.name,
    };
  }

  factory DynamicDisplay.fromJson(Map<String, dynamic> json) {
    return DynamicDisplay(
      name: json['name'],
      width: json['width'],
      height: json['height'],
      colors: (json['colors'] as List).map((c) => Color(c)).toList(),
      icType: DriverIC.values.firstWhere(
        (e) => e.name == json['icType'],
        orElse: () => DriverIC.uc8253,
      ),
    );
  }

  @override
  List<String>? get displayChips => ['Custom ST25DV'];

  @override
  Driver get controller {
    switch (icType) {
      case DriverIC.ssd1680:
        return Ssd1680();
      case DriverIC.ssd1681:
        return Ssd1681();
      case DriverIC.uc8151d:
        return Uc8151d();
      case DriverIC.uc8253:
        return Uc8253();
    }
  }
}
