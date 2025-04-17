import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

Widget buildColorPickerDialog(BuildContext context, Color selectedColor,
    ValueChanged<Color> onColorPicked) {
  return AlertDialog(
    title: const Text("Pick a color"),
    content: BlockPicker(
      availableColors: [Colors.black, Colors.white, Colors.red],
      pickerColor: selectedColor,
      onColorChanged: (color) {
        onColorPicked(color);
        Navigator.of(context).pop();
      },
    ),
  );
}
