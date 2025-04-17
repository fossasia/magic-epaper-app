import 'package:flutter/material.dart';
import 'package:magic_epaper_app/draw_canvas/models/overlay_item.dart';

Widget buildTextOverlayDialog({
  required BuildContext context,
  required Color selectedColor,
  required void Function(OverlayItem) onItemCreated,
}) {
  TextEditingController controller = TextEditingController();
  double selectedFontSize = 24;
  String selectedFont = 'Roboto';
  List<String> fontOptions = [
    'Roboto',
    'Open Sans',
    'Lato',
    'Montserrat',
    'Oswald'
  ];

  return StatefulBuilder(
    builder: (context, setDialogState) => AlertDialog(
      title: Text("Enter Text"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: controller),
          const SizedBox(height: 10),
          DropdownButton<String>(
            value: selectedFont,
            onChanged: (value) => setDialogState(() => selectedFont = value!),
            items: fontOptions.map((font) {
              return DropdownMenuItem(
                value: font,
                child: Text(font, style: TextStyle(fontFamily: font)),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text("Font size: ${selectedFontSize.toInt()}"),
              Expanded(
                child: Slider(
                  value: selectedFontSize,
                  min: 12,
                  max: 48,
                  divisions: 12,
                  onChanged: (value) =>
                      setDialogState(() => selectedFontSize = value),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            final text = controller.text;
            Navigator.pop(context);
            if (text.isNotEmpty) {
              onItemCreated(
                OverlayItem.text(
                  text: text,
                  color: selectedColor,
                  font: selectedFont,
                  fontSize: selectedFontSize,
                ),
              );
            }
          },
          child: Text("Add"),
        ),
      ],
    ),
  );
}
