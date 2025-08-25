import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/util/color_util.dart';
import 'package:magicepaperapp/util/epd/display_device.dart';
import 'package:magicepaperapp/util/epd/epd.dart';
import 'package:magicepaperapp/util/epd/configurable_editor.dart';
import 'package:magicepaperapp/view/widget/color_dot.dart';

class DisplayCard extends StatelessWidget {
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
    final String driverText;
    final currentDisplay = display;

    if (currentDisplay is ConfigurableEpd) {
      driverText = 'NA';
    } else if (currentDisplay is Epd) {
      driverText = currentDisplay.driverName;
    } else {
      driverText = 'Waveshare NFC';
    }

    final chips = display.displayChips;

    return InkWell(
      onTap: onTap,
      highlightColor: Colors.redAccent,
      borderRadius: BorderRadius.circular(12),
      splashColor: Colors.redAccent.withAlpha(51),
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
                  if (chips.isNotEmpty) ...[
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: chips.map((chip) => _buildChip(chip)).toList(),
                    ),
                    const SizedBox(height: 8),
                  ],
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
                  _buildSpecRow('Driver:', driverText),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colorPrimary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorPrimary.withOpacity(0.3),
          width: 0.8,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 6,
          fontWeight: FontWeight.w600,
          color: colorPrimary,
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
