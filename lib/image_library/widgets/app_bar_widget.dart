import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

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
              padding: const EdgeInsets.only(right: Dimens.spacingS),
              child: TextButton(
                onPressed: onDeletePressed,
                style: TextButton.styleFrom(
                  backgroundColor: colorAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimens.radiusM),
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
              borderRadius: BorderRadius.circular(Dimens.radiusXl),
            ),
            color: Colors.white,
            elevation: 8,
            shadowColor: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, 10),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'clear_all',
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.spacingL, vertical: Dimens.spacingS),
                child: Container(
                  padding: const EdgeInsets.all(Dimens.spacingS),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimens.radiusM),
                    color: Colors.red.withValues(alpha: 0.05),
                    border:
                        Border.all(color: Colors.red.withValues(alpha: 0.1)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(Dimens.spacingSm),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(Dimens.radiusS),
                        ),
                        child: const Icon(
                          Icons.delete_forever_outlined,
                          color: Colors.red,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: Dimens.spacingM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appLocalizations.clearAllData,
                              style: const TextStyle(
                                fontSize: Dimens.fontSizeM,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: Dimens.spacingXxs),
                            Text(
                              appLocalizations.removeAllImages,
                              style: TextStyle(
                                fontSize: Dimens.fontSizeS,
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
