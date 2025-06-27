import 'package:flutter/material.dart';
import 'package:magic_epaper_app/image_library/model/saved_image_model.dart';
import 'package:magic_epaper_app/image_library/widgets/image_card_widget.dart';

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
      return const Center(
        child: Text(
          'No images match your search',
          style: TextStyle(color: Colors.grey, fontSize: 16),
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
