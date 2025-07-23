import 'package:flutter/material.dart';
import 'package:magic_epaper_app/card_templates/employee_id_form.dart';
import 'package:magic_epaper_app/card_templates/price_tag_form.dart';

class CardTemplateSelectionView extends StatelessWidget {
  final int width;
  final int height;

  const CardTemplateSelectionView(
      {super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Card Template'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Employee ID Card'),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      EmployeeIdForm(width: width, height: height),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Shop Price Tag'),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      PriceTagForm(width: width, height: height),
                ),
              );
            },
          ),
          // TODO: Navigate to Entry Pass Tag form
          // ListTile(
          //   title: const Text('Entry Pass Tag'),
          //   onTap: () {
          //   },
          // ),
        ],
      ),
    );
  }
}
