import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

AppLocalizations appLocalizations = getIt.get<AppLocalizations>();

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
        isDeleteMode
            ? appLocalizations.selectImagesToDelete
            : appLocalizations.imageLibrary,
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
                child: Text('${appLocalizations.delete} ($selectedCount)'),
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
            tooltip: appLocalizations.deleteMode,
          ),
        ],
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
