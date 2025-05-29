import 'package:flutter/widgets.dart';

/// A widget that visually highlights a paragraph with a colored left border.
///
/// Useful for drawing attention to a block of content, such as a tip,
/// warning, or important note.
///
/// You can customize the [color] of the border and apply optional [margin]
/// around the widget. The [child] is the content displayed inside.
class ParagraphInfoWidget extends StatelessWidget {
  /// Creates a [ParagraphInfoWidget].
  ///
  /// The [child] is required and will be displayed inside the bordered area.
  /// You can optionally customize the [margin] and [color].
  const ParagraphInfoWidget({
    super.key,
    required this.child,
    this.margin,
    this.color = const Color(0xFF0f7dff),
  });

  /// The widget displayed inside the bordered container.
  final Widget child;

  /// Optional margin around the container.
  final EdgeInsets? margin;

  /// The color of the left border.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: color,
            width: 2,
          ),
        ),
      ),
      child: child,
    );
  }
}
