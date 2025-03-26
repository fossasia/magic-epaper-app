import 'package:flutter/material.dart';
import 'package:magic_epaper_app/provider/load_image.dart';
import 'package:provider/provider.dart';

import 'package:magic_epaper_app/view/home_screen.dart';

void main() async {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ImageLoader()),
    ],
    child: const MyApp()
  ));
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
        home: SelectDisplay(),
      );
  }
}