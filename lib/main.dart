import 'package:flutter/material.dart';
import 'package:magic_epaper_app/provider/image_loader.dart';
import 'package:magic_epaper_app/provider/display_provider.dart';
import 'package:provider/provider.dart';

import 'package:magic_epaper_app/view/display_selection_screen.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ImageLoader()),
    ChangeNotifierProvider(create: (context) => DisplayProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magic Epaper',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: const DisplaySelectionScreen(),
    );
  }
}
