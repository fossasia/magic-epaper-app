import 'package:flutter/material.dart';

class SourceUtils {
  static Color getSourceColor(String source) {
    switch (source) {
      case 'imported':
        return Colors.blue;
      case 'editor':
        return Colors.orange;
      default:
        return Colors.grey;
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
