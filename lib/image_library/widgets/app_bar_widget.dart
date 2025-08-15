import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/color_constants.dart';

class LibraryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDeleteMode;
  final int selectedCount;
  final VoidCallback onDeletePressed;
  final VoidCallback onExitDeleteMode;
  final VoidCallback onEnterDeleteMode;

  const LibraryAppBar({
    super.key,
    required this.isDeleteMode,
    required this.selectedCount,
    required this.onDeletePressed,
    required this.onExitDeleteMode,
    required this.onEnterDeleteMode,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: colorAccent,
      elevation: 0,
      title: Text(
        isDeleteMode ? 'Select Images to Delete' : 'Image Library',
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        if (isDeleteMode) ...[
          if (selectedCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton(
                onPressed: onDeletePressed,
                style: TextButton.styleFrom(
                  backgroundColor: colorAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.white, width: 1),
                  ),
                ),
                child: Text('Delete ($selectedCount)'),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onExitDeleteMode,
          ),
        ] else ...[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onEnterDeleteMode,
            tooltip: 'Delete Mode',
          ),
        ],
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
