import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/provider/locale_provider.dart';
import 'package:provider/provider.dart';
import 'package:magicepaperapp/util/orientation_util.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';

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

  static const List<Map<String, String>> _supportedLanguages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'hi', 'name': 'हिंदी'},
    {'code': 'he', 'name': 'עברית'},
    {'code': 'kn', 'name': 'ಕನ್ನಡ'},
    {'code': 'de', 'name': 'Deutsch'},
    {'code': 'es', 'name': 'Español'},
    {'code': 'fr', 'name': 'Français'},
    {'code': 'id', 'name': 'Bahasa Indonesia'},
    {'code': 'ja', 'name': '日本語'},
    {'code': 'nb', 'name': 'Norsk Bokmål'},
    {'code': 'pt', 'name': 'Português'},
    {'code': 'ru', 'name': 'Русский'},
    {'code': 'uk', 'name': 'Українська'},
    {'code': 'vi', 'name': 'Tiếng Việt'},
    {'code': 'zh', 'name': '中文'},
  ];

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
              LocaleProvider.current!.language,
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
                child: DropdownButton<String>(
                  value: localeProvider.locale.languageCode,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: mdGrey400),
                  onChanged: (String? newCode) {
                    if (newCode != null) {
                      localeProvider.setLocale(Locale(newCode));
                    }
                  },
                  items: _supportedLanguages.map((lang) {
                    return DropdownMenuItem<String>(
                      value: lang['code'],
                      child: Text(
                        lang['name']!,
                        style: const TextStyle(color: colorBlack),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      title: LocaleProvider.current!.appName,
    );
  }
}
