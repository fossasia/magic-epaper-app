// Flutter imports:
import 'package:flutter/material.dart';
import 'package:magic_epaper_app/provider/color_palette_provider.dart';
import 'package:provider/provider.dart';

/// A stateful widget that provides a color picker inspired by WhatsApp.
///
/// This color picker allows users to select a color, providing a callback for
/// color changes and initializing with a specified color.
class ColorPickerCustom extends StatefulWidget {
  /// Creates a [ColorPickerCustom].
  ///
  /// This color picker lets users select a color, triggering a callback when
  /// the color changes, and initializing with a specified color.
  ///
  /// Example:
  /// ```
  /// ColorPickerCustom(
  ///   onColorChanged: (color) {
  ///     // Handle color change
  ///   },
  ///   initColor: Colors.blue,
  /// )
  /// ```
  const ColorPickerCustom({
    super.key,
    required this.onColorChanged,
  });

  /// Callback for handling color changes.
  ///
  /// This callback is triggered whenever the user selects a new color, allowing
  /// the application to update its UI or perform other actions.
  final ValueChanged<Color> onColorChanged;

  /// The initial color selected in the color picker.
  ///
  /// This color sets the initial value of the picker, providing a starting
  /// point for color selection.

  @override
  State<ColorPickerCustom> createState() => _ColorPickerCustomState();
}

class _ColorPickerCustomState extends State<ColorPickerCustom> {
  Color _selectedColor = Colors.black;
  List<Color> _colors = [];

  @override
  Widget build(BuildContext context) {
    _colors = context.watch<ColorPaletteProvider>().colors;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      scrollDirection: Axis.horizontal,
      primary: false,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        Color color = _colors[index];
        bool selected = _selectedColor == color;
        double size = !selected ? 20 : 24;
        double borderWidth = !selected ? 2.5 : 4;
        return Center(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = color;
                widget.onColorChanged(color);
              });
            },
            child: AnimatedContainer(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              duration: const Duration(milliseconds: 100),
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: Colors.grey,
                  width: borderWidth,
                ),
              ),
            ),
          ),
        );
      },
      itemCount: _colors.length,
    );
  }
}
