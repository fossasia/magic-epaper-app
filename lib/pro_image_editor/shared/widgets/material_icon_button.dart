import 'dart:math';

import 'package:flutter/material.dart';

/// A stateless widget that displays a material-styled icon button with a custom
/// circular background, half of which is a secondary color. Below the icon,
/// a label text is displayed.
///
/// The [MaterialIconActionButton] widget requires a primary color, secondary
/// color, icon, text, and a callback function to handle taps.
///
/// Example usage:
/// ```dart
/// MaterialIconActionButton(
///   primaryColor: Colors.blue,
///   secondaryColor: Colors.green,
///   icon: Icons.camera,
///   text: 'Camera',
///   onTap: () {
///     // Handle tap action
///   },
/// );
/// ```
class MaterialIconActionButton extends StatelessWidget {
  /// Creates a new [MaterialIconActionButton] widget.
  ///
  /// The [primaryColor] is the color of the circular background, while the
  /// [secondaryColor] is used for the half-circle overlay. The [icon] is the
  /// icon to display in the center, and [text] is the label displayed below
  /// the icon. The [onTap] callback is triggered when the button is tapped.
  const MaterialIconActionButton({
    super.key,
    required this.primaryColor,
    required this.secondaryColor,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  /// The primary color for the button's background.
  final Color primaryColor;

  /// The secondary color for the half-circle overlay.
  final Color secondaryColor;

  /// The icon to display in the center of the button.
  final IconData icon;

  /// The label displayed below the icon.
  final String text;

  /// The callback function triggered when the button is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(60),
            onTap: onTap,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                CustomPaint(
                  painter: CircleHalf(secondaryColor),
                  size: const Size(60, 60),
                ),
                Icon(icon, color: Colors.white),
              ],
            ),
          ),
          const SizedBox(height: 7),
          Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// A custom painter class that paints a half-circle.
///
/// The [CircleHalf] class takes a [color] parameter and paints half of a circle
/// on a canvas, typically used as an overlay for the
/// [MaterialIconActionButton].
class CircleHalf extends CustomPainter {
  /// Creates a new [CircleHalf] painter with the given [color].
  CircleHalf(this.color);

  /// The color to use for paint the half-circle.
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.height / 2, size.width / 2),
        height: size.height,
        width: size.width,
      ),
      pi,
      pi,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
