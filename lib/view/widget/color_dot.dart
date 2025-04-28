import 'package:flutter/material.dart';

class ColorDot extends StatelessWidget {
  final Color color;
  final double size;

  const ColorDot({
    super.key,
    required this.color,
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
      ),
    );
  }
}
