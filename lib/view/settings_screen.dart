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
      case 'de':
        return 'Deutsch';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'he':
        return 'עברית';
      case 'hi':
        return 'हिंदी';
      case 'id':
        return 'Bahasa Indonesia';
      case 'ja':
        return '日本語';
      case 'nb':
        return 'Norsk Bokmål';
      case 'pt':
        return 'Português';
      case 'ru':
        return 'Русский';
      case 'uk':
        return 'Українська';
      case 'vi':
        return 'Tiếng Việt';
      case 'zh':
        return '中文';
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
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      value: const Locale('de'),
                      child: Text(
                        _getLanguageName(const Locale('de')),
                        style: const TextStyle(color: colorBlack),
                      ),
                    ),
                    DropdownMenuItem<Locale>(
                      value: const Locale('es'),
                      child: Text(
                        _getLanguageName(const Locale('es')),
                        style: const TextStyle(color: colorBlack),
                      ),
                    ),
                    DropdownMenuItem<Locale>(
                      value: const Locale('fr'),
                      child: Text(
                        _getLanguageName(const Locale('fr')),
                        style: const TextStyle(color: colorBlack),
                      ),
                    ),
                    DropdownMenuItem<Locale>(
                      value: const Locale('he'),
                      child: Text(
                        _getLanguageName(const Locale('he')),
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
                    DropdownMenuItem<Locale>(
                      value: const Locale('id'),
                      child: Text(
                        _getLanguageName(const Locale('id')),
                        style: const TextStyle(color: colorBlack),
                      ),
                    ),
                    DropdownMenuItem<Locale>(
                      value: const Locale('ja'),
                      child: Text(
                        _getLanguageName(const Locale('ja')),
                        style: const TextStyle(color: colorBlack),
                      ),
                    ),
                    DropdownMenuItem<Locale>(
                      value: const Locale('nb'),
                      child: Text(
                        _getLanguageName(const Locale('nb')),
                        style: const TextStyle(color: colorBlack),
                      ),
                    ),
                    DropdownMenuItem<Locale>(
                      value: const Locale('pt'),
                      child: Text(
                        _getLanguageName(const Locale('pt')),
                        style: const TextStyle(color: colorBlack),
                      ),
                    ),
                    DropdownMenuItem<Locale>(
                      value: const Locale('ru'),
                      child: Text(
                        _getLanguageName(const Locale('ru')),
                        style: const TextStyle(color: colorBlack),
                      ),
                    ),
                    DropdownMenuItem<Locale>(
                      value: const Locale('uk'),
                      child: Text(
                        _getLanguageName(const Locale('uk')),
                        style: const TextStyle(color: colorBlack),
                      ),
                    ),
                    DropdownMenuItem<Locale>(
                      value: const Locale('vi'),
                      child: Text(
                        _getLanguageName(const Locale('vi')),
                        style: const TextStyle(color: colorBlack),
                      ),
                    ),
                    DropdownMenuItem<Locale>(
                      value: const Locale('zh'),
                      child: Text(
                        _getLanguageName(const Locale('zh')),
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
