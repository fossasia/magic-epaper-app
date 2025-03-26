import 'package:flutter/material.dart';
import 'edit_image.dart';

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
                Navigator.push(context, MaterialPageRoute(builder: (context) => const EditImage()));
              },
              child: const Text('240x416 B/W/R (UC8252)'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const EditImage()));
              },
              child: const Text('240x416 B/W (UC8252)'),
            ),
          ],
        ),
      ),
    );
  }
}