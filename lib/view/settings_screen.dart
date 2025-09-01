import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/util/orientation_util.dart';
import 'package:magicepaperapp/view/widget/common_scaffold_widget.dart';

//TODO add Language Support and Dark mode support here
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  String selectedLanguage = 'ENGLISH';

  final List<String> languages = ['ENGLISH', 'CHINESE'];

  @override
  void initState() {
    setPortraitOrientation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      index: 2,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Language',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  value: selectedLanguage,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: mdGrey400),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLanguage = newValue!;
                    });
                  },
                  items:
                      languages.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: const TextStyle(color: colorBlack)),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      title: 'Magic ePaper',
    );
  }
}
