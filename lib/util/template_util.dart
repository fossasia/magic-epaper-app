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
  final bool followCanvasTheme;

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
    this.followCanvasTheme = false
  });

  /// Constructor for text layers
  const LayerSpec.text({
    required this.text,
    this.textStyle,
    this.textColor,
    this.backgroundColor,
    this.textAlign = TextAlign.left,
    this.offset = Offset.zero,
    this.scale = 1.0,
    this.rotation = 0.0,
    this.followCanvasTheme = true,
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
        textAlign = null,
        followCanvasTheme = false;      

  LayerSpec copyWith({
    Color? textColor,
    Color? backgroundColor,
    bool? followCanvasTheme,
  }) {
    if (text == null) return this;
    return LayerSpec.text(
      text: text!,
      textStyle: textStyle,
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textAlign: textAlign,
      offset: offset,
      scale: scale,
      rotation: rotation,
      followCanvasTheme: followCanvasTheme ?? this.followCanvasTheme,
    );
  }
}