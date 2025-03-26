import 'package:flutter/material.dart';
import 'image_editor.dart';
import 'package:magic_epaper_app/util/epd/gdey037z03bw.dart';
import 'package:magic_epaper_app/util/epd/gdey037z03.dart';

class SelectDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Select Display')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ImageEditor(epd: Gdey037z03())));
              },
              child: const Text('240x416 B/W/R (UC8252)'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ImageEditor(epd: Gdey037z03BW())));
              },
              child: const Text('240x416 B/W (UC8252)'),
            ),
          ],
        ),
      ),
    );
  }
}