import 'dart:convert';
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kind': kind.name,
      'position': {'dx': position.dx, 'dy': position.dy},
      'scale': scale,
      'rotation': rotation,
      'baseSize': {'w': baseSize.width, 'h': baseSize.height},
      'color': color.toARGB32(),
      if (text != null) 'text': text,
      'fontSize': fontSize,
      'fontWeight': fontWeight.value,
      'textAlign': textAlign.index,
      if (fontFamily != null) 'fontFamily': fontFamily,
      if (imageBytes != null) 'imageBytes': base64Encode(imageBytes!),
      if (barcode != null) 'barcodeName': barcode!.name,
      if (barcodeData != null) 'barcodeData': barcodeData,
      'followCanvasTheme': followCanvasTheme,
      if (elementId != null) 'elementId': elementId,
    };
  }

  factory CanvasElement.fromJson(Map<String, dynamic> json) {
    final position = json['position'] as Map<String, dynamic>;
    final baseSize = json['baseSize'] as Map<String, dynamic>;
    final imageB64 = json['imageBytes'] as String?;
    final barcodeName = json['barcodeName'] as String?;
    return CanvasElement(
      id: json['id'] as String,
      kind: CanvasElementKind.values.byName(json['kind'] as String),
      position: Offset(
        (position['dx'] as num).toDouble(),
        (position['dy'] as num).toDouble(),
      ),
      scale: (json['scale'] as num).toDouble(),
      rotation: (json['rotation'] as num).toDouble(),
      baseSize: Size(
        (baseSize['w'] as num).toDouble(),
        (baseSize['h'] as num).toDouble(),
      ),
      color: Color(json['color'] as int),
      text: json['text'] as String?,
      fontSize: (json['fontSize'] as num).toDouble(),
      fontWeight: FontWeight.values.firstWhere(
        (w) => w.value == json['fontWeight'] as int,
        orElse: () => FontWeight.normal,
      ),
      textAlign: TextAlign.values[json['textAlign'] as int],
      fontFamily: json['fontFamily'] as String?,
      imageBytes: imageB64 == null ? null : base64Decode(imageB64),
      barcode: barcodeName == null ? null : barcodeByName(barcodeName),
      barcodeData: json['barcodeData'] as String?,
      followCanvasTheme: json['followCanvasTheme'] as bool? ?? true,
      elementId: json['elementId'] as String?,
    );
  }
}

Barcode barcodeByName(String name) => _barcodesByName[name] ?? Barcode.qrCode();

final Map<String, Barcode> _barcodesByName = {
  for (final b in <Barcode>[
    Barcode.qrCode(),
    Barcode.dataMatrix(),
    Barcode.aztec(),
    Barcode.pdf417(),
    Barcode.code128(),
    Barcode.code93(),
    Barcode.code39(),
    Barcode.codabar(),
    Barcode.ean13(),
    Barcode.ean8(),
    Barcode.itf(),
    Barcode.upcA(),
  ])
    b.name: b,
};
