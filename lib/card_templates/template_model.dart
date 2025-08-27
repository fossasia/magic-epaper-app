import 'package:flutter/material.dart';

class TemplateItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isEnabled;
  final Function(BuildContext) onTap;

  TemplateItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.isEnabled,
    required this.onTap,
  });
}
