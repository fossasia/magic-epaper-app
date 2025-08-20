import 'package:flutter/material.dart';
import 'package:magicepaperapp/pro_image_editor/features/color_picker.dart';
import 'package:pro_image_editor/core/models/editor_configs/pro_image_editor_configs.dart';
import 'package:pro_image_editor/core/ui/pro_image_editor_icons.dart';

/// Represents the bottom bar for the paint functionality in the WhatsApp theme.
///
/// This widget provides controls for adjusting the stroke width and color
/// for paint operations, using a design inspired by WhatsApp.
class BottomBarCustom extends StatefulWidget {
  /// Creates a [BottomBarCustom] widget.
  ///
  /// This bottom bar allows users to select stroke widths and colors for
  /// paint, integrating seamlessly with the WhatsApp theme.
  ///
  /// Example:
  /// ```
  /// BottomBarCustom(
  ///   configs: myEditorConfigs,
  ///   strokeWidth: 5.0,
  ///   onSetLineWidth: (width) {
  ///     // Handle stroke width change
  ///   },
  ///   initColor: Colors.black,
  ///   onColorChanged: (color) {
  ///     // Handle color change
  ///   },
  /// )
  /// ```
  const BottomBarCustom({
    super.key,
    required this.configs,
    required this.strokeWidth,
    required this.onSetLineWidth,
    required this.onColorChanged,
    this.iconStrokeWidthThin = ProImageEditorIcons.penSize1,
    this.iconStrokeWidthMedium = ProImageEditorIcons.penSize2,
    this.iconStrokeWidthBold = ProImageEditorIcons.penSize3,
  });

  /// The configuration for the image editor.
  ///
  /// These settings determine various aspects of the bottom bar's behavior
  /// and appearance, ensuring it aligns with the application's overall theme.
  final ProImageEditorConfigs configs;

  /// The current stroke width for paint.
  ///
  /// This value determines the thickness of the lines drawn in the paint
  /// editor, allowing users to customize the appearance of their artwork.
  final double strokeWidth;

  /// Callback function for setting the stroke width.
  ///
  /// This function is called whenever the user selects a different stroke
  /// width, allowing the application to update the line thickness.
  final Function(double value) onSetLineWidth;

  /// The initial color for paint.
  ///
  /// This color sets the initial paint color, providing a starting point
  /// for color customization.
  final Color initColor = Colors.black;

  /// Callback function for handling color changes.
  ///
  /// This function is called whenever the user selects a new color, allowing
  /// the application to update the paint color.
  final ValueChanged<Color> onColorChanged;

  /// Icon representing thin stroke width.
  ///
  /// This icon is used to visually represent the option for selecting a
  /// thin stroke width in the paint toolbar.
  final IconData iconStrokeWidthThin;

  /// Icon representing medium stroke width.
  ///
  /// This icon is used to visually represent the option for selecting a
  /// medium stroke width in the paint toolbar.
  final IconData iconStrokeWidthMedium;

  /// Icon representing bold stroke width.
  ///
  /// This icon is used to visually represent the option for selecting a
  /// bold stroke width in the paint toolbar.
  final IconData iconStrokeWidthBold;

  @override
  State<BottomBarCustom> createState() => _BottomBarCustomState();
}

class _BottomBarCustomState extends State<BottomBarCustom> {
  final double _space = 10;

  bool _showColorPicker = true;

  bool get _isMaterial =>
      widget.configs.designMode == ImageEditorDesignMode.material;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: _space,
      left: _space,
      right: 0,
      height: 40,
      child: !_isMaterial
          ? _buildLineWidths()
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
                  icon: Icon(
                    _showColorPicker ? Icons.draw : Icons.color_lens,
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
                    : _buildLineWidths(),
              ],
            ),
    );
  }

  Widget _buildLineWidths() {
    ButtonStyle buttonStyle = IconButton.styleFrom(
      backgroundColor: Colors.black38,
      foregroundColor:
          widget.configs.paintEditor.style.bottomBarInactiveItemColor,
      padding: const EdgeInsets.all(10),
      iconSize: 22,
      minimumSize: const Size.fromRadius(10),
    );
    return Padding(
      padding: const EdgeInsets.only(left: 14),
      child: Wrap(
        alignment:
            _isMaterial ? WrapAlignment.start : WrapAlignment.spaceEvenly,
        runAlignment: WrapAlignment.center,
        spacing: 10,
        children: [
          IconButton(
            onPressed: () {
              widget.onSetLineWidth(2);
            },
            icon: Icon(widget.iconStrokeWidthThin),
            style: buttonStyle.copyWith(
              backgroundColor: widget.strokeWidth != 2
                  ? null
                  : const WidgetStatePropertyAll(Colors.white),
              foregroundColor: widget.strokeWidth != 2
                  ? null
                  : const WidgetStatePropertyAll(Colors.black),
            ),
          ),
          IconButton(
            onPressed: () {
              widget.onSetLineWidth(5);
            },
            icon: Icon(widget.iconStrokeWidthMedium),
            style: buttonStyle.copyWith(
              backgroundColor: widget.strokeWidth != 5
                  ? null
                  : const WidgetStatePropertyAll(Colors.white),
              foregroundColor: widget.strokeWidth != 5
                  ? null
                  : const WidgetStatePropertyAll(Colors.black),
            ),
          ),
          IconButton(
            onPressed: () {
              widget.onSetLineWidth(10);
            },
            icon: Icon(widget.iconStrokeWidthBold),
            style: buttonStyle.copyWith(
              backgroundColor: widget.strokeWidth != 10
                  ? null
                  : const WidgetStatePropertyAll(Colors.white),
              foregroundColor: widget.strokeWidth != 10
                  ? null
                  : const WidgetStatePropertyAll(Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
