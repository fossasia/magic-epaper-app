import 'package:flutter/material.dart';

/// Data class for specifying a layer and its properties for layer addition.
class LayerSpec {
  final Widget? widget;
  final String? text;
  final TextStyle? textStyle;
  final Color? textColor;
  final Color? backgroundColor;
  final TextAlign? textAlign;
  final Offset offset;
  final double scale;
  final double rotation;

  const LayerSpec({
    this.widget,
    this.text,
    this.textStyle,
    this.textColor,
    this.backgroundColor,
    this.textAlign,
    this.offset = Offset.zero,
    this.scale = 1.0,
    this.rotation = 0.0,
  });

  /// Constructor for text layers
  const LayerSpec.text({
    required this.text,
    this.textStyle,
    this.textColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.textAlign = TextAlign.left,
    this.offset = Offset.zero,
    this.scale = 1.0,
    this.rotation = 0.0,
  }) : widget = null;

  /// Constructor for widget layers
  const LayerSpec.widget({
    required this.widget,
    this.offset = Offset.zero,
    this.scale = 1.0,
    this.rotation = 0.0,
  })  : text = null,
        textStyle = null,
        textColor = null,
        backgroundColor = null,
        textAlign = null;
}
