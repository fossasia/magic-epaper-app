import 'package:flutter/material.dart';
import 'package:magicepaperapp/theme/colors.dart';

class SourceUtils {
  static Color getSourceColor(String source) {
    switch (source) {
      case 'imported':
        return Colors.blue;
      case 'editor':
        return Colors.orange;
      default:
        return grey500;
    }
  }

  static String getSourceLabel(String source) {
    switch (source) {
      case 'imported':
        return 'IMP';
      case 'editor':
        return 'EDT';
      default:
        return 'UNK';
    }
  }

  static String getSourceName(String source) {
    switch (source) {
      case 'imported':
        return 'Imported';
      case 'editor':
        return 'Image Editor';
      default:
        return 'Unknown';
    }
  }
}
