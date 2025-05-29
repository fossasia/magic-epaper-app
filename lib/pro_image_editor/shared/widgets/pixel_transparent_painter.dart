import 'package:flutter/widgets.dart';

/// A custom painter that creates a pixelated transparent pattern.
///
/// The [PixelTransparentPainter] widget is a [CustomPainter] that paints a
/// checkered grid pattern using two alternating colors. This is often used
/// to represent transparency in image editing applications.
///
/// The grid is made up of square cells, with the size of each cell controlled
/// by the [cellSize] constant.
///
/// Example usage:
/// ```dart
/// PixelTransparentPainter(
///   primary: Colors.white,
///   secondary: Colors.grey,
/// );
/// ```
class PixelTransparentPainter extends CustomPainter {
  /// Creates a new [PixelTransparentPainter] with the given colors.
  ///
  /// The [primary] and [secondary] colors are used to alternate between the
  /// cells in the grid.
  const PixelTransparentPainter({
    required this.primary,
    required this.secondary,
  });

  /// The primary color used for alternating cells in the grid.
  final Color primary;

  /// The secondary color used for alternating cells in the grid.
  final Color secondary;

  @override
  void paint(Canvas canvas, Size size) {
    const cellSize = 22.0; // Size of each square
    final numCellsX = size.width / cellSize;
    final numCellsY = size.height / cellSize;

    for (int row = 0; row < numCellsY; row++) {
      for (int col = 0; col < numCellsX; col++) {
        final color = (row + col) % 2 == 0 ? primary : secondary;
        canvas.drawRect(
          Rect.fromLTWH(col * cellSize, row * cellSize, cellSize, cellSize),
          Paint()..color = color,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
