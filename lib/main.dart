import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:typed_data';

import 'epdutils.dart';
import 'imagehandler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}

class MyHomePage extends StatelessWidget {
  void nfc_write() async {
    ImageHandler imageHandler = ImageHandler();
    // imageHandler.loadRaster('assets/images/tux-fit.png');
    await imageHandler.loadRaster('assets/images/black-red.png');
    var (red, black) = imageHandler.toEpdBiColor();

    int chunkSize = 220; // NFC tag can handle 255 bytes per chunk.
    List<Uint8List> redChunks = MagicEpd.divideUint8List(red, chunkSize);
    List<Uint8List> blackChunks = MagicEpd.divideUint8List(black, chunkSize);
    MagicEpd.writeChunk(blackChunks, redChunks);
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('A random idea:'),
            Text(appState.current.asLowerCase),
            ElevatedButton(
              onPressed: () {
                print('button pressed!');
                nfc_write();
              },
              child: Text('Start transfer'),
            ),
          ],
        ),
      ),
    );
  }
}
