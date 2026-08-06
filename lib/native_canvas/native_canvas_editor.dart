import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:magicepaperapp/util/image_crop_screen.dart';
import 'package:magicepaperapp/native_canvas/model/canvas_controller.dart';
import 'package:magicepaperapp/native_canvas/model/canvas_document.dart';
import 'package:magicepaperapp/native_canvas/model/canvas_element.dart';
import 'package:magicepaperapp/native_canvas/model/stroke.dart';
import 'package:magicepaperapp/native_canvas/widgets/badge_color_picker.dart';
import 'package:magicepaperapp/native_canvas/widgets/editable_element.dart';
import 'package:magicepaperapp/native_canvas/widgets/stroke_painter.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/native_canvas/widgets/barcode_editor.dart';
import 'package:magicepaperapp/provider/color_palette_provider.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/util/template_util.dart';
import 'package:magicepaperapp/util/image_source_picker.dart';

class NativeCanvasEditor extends StatefulWidget {
  const NativeCanvasEditor({
    super.key,
    required this.width,
    required this.height,
    this.initialLayers,
    this.initialDocument,
    this.returnDocument = false,
  });

  final int width;
  final int height;
  final List<LayerSpec>? initialLayers;

  final CanvasDocument? initialDocument;

  final bool returnDocument;

  @override
  State<NativeCanvasEditor> createState() => _NativeCanvasEditorState();
}

class _NativeCanvasEditorState extends State<NativeCanvasEditor> {
  final GlobalKey _boundaryKey = GlobalKey();
  final GlobalKey _canvasKey = GlobalKey();
  final ImagePicker _picker = ImagePicker();

  late final CanvasController _controller;

  double _displayScale = 1;
  double _displayW = 1;
  double _displayH = 1;
  int _idCounter = 0;

  bool _drawMode = false;
  bool _eraser = false;
  late Color _brushColor;
  double _brushWidth = 4;
  static const List<double> _brushWidths = [2, 4, 8];

  static const List<String?> _fonts = [
    null,
    'Lato',
    'Montserrat',
    'Oswald',
    'Bebas Neue',
    'Lobster',
    'Pacifico',
    'Roboto Mono',
  ];

  @override
  void initState() {
    super.initState();
    final paletteColors = getIt<ColorPaletteProvider>().colors;
    final palette = paletteColors.isNotEmpty
        ? paletteColors
        : const [colorWhite, colorBlack];
    _controller = CanvasController(
      canvasSize: Size(widget.width.toDouble(), widget.height.toDouble()),
      palette: palette,
    );
    _brushColor = _controller.contrastColor(_controller.canvasColor);
    _seedInitialLayers();
  }

