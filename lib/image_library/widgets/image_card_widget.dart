import 'package:flutter/material.dart';
import 'package:magic_epaper_app/constants/color_constants.dart';
import 'package:magic_epaper_app/image_library/model/saved_image_model.dart';
import 'package:magic_epaper_app/image_library/utils/date_utils.dart' as dt;
import 'package:magic_epaper_app/image_library/widgets/image_overlay_widget.dart';

class ImageCardWidget extends StatelessWidget {
  final SavedImage image;
  final bool isDeleteMode;
  final bool isSelected;
  final VoidCallback onTap;

  const ImageCardWidget({
    super.key,
    required this.image,
    required this.isDeleteMode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDeleteMode && isSelected ? colorAccent : mdGrey400,
            width: isDeleteMode && isSelected ? 2.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorBlack.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.memory(
                      image.imageData,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      isAntiAlias: false,
                    ),
                  ),
                  ImageOverlayWidget(
                    image: image,
                    isDeleteMode: isDeleteMode,
                    isSelected: isSelected,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    image.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dt.DateUtils.formatRelativeDate(image.createdAt),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
