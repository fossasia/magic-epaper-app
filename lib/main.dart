import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:fluttertoast/fluttertoast.dart';
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


  void nfc_write(BuildContext context) async {
    try {
      NFCAvailability availability = await FlutterNfcKit.nfcAvailability;

      if (availability == NFCAvailability.not_supported) {
        _showDialog(context, 'NFC not supported on this device.');
        return;
      }

      if (availability == NFCAvailability.disabled) {
        _showDialog(context, 'NFC is turned off. Please enable it.');
        return;
      }

      ImageHandler imageHandler = ImageHandler();
      await imageHandler.loadRaster('assets/images/black-red.png');
      var (red, black) = imageHandler.toEpdBiColor();

      int chunkSize = 220; // NFC tag can handle 255 bytes per chunk.
      List<Uint8List> redChunks = MagicEpd.divideUint8List(red, chunkSize);
      List<Uint8List> blackChunks = MagicEpd.divideUint8List(black, chunkSize);

      // Write to NFC
      MagicEpd.writeChunk(blackChunks, redChunks);
      _showToast('Transfer started successfully!');
    } catch (e) {
      _showDialog(context, 'Error: ${e.toString()}');
    }
  }

// Helper function to show a dialog
  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('NFC Status'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

// Helper function to show a toast
  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
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
                nfc_write(context);
              },
              child: Text('Start transfer'),
            ),
          ],
        ),
      ),
    );
  }
}
