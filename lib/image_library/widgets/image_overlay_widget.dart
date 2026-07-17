import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/image_library/model/saved_image_model.dart';
import 'package:magicepaperapp/image_library/utils/source_utils.dart';
import 'package:magicepaperapp/constants/color_constants.dart';

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
              child:
                  Icon(Icons.check, color: colorWhite, size: Dimens.iconSizeS),
            ),
          ),
        if (!isDeleteMode) ...[
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.spacingSm, vertical: Dimens.spacingXxs),
              decoration: BoxDecoration(
                color: SourceUtils.getSourceColor(image.source),
                borderRadius: BorderRadius.circular(Dimens.radiusM),
              ),
              child: Text(
                SourceUtils.getSourceLabel(image.source),
                style: const TextStyle(
                  color: colorWhite,
                  fontSize: Dimens.fontSizeXs,
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
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.spacingSm, vertical: Dimens.spacingXxs),
                decoration: BoxDecoration(
                  color: colorBlack.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(Dimens.radiusM),
                ),
                child: Text(
                  image.metadata!['epdModel'].toString(),
                  style: const TextStyle(
                    color: colorWhite,
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
