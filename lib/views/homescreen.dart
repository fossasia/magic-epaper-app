import 'package:flutter/material.dart';
import 'package:magic_epaper_app/providers/app_state.dart';
import 'package:magic_epaper_app/nfc_handler.dart';
import 'package:provider/provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text('Magic ePaper',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Michroma',
          ),
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('A random idea:'),
            Text(appState.current.asLowerCase),
            ElevatedButton(
              onPressed: () async {
                try {
                   NfcHandler().nfc_write();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data transfer started!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              },

              child: Text('Start transfer'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.red,
        backgroundColor: Colors.transparent,
        key: _bottomNavigationKey,

        items: <Widget>[
          Icon(Icons.add, color: Colors.white,size: 30),
          Icon(Icons.camera, color: Colors.white,size: 30),
          Icon(Icons.share, color: Colors.white,size: 30),
          Icon(Icons.settings,color: Colors.white, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
    );
  }
}

