import 'package:flutter/material.dart';

class CommonAlertDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry actionsPadding;
  final MainAxisAlignment? actionsAlignment;
  final OverflowBarAlignment? actionsOverflowAlignment;
  final VerticalDirection? actionsOverflowDirection;
  final double? actionsOverflowButtonSpacing;
  final EdgeInsetsGeometry? buttonPadding;
  final Color? backgroundColor;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final String? semanticLabel;
  final ShapeBorder? shape;
  final AlignmentGeometry? alignment;
  final bool insetPadding;

  const CommonAlertDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.titlePadding,
    this.contentPadding,
    this.actionsPadding =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.actionsAlignment,
    this.actionsOverflowAlignment,
    this.actionsOverflowDirection,
    this.actionsOverflowButtonSpacing,
    this.buttonPadding,
    this.backgroundColor,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.semanticLabel,
    this.shape,
    this.alignment,
    this.insetPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title != null
          ? DefaultTextStyle(
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
              child: title!,
            )
          : null,
      content: content,
      actions: actions,
      titlePadding: titlePadding,
      contentPadding: contentPadding,
      actionsPadding: actionsPadding,
      actionsAlignment: actionsAlignment,
      actionsOverflowAlignment: actionsOverflowAlignment,
      actionsOverflowDirection: actionsOverflowDirection,
      actionsOverflowButtonSpacing: actionsOverflowButtonSpacing,
      buttonPadding: buttonPadding,
      backgroundColor: backgroundColor ?? Colors.white,
      elevation: elevation,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor ?? Colors.white,
      semanticLabel: semanticLabel,
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.0),
          ),
      alignment: alignment,
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    Widget? title,
    Widget? content,
    List<Widget>? actions,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => CommonAlertDialog(
        title: title,
        content: content,
        actions: actions,
      ),
    );
  }
}
