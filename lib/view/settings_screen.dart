import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:magicepaperapp/util/orientation_util.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';

import '../card_templates/card_template_selection_view.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    setPortraitOrientation();
    super.initState();
  }

  String _getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'hi':
        return appLocalizations.hindi;
      case 'en':
      default:
        return appLocalizations.english;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final appLocalizations = AppLocalizations.of(context)!;

    return CommonScaffold(
      index: 4,
      title: appLocalizations.appName,
      body: Padding(
        padding: const EdgeInsets.all(Dimens.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appLocalizations.language,
              style: const TextStyle(
                  fontSize: Dimens.fontSizeL, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: Dimens.spacingS),
            Container(
              decoration: BoxDecoration(
                color: colorWhite,
                borderRadius: BorderRadius.circular(Dimens.radiusM),
              ),
              padding: const EdgeInsets.symmetric(horizontal: Dimens.spacingM),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Locale>(
                  value: localeProvider.locale,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: mdGrey400),
                  onChanged: (Locale? newLocale) {
                    if (newLocale != null) {
                      localeProvider.setLocale(newLocale);
                    }
                  },
                  items: [
                    DropdownMenuItem<Locale>(
                      value: const Locale('en'),
                      child: Text(
                        _getLanguageName(const Locale('en')),
                        style: const TextStyle(color: colorBlack),
                      ),
                    ),
                    DropdownMenuItem<Locale>(
                      value: const Locale('hi'),
                      child: Text(
                        _getLanguageName(const Locale('hi')),
                        style: const TextStyle(color: colorBlack),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
