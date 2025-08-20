import 'package:magicepaperapp/view/widget/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/color_constants.dart';

class CommonScaffold extends StatelessWidget {
  final String title;
  final Widget? titleWidget;
  final Widget body;
  final int index;
  final List<Widget>? actions;
  final double? toolbarHeight;

  const CommonScaffold({
    super.key,
    required this.body,
    this.title = '',
    this.titleWidget,
    required this.index,
    this.actions,
    this.toolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          );
        }),
        backgroundColor: colorAccent,
        elevation: 0,
        title: titleWidget ??
            Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
        toolbarHeight: toolbarHeight,
        actions: actions,
      ),
      drawer: AppDrawer(
        selectedIndex: index,
      ),
      body: body,
    );
  }
}
