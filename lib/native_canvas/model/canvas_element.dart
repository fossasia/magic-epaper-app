import 'dart:typed_data';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

enum CanvasElementKind {
  text,

  image,

  barcode,

  widget,
}

const Object _noChange = Object();

@immutable
class CanvasElement {
  final String id;

  final CanvasElementKind kind;

  final Offset position;

  final double scale;

  final double rotation;

  final Size baseSize;

  final Color color;

  final String? text;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final String? fontFamily;

  final Uint8List? imageBytes;

  final String? barcodeData;

  final Barcode? barcode;

  final Widget? child;
  final bool followCanvasTheme;
  final String? elementId;

  const CanvasElement({
    required this.id,
    required this.kind,
    required this.position,
    required this.baseSize,
    this.scale = 1.0,
    this.rotation = 0.0,
    this.color = Colors.black,
    this.text,
    this.fontSize = 24,
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.center,
    this.fontFamily,
    this.imageBytes,
    this.barcodeData,
    this.barcode,
    this.child,
    this.followCanvasTheme = true,
    this.elementId,
  });

  CanvasElement copyWith({
    Offset? position,
    double? scale,
    double? rotation,
    Size? baseSize,
    Color? color,
    String? text,
    double? fontSize,
    FontWeight? fontWeight,
    TextAlign? textAlign,
    Object? fontFamily = _noChange,
    Uint8List? imageBytes,
    String? barcodeData,
    Barcode? barcode,
    bool? followCanvasTheme,
  }) {
    return CanvasElement(
      id: id,
      kind: kind,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
      baseSize: baseSize ?? this.baseSize,
      color: color ?? this.color,
      text: text ?? this.text,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      textAlign: textAlign ?? this.textAlign,
      fontFamily: identical(fontFamily, _noChange)
          ? this.fontFamily
          : fontFamily as String?,
      imageBytes: imageBytes ?? this.imageBytes,
      barcodeData: barcodeData ?? this.barcodeData,
      barcode: barcode ?? this.barcode,
      child: child,
      followCanvasTheme: followCanvasTheme ?? this.followCanvasTheme,
      elementId: elementId,
    );
  }
}
