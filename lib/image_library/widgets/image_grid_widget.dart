import 'package:flutter/material.dart';
import 'package:magicepaperapp/image_library/model/saved_image_model.dart';
import 'package:magicepaperapp/image_library/widgets/image_card_widget.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

AppLocalizations appLocalizations = getIt.get<AppLocalizations>();

class ImageGridWidget extends StatelessWidget {
  final List<SavedImage> images;
  final bool isDeleteMode;
  final Set<String> selectedImages;
  final Function(SavedImage) onImageTap;

  const ImageGridWidget({
    super.key,
    required this.images,
    required this.isDeleteMode,
    required this.selectedImages,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return Center(
        child: Text(
          appLocalizations.noImagesMatchSearch,
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final image = images[index];
        final isSelected = selectedImages.contains(image.id);

        return ImageCardWidget(
          image: image,
          isDeleteMode: isDeleteMode,
          isSelected: isSelected,
          onTap: () => onImageTap(image),
        );
      },
    );
  }
}
