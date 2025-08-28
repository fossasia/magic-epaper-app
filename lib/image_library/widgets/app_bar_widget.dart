import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/color_constants.dart';

class LibraryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDeleteMode;
  final int selectedCount;
  final VoidCallback onDeletePressed;
  final VoidCallback onExitDeleteMode;
  final VoidCallback onEnterDeleteMode;
  final VoidCallback onClearAllPressed;

  const LibraryAppBar({
    super.key,
    required this.isDeleteMode,
    required this.selectedCount,
    required this.onDeletePressed,
    required this.onExitDeleteMode,
    required this.onEnterDeleteMode,
    required this.onClearAllPressed,
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
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              switch (value) {
                case 'clear_all':
                  onClearAllPressed();
                  break;
              }
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            elevation: 8,
            shadowColor: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 10),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'clear_all',
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.red.withOpacity(0.05),
                    border: Border.all(color: Colors.red.withOpacity(0.1)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.delete_forever_outlined,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Clear All Data',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Remove all images',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
