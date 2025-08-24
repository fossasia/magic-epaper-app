import 'package:flutter/material.dart';
import 'package:magicepaperapp/image_library/provider/image_library_provider.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/provider/image_loader.dart';
import 'package:magicepaperapp/view/about_us_screen.dart';
import 'package:magicepaperapp/view/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:magicepaperapp/ndef_screen/ndef_screen.dart';
import 'package:magicepaperapp/view/display_selection_screen.dart';

void main() {
  setupLocator();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ImageLoader()),
    ChangeNotifierProvider(create: (_) => ImageLibraryProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magic Epaper',
      initialRoute: '/',
      routes: {
        '/': (context) => const DisplaySelectionScreen(),
        '/aboutUs': (context) => const AboutUsScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/ndefScreen': (context) => const NDEFScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
