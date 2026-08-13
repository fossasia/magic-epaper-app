import 'package:flutter/material.dart';
import 'package:magicepaperapp/card_templates/restaurant_menu_badge.dart';
import 'package:magicepaperapp/card_templates/restaurant_menu_model.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/theme/colors.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

class RestaurantMenuCardWidget extends StatelessWidget {
  final RestaurantMenuModel menu;
  final int width;
  final int height;

  const RestaurantMenuCardWidget({
    super.key,
    required this.menu,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Container(
          decoration: BoxDecoration(
            color: colorWhite,
            borderRadius: BorderRadius.circular(Dimens.radiusM),
            border: Border.all(color: grey300),
            boxShadow: [
              BoxShadow(
                color: colorBlack.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: AspectRatio(
            aspectRatio: width / height,
            child: menu.visibleItems.isEmpty
                ? _placeholder()
                : RestaurantMenuBadge(menu: menu),
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: colorWhite,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(Dimens.spacingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 40, color: grey400),
          const SizedBox(height: Dimens.spacingS),
          Text(
            appLocalizations.menuPreviewPlaceholder,
            textAlign: TextAlign.center,
            style: TextStyle(color: grey500, fontSize: Dimens.fontSizeM),
          ),
        ],
      ),
    );
  }
}
