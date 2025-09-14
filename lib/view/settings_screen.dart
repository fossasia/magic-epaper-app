import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/provider/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:magicepaperapp/util/orientation_util.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';

AppLocalizations appLocalizations = getIt.get<AppLocalizations>();

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
        return 'हिंदी (Beta - Partial Translation)';
      case 'en':
      default:
        return 'English';
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return CommonScaffold(
      index: 4,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appLocalizations.language,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: colorWhite,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
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
      title: appLocalizations.appName,
    );
  }
}
