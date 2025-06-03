import 'package:flutter/material.dart';
import 'package:magic_epaper_app/provider/getitlocator.dart';
import 'package:magic_epaper_app/provider/image_loader.dart';
import 'package:provider/provider.dart';
import 'package:magic_epaper_app/view/display_selection_screen.dart';

void main() {
  setupLocator();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ImageLoader()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Magic Epaper',
      home: DisplaySelectionScreen(),
    );
  }
}
