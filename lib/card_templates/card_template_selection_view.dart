import 'package:flutter/material.dart';
import 'package:magic_epaper_app/card_templates/employee_id_form.dart';
import 'package:magic_epaper_app/pro_image_editor/features/movable_background_image.dart';

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
              // Navigate to the form and await the list of layers.
              final layers = await Navigator.of(context).push<List<LayerSpec>>(
                MaterialPageRoute(
                  builder: (context) =>
                      EmployeeIdForm(width: width, height: height),
                ),
              );

              // If layers are returned, pop the selection view and pass them back.
              if (layers != null && context.mounted) {
                Navigator.of(context).pop(layers);
              }
            },
          ),
          ListTile(
            title: const Text('Shop Price Tag'),
            onTap: () {
              // TODO: Navigate to Shop Price Tag form
            },
          ),
          ListTile(
            title: const Text('Entry Pass Tag'),
            onTap: () {
              // TODO: Navigate to Entry Pass Tag form
            },
          ),
        ],
      ),
    );
  }
}
