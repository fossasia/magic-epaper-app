import 'dart:typed_data';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/native_canvas/model/canvas_element.dart';
import 'package:magicepaperapp/util/template_util.dart';

List<CanvasElement> buildTemplateElements({
  required int width,
  required int height,
  required List<Color> palette,
  required List<LayerSpec> layers,
}) {
  final seeder = CardLayoutSeeder(
    width: width,
    height: height,
    palette: palette,
  );
  if (layers.any((s) => s.elementId == 'qr')) {
    seeder.seedCardLayout(layers);
  } else {
    seeder.seedOffsetLayers(layers);
  }
  return seeder.elements;
}

List<CanvasElement> toSerializableElements(
  List<CanvasElement> elements, {
  Uint8List? photoBytes,
  String? qrData,
  String? barcodeData,
}) {
  final result = <CanvasElement>[];
  for (final e in elements) {
    if (e.kind != CanvasElementKind.widget) {
      result.add(e);
      continue;
    }
    if ((e.elementId == 'profileImage' || e.elementId == 'productImage') &&
        photoBytes != null) {
      result.add(_rebuild(e,
          kind: CanvasElementKind.image,
          imageBytes: photoBytes,
          clipOval: e.elementId == 'profileImage',
          cornerRadius: e.elementId == 'productImage' ? Dimens.radiusM : 0));
    } else if (e.elementId == 'qr' && (qrData ?? '').isNotEmpty) {
      result.add(_rebuild(e,
          kind: CanvasElementKind.barcode,
          barcode: Barcode.qrCode(),
          barcodeData: qrData));
    } else if (e.elementId == 'barcode' && (barcodeData ?? '').isNotEmpty) {
      result.add(_rebuild(e,
          kind: CanvasElementKind.barcode,
          barcode: Barcode.code128(),
          barcodeData: barcodeData));
    }
  }
  return result;
}

CanvasElement _rebuild(
  CanvasElement e, {
  required CanvasElementKind kind,
  Uint8List? imageBytes,
  bool clipOval = false,
  double cornerRadius = 0,
  Barcode? barcode,
  String? barcodeData,
}) {
  return CanvasElement(
    id: e.id,
    kind: kind,
    position: e.position,
    baseSize: e.baseSize,
    scale: e.scale,
    rotation: e.rotation,
    color: e.color,
    imageBytes: imageBytes,
    clipOval: clipOval,
    cornerRadius: cornerRadius,
    barcode: barcode,
    barcodeData: barcodeData,
    elementId: e.elementId,
  );
}

class CardLayoutSeeder {
  CardLayoutSeeder({
    required this.width,
    required this.height,
    required this.palette,
  });

  final int width;
  final int height;
  final List<Color> palette;

  final List<CanvasElement> elements = [];
  int _idCounter = 0;

  static const double _templateRefWidth = 416;
  static const double _templateRefHeight = 240;
  static const double _templateStickerUnit = 20;

  String _nextId() => 'el_${_idCounter++}';

  Color get _inkColor {
    for (final c in palette) {
      if (c.computeLuminance() <= 0.85) return c;
    }
    return colorBlack;
  }

  void _add(CanvasElement element) => elements.add(element);

  void seedCardLayout(List<LayerSpec> layers) {
    final w = width.toDouble();
    final h = height.toDouble();
    final marginX = w * 0.045;
    final marginY = h * 0.035;
    final contentH = h - 2 * marginY;

    LayerSpec? photo;
    LayerSpec? qr;
    final texts = <LayerSpec>[];
    for (final s in layers) {
      if (s.elementId == 'profileImage' || s.kind == LayerKind.image) {
        photo = s;
      } else if (s.elementId == 'qr' || s.kind == LayerKind.barcode) {
        qr = s;
      } else if (s.text != null) {
        texts.add(s);
      }
    }

    LayerSpec? title;
    for (final s in texts) {
      final f = s.textStyle?.fontSize ?? 0;
      if (title == null || f > (title.textStyle?.fontSize ?? 0)) title = s;
    }
    final details = texts.where((s) => s != title).toList();

    final photoSize = contentH * 0.52;
    final qrSize = contentH * 0.44;
    final gap = contentH * 0.04;
    final leftColX = marginX + photoSize / 2;

    if (photo?.widget != null) {
      _seedWidgetElement(
          photo!, Offset(leftColX, marginY + photoSize / 2), photoSize);
    }
    if (qr?.widget != null) {
      _seedWidgetElement(
        qr!,
        Offset(leftColX, marginY + photoSize + gap + qrSize / 2),
        qrSize,
      );
    }

    final colGapX = w * 0.05;
    final textLeftX = marginX + photoSize + colGapX;
    final textColW = w - textLeftX - marginX;

    final titleH = contentH * 0.18;
    final detailH = contentH * 0.14;
    final lineGap = contentH * 0.045;

    double detailWidth(LayerSpec s) {
      final fs = s.textStyle?.fontSize ?? 24;
      final fw = s.textStyle?.fontWeight ?? FontWeight.normal;
      final m = _measureText(s.text!, fs, fw);
      final aspect = m.height == 0 ? 6.0 : m.width / m.height;
      return detailH * aspect;
    }

    var detailsW = 0.0;
    for (final d in details) {
      final dw = detailWidth(d);
      if (dw > detailsW) detailsW = dw;
    }
    if (detailsW > textColW) detailsW = textColW;
    final detailsLeftX = textLeftX + (textColW - detailsW) / 2;

    final blockH = (title != null ? titleH + lineGap : 0) +
        details.length * (detailH + lineGap);
    var y = marginY + (contentH - blockH) / 2;
    if (title != null) {
      _seedTextElement(title, textLeftX, y, titleH,
          columnWidth: textColW, center: true);
      y += titleH + lineGap;
    }
    for (final d in details) {
      _seedTextElement(d, detailsLeftX, y, detailH, columnWidth: detailsW);
      y += detailH + lineGap;
    }
  }

