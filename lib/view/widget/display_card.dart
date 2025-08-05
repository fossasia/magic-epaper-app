import 'package:flutter/material.dart';
import 'package:magic_epaper_app/constants/color_constants.dart';
import 'package:magic_epaper_app/util/color_util.dart';
import 'package:magic_epaper_app/util/epd/display_device.dart';
import 'package:magic_epaper_app/util/epd/epd.dart';
import 'package:magic_epaper_app/util/epd/configurable_editor.dart';
import 'package:magic_epaper_app/view/widget/color_dot.dart';

class DisplayCard extends StatelessWidget {
  // 1. Changed from Epd to DisplayDevice
  final DisplayDevice display;
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
    // 2. Add logic to safely get the driver name or a default value
    final String driverText;
    final currentDisplay =
        display; // Use a local variable for easier type promotion

    if (currentDisplay is ConfigurableEpd) {
      driverText = 'NA';
    } else if (currentDisplay is Epd) {
      driverText = currentDisplay.driverName;
    } else {
      // For devices like Waveshare that aren't Epd
      driverText = 'Waveshare NFC';
    }

    return InkWell(
      onTap: onTap,
      highlightColor: Colors.redAccent,
      borderRadius: BorderRadius.circular(12),
      splashColor: Colors.redAccent.withAlpha(51), // withValues is deprecated
      child: Card(
        color: Colors.white,
        elevation: isSelected ? 4 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? colorPrimary : Colors.grey.shade300,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(11),
                  topRight: Radius.circular(11),
                ),
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      display.imgPath,
                      fit: BoxFit.contain,
                      height: 160,
                      errorBuilder: (context, error, stackTrace) {
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
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    display.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: display.colors
                        .map((color) => ColorDot(color: color))
                        .toList(),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    display.colors
                        .map(ColorUtils.getColorDisplayName)
                        .join(', '),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildSpecRow('Model:', display.modelId),
                  _buildSpecRow(
                      'Resolution:', '${display.width} × ${display.height}'),
                  // 3. Use the new driverText variable
                  _buildSpecRow('Driver:', driverText),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