  Offset _toCanvasLocal(Offset local) => Offset(
        (local.dx / _displayScale).clamp(0.0, widget.width.toDouble()),
        (local.dy / _displayScale).clamp(0.0, widget.height.toDouble()),
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _nextId() => 'el_${_idCounter++}';

  Color get _inkColor {
    for (final c in _controller.palette) {
      if (c.computeLuminance() <= 0.85) return c;
    }
    return colorBlack;
  }

  Offset get _canvasCenter => Offset(widget.width / 2, widget.height / 2);

  int _spawnCount = 0;

  Offset _nextSpawnPosition() {
    final minSide =
        (widget.width < widget.height ? widget.width : widget.height)
            .toDouble();
    final step = minSide * 0.08;
    final index = _spawnCount++ % 6;
    return _canvasCenter + Offset(step * index, step * index);
  }

  static const double _templateRefWidth = 416;
  static const double _templateRefHeight = 240;
  static const double _templateStickerUnit = 20;

  void _seedInitialLayers() {
    final document = widget.initialDocument;
    if (document != null) {
      _controller.loadDocument(document);
      _resumeIdCounter();
      return;
    }
    final layers = widget.initialLayers;
    if (layers == null) return;
    if (layers.any((s) => s.elementId == 'qrCode')) {
      _seedQrLayout(layers);
    } else if (layers.length == 1 &&
        layers.first.elementId == 'weatherSnapshot' &&
        layers.first.widget != null) {
      _seedFullCanvasElement(layers.first);
    } else if (layers.any((s) => s.elementId == 'qrCaption')) {
      _seedContactCardLayout(layers);
    } else if (layers.any((s) => s.elementId == 'qr')) {
      _seedCardLayout(layers);
    } else {
      _seedOffsetLayers(layers);
    }
    _controller.select(null);
  }

  void _seedQrLayout(List<LayerSpec> layers) {
    final w = widget.width.toDouble();
    final h = widget.height.toDouble();
    final pad = math.min(w, h) * 0.08;
    final cw = w - 2 * pad;
    final ch = h - 2 * pad;
    final landscape = w >= h * 1.15;

    LayerSpec? qr;
    LayerSpec? icon;
    LayerSpec? caption;
    for (final s in layers) {
      switch (s.elementId) {
        case 'qrCode':
          qr = s;
        case 'qrIcon':
          icon = s;
        case 'qrCaption':
          caption = s;
      }
    }

    final hasExtras = icon != null || caption != null;
    if (!hasExtras) {
      if (qr?.widget != null) {
        _seedWidgetElement(qr!, _canvasCenter, math.min(cw, ch));
      }
      return;
    }

    if (landscape) {
      final qrSide = ch;
      final gap = cw * 0.05;
      final rightW = math.max(0.0, cw - qrSide - gap);
      if (qr?.widget != null) {
        _seedWidgetElement(qr!, Offset(pad + qrSide / 2, h / 2), qrSide);
      }
      final rightLeftX = pad + qrSide + gap;
      final rightCenterX = rightLeftX + rightW / 2;
      final iconSide = icon != null ? ch * 0.3 : 0.0;
      final captionH = caption != null ? ch * 0.18 : 0.0;
      final gapV = (icon != null && caption != null) ? ch * 0.06 : 0.0;
      var y = h / 2 - (iconSide + gapV + captionH) / 2;
      if (icon?.widget != null) {
        _seedWidgetElement(
            icon!, Offset(rightCenterX, y + iconSide / 2), iconSide);
        y += iconSide + gapV;
      }
      if (caption != null) {
        _seedTextElement(caption, rightLeftX, y, captionH,
            columnWidth: rightW, center: true);
      }
    } else {
      final iconSide = icon != null ? ch * 0.16 : 0.0;
      final captionH = caption != null ? ch * 0.16 : 0.0;
      final gapV = ch * 0.05;
      var qrSide = ch -
          iconSide -
          captionH -
          (icon != null ? gapV : 0) -
          (caption != null ? gapV : 0);
      if (qrSide > cw) qrSide = cw;
      final totalH = iconSide +
          (icon != null ? gapV : 0) +
          qrSide +
          (caption != null ? gapV : 0) +
          captionH;
      final centerX = w / 2;
      var y = h / 2 - totalH / 2;
      if (icon?.widget != null) {
        _seedWidgetElement(icon!, Offset(centerX, y + iconSide / 2), iconSide);
        y += iconSide + gapV;
      }
      if (qr?.widget != null) {
        _seedWidgetElement(qr!, Offset(centerX, y + qrSide / 2), qrSide);
        y += qrSide + (caption != null ? gapV : 0);
      }
      if (caption != null) {
        _seedTextElement(caption, pad, y, captionH,
            columnWidth: cw, center: true);
      }
    }
  }

  void _seedFullCanvasElement(LayerSpec spec) {
    _controller.addElement(
      CanvasElement(
        id: _nextId(),
        kind: CanvasElementKind.widget,
        position: _canvasCenter,
        baseSize: Size(widget.width.toDouble(), widget.height.toDouble()),
        scale: 1.0,
        child: spec.widget,
        elementId: spec.elementId,
      ),
      record: false,
    );
  }

  void _seedContactCardLayout(List<LayerSpec> layers) {
    final w = widget.width.toDouble();
    final h = widget.height.toDouble();
    final pad = h * 0.06;
    final cw = w - pad * 2;
    final ch = h - pad * 2;

    LayerSpec? name, jobTitle, company, phone, email, link, photo, qr, caption;
    for (final s in layers) {
      switch (s.elementId) {
        case 'fullName':
          name = s;
          break;
        case 'jobTitle':
          jobTitle = s;
          break;
        case 'company':
          company = s;
          break;
        case 'phone':
          phone = s;
          break;
        case 'email':
          email = s;
          break;
        case 'link':
          link = s;
          break;
        case 'profileImage':
          photo = s;
          break;
        case 'qr':
          qr = s;
          break;
        case 'qrCaption':
          caption = s;
          break;
      }
    }

    final hasQr = qr?.widget != null;
    final rightW = hasQr ? math.min(w * 0.32, ch * 0.94) : 0.0;
    final gapX = hasQr ? cw * 0.04 : 0.0;
    final leftW = cw - rightW - gapX;
    final leftX0 = pad;
    final rightX0 = pad + leftW + gapX;

    final hasPhoto = photo?.widget != null;
    final showName = name != null;
    final subEntries = [jobTitle, company].whereType<LayerSpec>().toList();
    final hasSub = subEntries.isNotEmpty;
    final contactEntries = [phone, email, link].whereType<LayerSpec>().toList();

    final nameH = showName ? ch * 0.28 : 0.0;
    final subH = hasSub ? ch * 0.16 : 0.0;
    var identH = nameH + subH;
    if (hasPhoto && identH < ch * 0.4) identH = ch * 0.4;
    final hasIdentity = identH > 0;

    final divTh = math.max(1.0, ch * 0.012);
    final showDivider = hasIdentity && contactEntries.isNotEmpty;
    final divBlockH = showDivider ? ch * 0.1 : 0.0;

    final contactsH = ch - identH - divBlockH;
    final perContactH = contactEntries.isEmpty
        ? 0.0
        : math.min(contactsH / contactEntries.length, ch * 0.32);

    final nameFs = nameH * 0.92;
    final subFs = subH * 0.9;
    final contactFs = perContactH * 0.92;

    final photoD = hasPhoto ? identH * 0.9 : 0.0;
    final photoGap = hasPhoto ? cw * 0.03 : 0.0;
    final textColLeft = leftX0 + (hasPhoto ? photoD + photoGap : 0.0);
    final identTextW = leftW - (hasPhoto ? photoD + photoGap : 0.0);

    // Places a left-anchored text element whose box aspect matches the glyph
    // aspect exactly (using the unpadded measurement), so a width-capped line
    // still hugs the left edge instead of getting centered/indented. Left
    // anchoring also keeps the position stable when the text is later edited.
    void addLeftText(LayerSpec s, double leftX, double centerY, double targetH,
        double availW) {
      final fs = s.textStyle?.fontSize ?? 24;
      final fw = s.textStyle?.fontWeight ?? FontWeight.w500;
      final m = _measureText(s.text!, fs, fw);
      final rawW = math.max(1.0, m.width - 8);
      final rawH = math.max(1.0, m.height - 4);
      final aspect = rawW / rawH;
      var boxH = targetH;
      var boxW = boxH * aspect;
      if (boxW > availW) {
        boxW = availW;
        boxH = boxW / aspect;
      }
      _controller.addElement(
        CanvasElement(
          id: _nextId(),
          kind: CanvasElementKind.text,
          position: Offset(leftX + boxW / 2, centerY),
          baseSize: Size(boxW, boxH),
          scale: 1.0,
          color: _sanitizeColor(s.textColor ?? s.textStyle?.color),
          text: s.text,
          fontSize: fs,
          fontWeight: fw,
          textAlign: TextAlign.left,
          followCanvasTheme: s.followCanvasTheme,
          elementId: s.elementId,
        ),
        record: false,
      );
    }

    double yCursor;
    if (hasIdentity) {
      if (hasPhoto) {
        _seedWidgetElement(
            photo!, Offset(leftX0 + photoD / 2, pad + identH / 2), photoD);
      }
      final blockTop = pad + (identH - (nameH + subH)) / 2;
      if (showName) {
        addLeftText(
            name, textColLeft, blockTop + nameH / 2, nameFs, identTextW);
      }
      if (hasSub) {
        final subTop = blockTop + nameH;
        addLeftText(subEntries.first, textColLeft, subTop + subH / 2, subFs,
            identTextW);
      }
      yCursor = pad + identH;
      if (showDivider) {
        final divTop = yCursor + divBlockH * 0.35;
        _controller.addElement(
          CanvasElement(
            id: _nextId(),
            kind: CanvasElementKind.widget,
            position: Offset(leftX0 + leftW / 2, divTop + divTh / 2),
            baseSize: Size(leftW, divTh),
            scale: 1.0,
            child: SizedBox(
              width: leftW,
              height: divTh,
              child: const ColoredBox(color: colorBlack),
            ),
          ),
          record: false,
        );
        yCursor += divBlockH;
      }
    } else {
      yCursor = pad + (ch - contactEntries.length * perContactH) / 2;
    }

    for (var i = 0; i < contactEntries.length; i++) {
      final centerY = yCursor + i * perContactH + perContactH / 2;
      addLeftText(contactEntries[i], leftX0, centerY, contactFs, leftW);
    }

    if (hasQr) {
      final captionH = ch * 0.1;
      final qrSide = math.min(rightW, ch - captionH - ch * 0.04);
      final blockTop = pad + (ch - (qrSide + ch * 0.04 + captionH)) / 2;
      _seedWidgetElement(
          qr!, Offset(rightX0 + rightW / 2, blockTop + qrSide / 2), qrSide);
      if (caption != null) {
        final capFs = captionH * 0.7;
        final capTop = blockTop + qrSide + ch * 0.04 + (captionH - capFs) / 2;
        _seedTextElement(caption, rightX0, capTop, capFs,
            columnWidth: rightW, center: true);
      }
    }
  }

  void _resumeIdCounter() {
    var maxId = -1;
    for (final e in _controller.elements) {
      final match = RegExp(r'^el_(\d+)$').firstMatch(e.id);
      if (match != null) {
        final n = int.parse(match.group(1)!);
        if (n > maxId) maxId = n;
      }
    }
    _idCounter = maxId + 1;
  }

  void _seedCardLayout(List<LayerSpec> layers) {
    final w = widget.width.toDouble();
    final h = widget.height.toDouble();
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
    _controller.addElement(
      CanvasElement(
        id: _nextId(),
        kind: CanvasElementKind.widget,
        position: center,
        baseSize: Size(side, side),
        scale: 1.0,
        child: spec.widget,
        elementId: spec.elementId,
      ),
      record: false,
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
    final availW = columnWidth ?? (widget.width - leftX - widget.width * 0.05);
    var boxH = targetH;
    var boxW = boxH * aspect;
    if (boxW > availW) {
      boxW = availW;
      boxH = boxW / aspect;
    }
    final posX = center ? leftX + availW / 2 : leftX + boxW / 2;
    _controller.addElement(
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
      record: false,
    );
  }

  void _seedOffsetLayers(List<LayerSpec> layers) {
    final sx = widget.width / _templateRefWidth;
    final sy = widget.height / _templateRefHeight;
    for (final spec in layers) {
      final position = Offset(
        widget.width / 2 + spec.offset.dx * sx,
        widget.height / 2 + spec.offset.dy * sy,
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
        _controller.addElement(
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
          record: false,
        );
      } else if (spec.widget != null) {
        final side = widget.width / _templateStickerUnit * spec.scale;
        _controller.addElement(
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
          record: false,
        );
      }
    }
  }

  Color _sanitizeColor(Color? color) {
    if (color == null) return _inkColor;
    final palette = _controller.palette;
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

  Future<void> _addText() async {
    final result = await _showTextSheet();
    if (result == null) return;
    _controller.addElement(
      CanvasElement(
        id: _nextId(),
        kind: CanvasElementKind.text,
        position: _nextSpawnPosition(),
        baseSize: _measureText(
            result.text, result.fontSize, FontWeight.normal, result.fontFamily),
        color: result.color,
        text: result.text,
        fontSize: result.fontSize,
        fontFamily: result.fontFamily,
        followCanvasTheme: !result.manualColor,
      ),
    );
  }

  Future<void> _editText(CanvasElement element) async {
    final result = await _showTextSheet(existing: element);
    if (result == null) return;
    final measured = _measureText(
        result.text, result.fontSize, FontWeight.normal, result.fontFamily);
    final aspect =
        measured.height == 0 ? 6.0 : measured.width / measured.height;
    final oldFont = element.fontSize;
    final targetH = oldFont > 0
        ? element.baseSize.height * (result.fontSize / oldFont)
        : measured.height;
    final newWidth = targetH * aspect;
    final dw = newWidth - element.baseSize.width;
    final align = element.textAlign;
    double dx = 0;
    if (align == TextAlign.left || align == TextAlign.start) {
      dx = dw * element.scale / 2;
    } else if (align == TextAlign.right || align == TextAlign.end) {
      dx = -dw * element.scale / 2;
    }
    _controller.beginChange();
    _controller.updateElement(
      element.copyWith(
        text: result.text,
        fontSize: result.fontSize,
        color: result.color,
        fontFamily: result.fontFamily,
        followCanvasTheme: !result.manualColor,
        baseSize: Size(newWidth, targetH),
        position: Offset(element.position.dx + dx, element.position.dy),
      ),
    );
  }

  static const double _maxImportDimension = 2048;

  Future<void> _addImage() async {
    final source = await chooseImageSource(context);
    if (source == null) return;
    if (source == ImageSource.gallery) {
      final picked = await _picker.pickMultiImage(
        maxWidth: _maxImportDimension,
        maxHeight: _maxImportDimension,
      );
      if (picked.isEmpty) return;
      for (final file in picked) {
        _placeImage(await file.readAsBytes());
      }
    } else {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: _maxImportDimension,
        maxHeight: _maxImportDimension,
      );
      if (picked == null) return;
      _placeImage(await picked.readAsBytes());
    }
  }

  void _placeImage(Uint8List bytes) {
    final decoded = img.decodeImage(bytes);
    final aspect = (decoded == null || decoded.height == 0)
        ? 1.0
        : decoded.width / decoded.height;
    final maxW = widget.width * 0.6;
    final maxH = widget.height * 0.6;
    double w = maxW;
    double h = w / aspect;
    if (h > maxH) {
      h = maxH;
      w = h * aspect;
    }
    _controller.addElement(
      CanvasElement(
        id: _nextId(),
        kind: CanvasElementKind.image,
        position: _nextSpawnPosition(),
        baseSize: Size(w, h),
        imageBytes: bytes,
      ),
    );
  }

  Future<void> _replaceImage(CanvasElement element) async {
    final source = await chooseImageSource(context);
    if (source == null) return;
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: _maxImportDimension,
      maxHeight: _maxImportDimension,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    final keepFrame = element.clipOval || element.cornerRadius > 0;
    final decoded = img.decodeImage(bytes);
    final aspect = (decoded == null || decoded.height == 0)
        ? 1.0
        : decoded.width / decoded.height;
    final w = element.baseSize.width;
    _controller.beginChange();
    _controller.updateElement(
      element.copyWith(
        imageBytes: bytes,
        baseSize: keepFrame ? element.baseSize : Size(w, w / aspect),
      ),
    );
  }

  Future<void> _cropImage(CanvasElement element) async {
    final bytes = element.imageBytes;
    if (bytes == null) return;
    final cropped = await showImageCropScreen(context, bytes);
    if (cropped == null || !mounted) return;
    final keepFrame = element.clipOval || element.cornerRadius > 0;
    final decoded = img.decodeImage(cropped);
    final aspect = (decoded == null || decoded.height == 0)
        ? 1.0
        : decoded.width / decoded.height;
    final w = element.baseSize.width;
    _controller.beginChange();
    _controller.updateElement(
      element.copyWith(
        imageBytes: cropped,
        baseSize: keepFrame ? element.baseSize : Size(w, w / aspect),
      ),
    );
  }

  static const Set<String> _twoDBarcodeNames = {
    'QR-Code',
    'Aztec',
    'Data Matrix',
    'PDF417',
  };

  Future<void> _addBarcode() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) => BarcodeEditor(
        onBarcodeConfirmed: (barcode, data) {
          _placeBarcode(barcode, data);
          Navigator.pop(sheetContext);
        },
      ),
    );
  }

  Future<void> _editBarcode(CanvasElement element) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) => BarcodeEditor(
        initialBarcode: element.barcode,
        initialData: element.barcodeData,
        onBarcodeConfirmed: (barcode, data) {
          _controller.beginChange();
          _controller.updateElement(
            element.copyWith(barcode: barcode, barcodeData: data),
          );
          Navigator.pop(sheetContext);
        },
      ),
    );
  }

  void _placeBarcode(Barcode barcode, String data) {
    final is2D = _twoDBarcodeNames.contains(barcode.name);
    final minSide =
        (widget.width < widget.height ? widget.width : widget.height)
            .toDouble();
    final baseSize = is2D
        ? Size(minSide * 0.5, minSide * 0.5)
        : Size(widget.width * 0.6, widget.width * 0.6 / 3);
    _controller.addElement(
      CanvasElement(
        id: _nextId(),
        kind: CanvasElementKind.barcode,
        position: _nextSpawnPosition(),
        baseSize: baseSize,
        barcode: barcode,
        barcodeData: data,
      ),
    );
  }

  Future<void> _onDone() async {
    if (_controller.isEmpty) {
      _snack('Add something to the canvas before saving.');
      return;
    }
    _controller.select(null);
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    try {
      final boundary = _boundaryKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      final longSide =
          (widget.width > widget.height ? widget.width : widget.height)
              .toDouble();
      final supersample = (2048 / longSide).clamp(2.0, 4.0);
      final image =
          await boundary.toImage(pixelRatio: supersample / _displayScale);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      if (!mounted || byteData == null) return;
      final png = byteData.buffer.asUint8List();
      if (widget.returnDocument) {
        Navigator.pop(context, CanvasEditorResult(png, _buildDocument()));
      } else {
        Navigator.pop(context, png);
      }
    } catch (e) {
      if (mounted) _snack('Could not export the canvas: $e');
    }
  }

  CanvasDocument _buildDocument() {
    return CanvasDocument(
      width: widget.width,
      height: widget.height,
      canvasColor: _controller.canvasColor,
      elements: _controller.elements,
      strokes: _controller.strokes,
    );
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFEDEDED),
          appBar: AppBar(
            backgroundColor: colorAccent,
            foregroundColor: colorWhite,
            title: Text(appLocalizations.editor),
            actions: [
              IconButton(
                icon: const Icon(Icons.undo),
                onPressed: _controller.canUndo ? _controller.undo : null,
              ),
              IconButton(
                icon: const Icon(Icons.redo),
                onPressed: _controller.canRedo ? _controller.redo : null,
              ),
              IconButton(icon: const Icon(Icons.check), onPressed: _onDone),
            ],
          ),
          body: _buildCanvasArea(),
          bottomNavigationBar: _buildBottomBar(),
        );
      },
    );
  }

  Widget _buildCanvasArea() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const padding = 20.0;
        final availW = constraints.maxWidth - padding * 2;
        final availH = constraints.maxHeight - padding * 2;
        _displayScale = (availW / widget.width) < (availH / widget.height)
            ? availW / widget.width
            : availH / widget.height;
        if (_displayScale <= 0 || !_displayScale.isFinite) _displayScale = 1;
        _displayW = widget.width * _displayScale;
        _displayH = widget.height * _displayScale;

        return Center(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: grey400, width: 1),
              boxShadow: const [
                BoxShadow(color: colorBlack26, blurRadius: 10),
              ],
            ),
            child: RepaintBoundary(
              key: _boundaryKey,
              child: SizedBox(
                key: _canvasKey,
                width: _displayW,
                height: _displayH,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _controller.select(null),
                        child: ColoredBox(color: _controller.canvasColor),
                      ),
                    ),
                    Positioned.fill(
                      child: IgnorePointer(
                        child: CustomPaint(
                          painter: StrokePainter(
                            strokes: _controller.strokes,
                            displayScale: _displayScale,
                          ),
                        ),
                      ),
                    ),
                    for (final element in _controller.elements)
                      EditableElement(
                        key: ValueKey(element.id),
                        element: element,
                        displayScale: _displayScale,
                        selected: _controller.selectedId == element.id,
                        controller: _controller,
                        canvasKey: _canvasKey,
                        onRequestEdit: element.elementId != null &&
                                !widget.returnDocument
                            ? () => Navigator.pop(context, element.elementId)
                            : switch (element.kind) {
                                CanvasElementKind.text => () =>
                                    _editText(element),
                                CanvasElementKind.image => () =>
                                    _replaceImage(element),
                                CanvasElementKind.barcode => () =>
                                    _editBarcode(element),
                                CanvasElementKind.widget => null,
                              },
                        onCrop: element.kind == CanvasElementKind.image
                            ? () => _cropImage(element)
                            : null,
                      ),
                    if (_drawMode)
                      Positioned.fill(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onPanStart: (d) {
                            final p = _toCanvasLocal(d.localPosition);
                            if (_eraser) {
                              _controller.beginChange();
                              _controller.eraseAt(p, _brushWidth + 6);
                            } else {
                              _controller.startStroke(
                                Stroke(
                                  points: [p],
                                  color: _brushColor,
                                  width: _brushWidth,
                                ),
                              );
                            }
                          },
                          onPanUpdate: (d) {
                            final p = _toCanvasLocal(d.localPosition);
                            if (_eraser) {
                              _controller.eraseAt(p, _brushWidth + 6);
                            } else {
                              _controller.extendStroke(p);
                            }
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomBar() {
    final appLocalizations = AppLocalizations.of(context)!;
    if (_drawMode) return _buildDrawBar();
    return BottomAppBar(
      color: colorWhite,
      elevation: 8,
      padding: EdgeInsets.zero,
      height: 72,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _BarButton(
            label: appLocalizations.canvas,
            onTap: _controller.cycleCanvasColor,
            iconWidget: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: _controller.canvasColor,
                border: Border.all(color: colorBlack38, width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          _BarButton(
              icon: Icons.image_outlined,
              label: appLocalizations.image,
              onTap: _addImage),
          _BarButton(
              icon: Icons.text_fields,
              label: AppLocalizations.of(context)!.text,
              onTap: _addText),
          _BarButton(
              icon: Icons.qr_code,
              label: appLocalizations.barcode,
              onTap: _addBarcode),
          _BarButton(
            icon: Icons.brush_outlined,
            label: appLocalizations.draw,
            onTap: () => setState(() {
              _controller.select(null);
              _drawMode = true;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawBar() {
    final appLocalizations = AppLocalizations.of(context)!;
    return Material(
      color: colorWhite,
      elevation: 8,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  _modeButton(
                    icon: Icon(Icons.brush,
                        size: 18, color: !_eraser ? colorWhite : colorBlack54),
                    label: appLocalizations.brush,
                    active: !_eraser,
                    onTap: () => setState(() => _eraser = false),
                  ),
                  const SizedBox(width: 8),
                  _modeButton(
                    icon: SizedBox(
                      width: 18,
                      height: 18,
                      child: CustomPaint(
                        painter:
                            _EraserPainter(_eraser ? colorWhite : colorBlack54),
                      ),
                    ),
                    label: appLocalizations.eraser,
                    active: _eraser,
                    onTap: () => setState(() => _eraser = true),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => setState(() => _drawMode = false),
                    icon: const Icon(Icons.check),
                    label: Text(appLocalizations.done),
                    style: TextButton.styleFrom(foregroundColor: colorAccent),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  SizedBox(
                    width: 56,
                    child: Text(
                      appLocalizations.size,
                      style: TextStyle(color: grey600, fontSize: 13),
                    ),
                  ),
                  for (final w in _brushWidths)
                    GestureDetector(
                      onTap: () => setState(() => _brushWidth = w),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: w == _brushWidth
                              ? colorAccent.withValues(alpha: 0.15)
                              : Colors.transparent,
                          border: Border.all(
                            color: w == _brushWidth ? colorAccent : grey300,
                          ),
                        ),
                        child: Container(
                          width: w + 8,
                          height: w + 8,
                          decoration: const BoxDecoration(
                            color: colorBlack87,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              if (!_eraser) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    SizedBox(
                      width: 56,
                      child: Text(
                        appLocalizations.colour,
                        style: TextStyle(color: grey600, fontSize: 13),
                      ),
                    ),
                    for (final c in _controller.palette)
                      GestureDetector(
                        onTap: () => setState(() => _brushColor = c),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: c.toARGB32() == _brushColor.toARGB32()
                                  ? colorAccent
                                  : colorBlack38,
                              width: c.toARGB32() == _brushColor.toARGB32()
                                  ? 3
                                  : 1,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _modeButton({
    required Widget icon,
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? colorAccent : grey200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: active ? colorWhite : colorBlack54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<_TextResult?> _showTextSheet({CanvasElement? existing}) {
    final appLocalizations = AppLocalizations.of(context)!;
    final textCtrl = TextEditingController(text: existing?.text ?? '');
    double fontSize = existing?.fontSize ?? 24;
    Color color =
        existing?.color ?? _controller.contrastColor(_controller.canvasColor);
    bool manualColor = existing != null ? !existing.followCanvasTheme : false;
    String? fontFamily = existing?.fontFamily;
    return showModalBottomSheet<_TextResult>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: StatefulBuilder(
            builder: (context, setSheet) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: textCtrl,
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (_) => setSheet(() {}),
                    style: fontFamily == null
                        ? null
                        : GoogleFonts.getFont(fontFamily!),
                    decoration: InputDecoration(
                      labelText: appLocalizations.text,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 72,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _controller.canvasColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: grey300),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          textCtrl.text.isEmpty
                              ? appLocalizations.preview
                              : textCtrl.text,
                          style: fontFamily == null
                              ? TextStyle(fontSize: fontSize, color: color)
                              : GoogleFonts.getFont(
                                  fontFamily!,
                                  textStyle: TextStyle(
                                      fontSize: fontSize, color: color),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(appLocalizations.sizeWithValue(fontSize.round())),
                  Slider(
                    min: 8,
                    max: 120,
                    value: fontSize,
                    onChanged: (v) => setSheet(() => fontSize = v),
                  ),
                  const SizedBox(height: 4),
                  Text(appLocalizations.font),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 44,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (final f in _fonts)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              selected: f == fontFamily,
                              label: Text(
                                f ?? appLocalizations.defaultFont,
                                style:
                                    f == null ? null : GoogleFonts.getFont(f),
                              ),
                              onSelected: (_) => setSheet(() => fontFamily = f),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(appLocalizations.colour),
                  const SizedBox(height: 8),
                  BadgeColorPicker(
                    colors: _controller.palette,
                    selected: color,
                    onSelected: (c) => setSheet(() {
                      color = c;
                      manualColor = true;
                    }),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        final text = textCtrl.text.trim();
                        if (text.isEmpty) {
                          Navigator.pop(context);
                          return;
                        }
                        Navigator.pop(
                          context,
                          _TextResult(
                              text, fontSize, color, manualColor, fontFamily),
                        );
                      },
                      child: Text(appLocalizations.done),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _TextResult {
  final String text;
  final double fontSize;
  final Color color;
  final bool manualColor;
  final String? fontFamily;
  const _TextResult(
      this.text, this.fontSize, this.color, this.manualColor, this.fontFamily);
}

class _BarButton extends StatelessWidget {
  const _BarButton({
    this.icon,
    this.iconWidget,
    required this.label,
    required this.onTap,
  }) : assert(icon != null || iconWidget != null);

  final IconData? icon;
  final Widget? iconWidget;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 64),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget ?? Icon(icon, size: 22, color: colorAccent),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: colorBlack87),
            ),
          ],
        ),
      ),
    );
  }
}

class _EraserPainter extends CustomPainter {
  final Color color;
  _EraserPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeJoin = StrokeJoin.round;
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(-0.6);
    final body = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset.zero, width: 16, height: 8),
      const Radius.circular(2),
    );
    canvas.drawRRect(body, paint);
    canvas.drawLine(const Offset(-2, -4), const Offset(-2, 4), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _EraserPainter old) => old.color != color;
}
