import 'package:flutter/material.dart';
import 'image_editor.dart';
import 'package:magic_epaper_app/util/epd/gdey037z03bw.dart';
import 'package:magic_epaper_app/util/epd/gdey037z03.dart';

class SelectDisplay extends StatelessWidget {
  const SelectDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final gdey037z03 = Gdey037z03();
    final gdey037z03bw = Gdey037z03BW();

    return Scaffold(
      appBar: AppBar(title: const Text('Select Display')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ImageEditor(epd: gdey037z03)));
              },
              child: Text(gdey037z03.description),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ImageEditor(epd: gdey037z03bw)));
              },
              child: Text(gdey037z03bw.description),
            ),
          ],
        ),
      ),
    );
  }
}