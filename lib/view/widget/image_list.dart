import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:magic_epaper_app/constants/asset_paths.dart';
import 'package:magic_epaper_app/image_library/services/image_filter_helper.dart';
import 'package:magic_epaper_app/util/epd/epd.dart';
import 'package:magic_epaper_app/constants/color_constants.dart';
import 'package:magic_epaper_app/util/epd/configurable_editor.dart';

class ImageList extends StatelessWidget {
  final List<Uint8List> processedPngs;
  final Epd epd;
  final int selectedIndex;
  final bool flipHorizontal;
  final bool flipVertical;
  final Function(int) onFilterSelected;
  final Function() onFlipHorizontal;
  final Function() onFlipVertical;
  final Function()? onSave;
  final int width;
  final int height;

  const ImageList({
    super.key,
    required this.processedPngs,
    required this.epd,
    required this.selectedIndex,
    required this.flipHorizontal,
    required this.flipVertical,
    required this.onFilterSelected,
    required this.onFlipHorizontal,
    required this.onFlipVertical,
    required this.width,
    required this.height,
    this.onSave,
  });

  String getFilterNameByIndex(int index) {
    if (epd is ConfigurableEpd) {
      final configurable = epd as ConfigurableEpd;
      if (index >= 0 && index < configurable.processingMethodNames.length) {
        return configurable.processingMethodNames[index];
      }
      throw RangeError('Index $index out of range for processingMethodNames');
    } else {
      return ImageFilterHelper.getFilterNameByIndex(
          index, epd.processingMethods);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double aspectRatio = height / width;
    return Column(
      children: [
        const SizedBox(height: 8),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 202),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: mdGrey400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..scale(
                      flipHorizontal ? -1.0 : 1.0, flipVertical ? -1.0 : 1.0),
                child: Image.memory(
                  processedPngs[selectedIndex],
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFlipButton(
              assetPath: ImageAssets.flipHorizontal,
              onPressed: onFlipHorizontal,
              tooltip: 'Flip Horizontally',
            ),
            const SizedBox(width: 16),
            _buildFlipButton(
              assetPath: ImageAssets.flipHorizontal,
              onPressed: onFlipVertical,
              tooltip: 'Flip Vertically',
              rotation: -1.5708,
            ),
            if (onSave != null) ...[
              const SizedBox(width: 16),
              _buildFlipButton(
                icon: Icons.save_outlined,
                onPressed: onSave!,
                tooltip: 'Save to Library',
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        const Divider(
          thickness: 0.4,
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 4),
            itemCount: processedPngs.length,
            itemBuilder: (context, index) {
              return FilterCard(
                imageData: processedPngs[index],
                filterName: getFilterNameByIndex(index),
                isSelected: index == selectedIndex,
                flipHorizontal: flipHorizontal,
                flipVertical: flipVertical,
                onTap: () => onFilterSelected(index),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFlipButton({
    String? assetPath,
    IconData? icon,
    required VoidCallback onPressed,
    required String tooltip,
    double rotation = 0.0,
  }) {
    assert(assetPath != null || icon != null,
        'Either assetPath or icon must be provided');
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorWhite,
        boxShadow: [
          BoxShadow(
            color: colorBlack.withValues(alpha: .1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: IconButton(
        icon: Transform.rotate(
          angle: rotation,
          child: assetPath != null
              ? Image.asset(assetPath, height: 24, width: 24)
              : Icon(icon, size: 24, color: colorBlack),
        ),
        onPressed: onPressed,
        tooltip: tooltip,
      ),
    );
  }
}

class FilterCard extends StatelessWidget {
  final Uint8List imageData;
  final String filterName;
  final bool isSelected;
  final bool flipHorizontal;
  final bool flipVertical;
  final VoidCallback onTap;

  const FilterCard({
    super.key,
    required this.imageData,
    required this.filterName,
    required this.isSelected,
    required this.flipHorizontal,
    required this.flipVertical,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colorPrimary : mdGrey400,
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorPrimary.withValues(alpha: .4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    filterName,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                      color: isSelected ? colorPrimary : colorBlack,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: mdGrey400, width: 1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..scale(flipHorizontal ? -1.0 : 1.0,
                          flipVertical ? -1.0 : 1.0),
                    child: Image.memory(
                      filterQuality: FilterQuality.high,
                      imageData,
                      fit: BoxFit.contain,
                      isAntiAlias: false,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
