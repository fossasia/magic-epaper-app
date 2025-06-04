import 'package:flutter/material.dart';

class FlipControls extends StatelessWidget {
  final VoidCallback onFlipHorizontal;
  final VoidCallback onFlipVertical;

  const FlipControls({
    super.key,
    required this.onFlipHorizontal,
    required this.onFlipVertical,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.white,
            heroTag: 'flipH',
            onPressed: onFlipHorizontal,
            tooltip: 'Flip Horizontally',
            child: Image.asset(
              "assets/images/vertical_flip.png",
              height: 24,
              width: 24,
            ),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            backgroundColor: Colors.white,
            heroTag: 'flipV',
            onPressed: onFlipVertical,
            tooltip: 'Flip Vertically',
            child: Image.asset(
              "assets/images/horizontal_flip.png",
              height: 24,
              width: 24,
            ),
          ),
        ],
      ),
    );
  }
}
