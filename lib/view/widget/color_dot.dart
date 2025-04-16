import 'package:flutter/material.dart';

/// A widget that displays a colored dot
class ColorDot extends StatelessWidget {
  final Color color;
  final bool selected;
  final double size;

  const ColorDot({
    super.key,
    required this.color,
    this.selected = false,
    this.size = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.0,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
                )
              ]
            : null,
      ),
    );
  }
}
