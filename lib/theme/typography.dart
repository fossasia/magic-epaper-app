import 'package:flutter/material.dart';
import 'package:magicepaperapp/theme/colors.dart';

class AppTypography {
  AppTypography._();

  static const TextStyle dialogTitle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: colorBlack,
  );

  static const TextStyle floatingLabel = TextStyle(color: colorAccent);

  static const TextStyle textButton = TextStyle(fontWeight: FontWeight.bold);

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
}
