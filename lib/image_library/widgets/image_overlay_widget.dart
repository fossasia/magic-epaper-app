import 'package:flutter/material.dart';
import 'package:magic_epaper_app/image_library/model/saved_image_model.dart';
import 'package:magic_epaper_app/image_library/utils/source_utils.dart';
import 'package:magic_epaper_app/constants/color_constants.dart';

class ImageOverlayWidget extends StatelessWidget {
  final SavedImage image;
  final bool isDeleteMode;
  final bool isSelected;

  const ImageOverlayWidget({
    super.key,
    required this.image,
    required this.isDeleteMode,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (isDeleteMode && isSelected)
          const Positioned(
            top: 8,
            right: 8,
            child: CircleAvatar(
              backgroundColor: colorAccent,
              radius: 12,
              child: Icon(Icons.check, color: Colors.white, size: 16),
            ),
          ),
        if (!isDeleteMode) ...[
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: SourceUtils.getSourceColor(image.source),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                SourceUtils.getSourceLabel(image.source),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          if (image.metadata != null && image.metadata!.containsKey('epdModel'))
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  image.metadata!['epdModel'].toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }
}
