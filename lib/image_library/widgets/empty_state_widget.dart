import 'package:flutter/material.dart';
import 'package:magicepaperapp/provider/locale_provider.dart';


class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.photo_library_outlined,
              size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            LocaleProvider.current!.noSavedImagesYet,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            LocaleProvider.current!.saveImagesFromEditor,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
