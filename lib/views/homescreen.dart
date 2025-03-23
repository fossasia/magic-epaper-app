import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:magic_epaper_app/views/share.dart';
import 'package:magic_epaper_app/views/settings.dart';
import 'package:magic_epaper_app/views/camera.dart';
import 'package:magic_epaper_app/views/drawing.dart';


class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
    final List<Widget> _pages = [
      DrawingBoard(),         // Page 1
    Camera(),       // Page 2
    Share(),        // Page 3
    Settings(),     // Page 4
  ];


  @override
  Widget build(BuildContext context) {

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

      body: _pages[_page],

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