  void _seedWidgetElement(LayerSpec spec, Offset center, double side) {
    _add(
      CanvasElement(
        id: _nextId(),
        kind: CanvasElementKind.widget,
        position: center,
        baseSize: Size(side, side),
        scale: 1.0,
        child: spec.widget,
        elementId: spec.elementId,
      ),
    );
  }

  void _seedTextElement(
      LayerSpec spec, double leftX, double topY, double targetH,
      {double? columnWidth, bool center = false}) {
    final fontSize = spec.textStyle?.fontSize ?? 24;
    final weight = spec.textStyle?.fontWeight ?? FontWeight.normal;
    final color = _sanitizeColor(spec.textColor ?? spec.textStyle?.color);
    final measured = _measureText(spec.text!, fontSize, weight);
    final aspect =
        measured.height == 0 ? 6.0 : measured.width / measured.height;
    final availW = columnWidth ?? (width - leftX - width * 0.05);
    var boxH = targetH;
    var boxW = boxH * aspect;
    if (boxW > availW) {
      boxW = availW;
      boxH = boxW / aspect;
    }
    final posX = center ? leftX + availW / 2 : leftX + boxW / 2;
    _add(
      CanvasElement(
        id: _nextId(),
        kind: CanvasElementKind.text,
        position: Offset(posX, topY + boxH / 2),
        baseSize: Size(boxW, boxH),
        scale: 1.0,
        color: color,
        text: spec.text,
        fontSize: fontSize,
        fontWeight: weight,
        textAlign: center ? TextAlign.center : TextAlign.left,
        followCanvasTheme: spec.followCanvasTheme,
        elementId: spec.elementId,
      ),
    );
  }

  void seedOffsetLayers(List<LayerSpec> layers) {
    final sx = width / _templateRefWidth;
    final sy = height / _templateRefHeight;
    for (final spec in layers) {
      final position = Offset(
        width / 2 + spec.offset.dx * sx,
        height / 2 + spec.offset.dy * sy,
      );
      if (spec.text != null) {
        final fontSize = spec.textStyle?.fontSize ?? 24;
        final color = _sanitizeColor(spec.textColor ?? spec.textStyle?.color);
        final align = spec.textAlign ?? TextAlign.center;
        final measured = _measureText(spec.text!, fontSize, FontWeight.normal);
        final baseW = measured.width * sy;
        final baseH = measured.height * sy;
        final textPos = align == TextAlign.left
            ? Offset(position.dx + baseW * spec.scale / 2, position.dy)
            : position;
        _add(
          CanvasElement(
            id: _nextId(),
            kind: CanvasElementKind.text,
            position: textPos,
            baseSize: Size(baseW, baseH),
            scale: spec.scale,
            rotation: spec.rotation,
            color: color,
            text: spec.text,
            fontSize: fontSize,
            textAlign: align,
            elementId: spec.elementId,
          ),
        );
      } else if (spec.widget != null) {
        final side = width / _templateStickerUnit * spec.scale;
        _add(
          CanvasElement(
            id: _nextId(),
            kind: CanvasElementKind.widget,
            position: position,
            baseSize: Size(side, side),
            scale: 1.0,
            rotation: spec.rotation,
            child: spec.widget,
            elementId: spec.elementId,
          ),
        );
      }
    }
  }

  Color _sanitizeColor(Color? color) {
    if (color == null) return _inkColor;
    Color best = palette.isNotEmpty ? palette.first : colorBlack;
    double bestDist = double.infinity;
    for (final c in palette) {
      final dr = c.r - color.r;
      final dg = c.g - color.g;
      final db = c.b - color.b;
      final dist = dr * dr + dg * dg + db * db;
      if (dist < bestDist) {
        bestDist = dist;
        best = c;
      }
    }
    return best;
  }

  Size _measureText(String text, double fontSize, FontWeight weight,
      [String? fontFamily]) {
    final base = TextStyle(fontSize: fontSize, fontWeight: weight);
    final style = fontFamily == null
        ? base
        : GoogleFonts.getFont(fontFamily, textStyle: base);
    final painter = TextPainter(
      text: TextSpan(text: text.isEmpty ? ' ' : text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    return Size(painter.width + 8, painter.height + 4);
  }
}
