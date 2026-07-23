import 'dart:typed_data';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
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
          kind: CanvasElementKind.image, imageBytes: photoBytes));
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
    final mx = w * 0.05;
    final my = h * 0.06;
    final contentTop = my;
    final contentBottom = h - my;
    final contentH = contentBottom - contentTop;
    final fullW = w - 2 * mx;

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
    var titleFont = -1.0;
    for (final s in texts) {
      final f = s.textStyle?.fontSize ?? 0;
      if (f > titleFont) {
        titleFont = f;
        title = s;
      }
    }
    final details = texts.where((s) => s != title).toList();

    var bodyTop = contentTop;
    if (title != null) {
      final titleH = (contentH * 0.22).clamp(0.0, h * 0.30);
      _seedTextElement(title, mx, contentTop, titleH,
          columnWidth: fullW, center: true);
      bodyTop = contentTop + titleH + h * 0.06;
    }
    final bodyH = contentBottom - bodyTop;

    final hasPhoto = photo?.widget != null;
    final hasQr = qr?.widget != null;
    var leftColW = 0.0;
    if (hasPhoto || hasQr) {
      leftColW = (w * 0.26).clamp(w * 0.20, w * 0.32);
      final leftCenterX = mx + leftColW / 2;
      if (hasPhoto && hasQr) {
        final photoSide =
            leftColW < bodyH * 0.55 ? leftColW : bodyH * 0.55;
        _seedWidgetElement(
            photo!, Offset(leftCenterX, bodyTop + photoSide / 2), photoSide);
        final qrSide = leftColW < bodyH * 0.42 ? leftColW : bodyH * 0.42;
        _seedWidgetElement(
            qr!, Offset(leftCenterX, contentBottom - qrSide / 2), qrSide);
      } else {
        final only = hasPhoto ? photo! : qr!;
        final side = leftColW < bodyH * 0.9 ? leftColW : bodyH * 0.9;
        _seedWidgetElement(
            only, Offset(leftCenterX, bodyTop + bodyH / 2), side);
      }
    }

    if (details.isEmpty) return;
    final detailX = leftColW > 0 ? mx + leftColW + w * 0.05 : mx;
    final detailW = (w - mx) - detailX;
    final n = details.length;
    final gap = bodyH * 0.05;
    var lineH = (bodyH - (n - 1) * gap) / n;
    final maxLineH = h * 0.16;
    if (lineH > maxLineH) lineH = maxLineH;
    final block = n * lineH + (n - 1) * gap;
    var y = bodyTop + (bodyH - block) / 2;
    for (final d in details) {
      _seedTextElement(d, detailX, y, lineH,
          columnWidth: detailW, center: false);
      y += lineH + gap;
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
