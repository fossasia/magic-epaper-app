import 'package:flutter/services.dart';

/// Sets the preferred orientation to portrait only (up and down).
Future<void> setPortraitOrientation() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
