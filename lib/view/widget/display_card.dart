import 'package:flutter/material.dart';
import 'package:magic_epaper_app/model/display_model.dart';
import 'package:magic_epaper_app/view/widget/color_dot.dart';

/// A card that displays information about an ePaper display
class DisplayCard extends StatelessWidget {
  final DisplayModel display;
  final bool isSelected;
  final VoidCallback onTap;

  const DisplayCard({
    super.key,
    required this.display,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 250,
        width: 170,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
            width: isSelected ? 2.0 : 1.0,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(11),
                  topRight: Radius.circular(11),
                ),
                child: Container(
                  width: double.infinity,
                  color: Colors.grey.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      display.imagePath,
                      fit: BoxFit.contain,
                      height: 160,
                      errorBuilder: (context, error, stackTrace) {
                        print(
                            'Error loading image: ${display.imagePath} - $error');
                        // Fallback if image is not available
                        return Center(
                          child: Icon(
                            Icons.display_settings,
                            size: 60,
                            color: Colors.grey.shade400,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // Display information
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display name and size
                  Text(
                    display.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Color dots in a row
                      Row(
                        children: display.colors
                            .map((color) => ColorDot(color: color))
                            .toList(),
                      ),

                      // Color names below dots
                      const SizedBox(height: 4),
                      Text(
                        display.colorNames,
                        style: const TextStyle(fontSize: 10),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Specs
                  _buildSpecRow('Model:', display.ModelName),
                  _buildSpecRow('Resolution:', display.resolution),
                  _buildSpecRow('Aspect Ratio:', display.aspectRatio),
                  _buildSpecRow('Driver:', display.driver),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build a specification row
  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
