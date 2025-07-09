// Flutter imports:
import 'package:flutter/material.dart';
import 'package:magic_epaper_app/pro_image_editor/features/color_picker.dart';

// Project imports:
import 'package:pro_image_editor/features/text_editor/widgets/text_editor_bottom_bar.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

/// A stateful widget that represents the bottom bar for text editing in the
/// WhatsApp theme.
///
/// This widget provides controls for adjusting text color and font style,
/// using a design inspired by WhatsApp.

class TextBottomBar extends StatefulWidget {
  /// Creates a [TextBottomBar] widget.
  ///
  /// This bottom bar allows users to customize text color and font style,
  /// integrating seamlessly with the WhatsApp theme.
  ///
  /// Example:
  /// ```
  /// TextBottomBar(
  ///   configs: myEditorConfigs,
  ///   initColor: Colors.black,
  ///   onColorChanged: (color) {
  ///     // Handle color change
  ///   },
  ///   selectedStyle: TextStyle(fontSize: 16),
  ///   onFontChange: (style) {
  ///     // Handle font change
  ///   },
  /// )
  /// ```
  const TextBottomBar({
    super.key,
    required this.configs,
    required this.initColor,
    required this.onColorChanged,
    required this.selectedStyle,
    required this.onFontChange,
  });

  /// The configuration for the image editor.
  ///
  /// These settings determine various aspects of the bottom bar's behavior and
  /// appearance, ensuring it aligns with the application's overall theme.
  final ProImageEditorConfigs configs;

  /// The initial color for the text.
  ///
  /// This color sets the initial text color, providing a starting point for
  /// color customization.
  final Color initColor;

  /// Callback function for handling color changes.
  ///
  /// This function is called whenever the user selects a new text color,
  /// allowing the application to update the text appearance.
  final ValueChanged<Color> onColorChanged;

  /// The currently selected text style.
  ///
  /// This style is used to initialize the font selection, providing a starting
  /// point for font customization and styling.
  final TextStyle selectedStyle;

  /// Callback function for changing the text font style.
  ///
  /// This function is called whenever the user selects a new font style,
  /// allowing the application to update the text style.
  final Function(TextStyle style) onFontChange;

  @override
  State<TextBottomBar> createState() => _TextBottomBarState();
}

class _TextBottomBarState extends State<TextBottomBar> {
  final double _space = 10;

  bool _showColorPicker = true;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: _space + MediaQuery.viewPaddingOf(context).bottom,
      left: _space,
      right: 0,
      height: 40,
      child: widget.configs.designMode == ImageEditorDesignMode.cupertino
          ? TextEditorBottomBar(
              configs: widget.configs,
              selectedStyle: widget.selectedStyle,
              onFontChange: widget.onFontChange,
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _showColorPicker = !_showColorPicker;
                    });
                  },
                  icon: !_showColorPicker
                      ? const Icon(Icons.color_lens)
                      : Text(
                          'Aa',
                          style:
                              widget.configs.textEditor.customTextStyles?.first,
                        ),
                  style: IconButton.styleFrom(backgroundColor: Colors.black38),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(14.0, 4, 0, 4),
                  width: 1.5,
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                _showColorPicker
                    ? Expanded(
                        child: ColorPickerCustom(
                          onColorChanged: widget.onColorChanged,
                        ),
                      )
                    : Expanded(
                        child: TextEditorBottomBar(
                          configs: widget.configs,
                          selectedStyle: widget.selectedStyle,
                          onFontChange: widget.onFontChange,
                        ),
                      ),
              ],
            ),
    );
  }
}
