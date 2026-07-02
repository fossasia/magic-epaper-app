import 'dart:io';
import 'dart:ui' as ui;

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:magicepaperapp/native_canvas/model/canvas_controller.dart';
import 'package:magicepaperapp/native_canvas/model/canvas_element.dart';
import 'package:magicepaperapp/native_canvas/model/stroke.dart';
import 'package:magicepaperapp/native_canvas/widgets/badge_color_picker.dart';
import 'package:magicepaperapp/native_canvas/widgets/editable_element.dart';
import 'package:magicepaperapp/native_canvas/widgets/stroke_painter.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/pro_image_editor/features/barcode_editor.dart';
import 'package:magicepaperapp/provider/color_palette_provider.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/util/template_util.dart';
import 'package:magicepaperapp/util/image_source_picker.dart';

class NativeCanvasEditor extends StatefulWidget {
  const NativeCanvasEditor({
    super.key,
    required this.width,
    required this.height,
    this.initialLayers,
  });

  final int width;
  final int height;
  final List<LayerSpec>? initialLayers;

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
        : const [Colors.white, Colors.black];
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
    return Colors.black;
  }

  Offset get _canvasCenter =>
      Offset(widget.width / 2, widget.height / 2);

  int _spawnCount = 0;

  Offset _nextSpawnPosition() {
    final minSide =
        (widget.width < widget.height ? widget.width : widget.height).toDouble();
    final step = minSide * 0.08;
    final index = _spawnCount++ % 6;
    return _canvasCenter + Offset(step * index, step * index);
  }


  void _seedInitialLayers() {
    final layers = widget.initialLayers;
    if (layers == null) return;
    for (final spec in layers) {
      final position = _canvasCenter + spec.offset;
      if (spec.text != null) {
        final fontSize = spec.textStyle?.fontSize ?? 24;
        final color = _sanitizeColor(spec.textColor ?? spec.textStyle?.color);
        _controller.addElement(
          CanvasElement(
            id: _nextId(),
            kind: CanvasElementKind.text,
            position: position,
            baseSize: _measureText(spec.text!, fontSize, FontWeight.normal),
            scale: spec.scale,
            rotation: spec.rotation,
            color: color,
            text: spec.text,
            fontSize: fontSize,
            textAlign: spec.textAlign ?? TextAlign.center,
            elementId: spec.elementId,
          ),
          record: false,
        );
      } else if (spec.widget != null) {
        final side = (widget.width < widget.height ? widget.width : widget.height) * 0.35;
        _controller.addElement(
          CanvasElement(
            id: _nextId(),
            kind: CanvasElementKind.widget,
            position: position,
            baseSize: Size(side, side),
            scale: spec.scale,
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
    Color best = palette.isNotEmpty ? palette.first : Colors.black;
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
    _controller.beginChange();
    _controller.updateElement(
      element.copyWith(
        text: result.text,
        fontSize: result.fontSize,
        color: result.color,
        fontFamily: result.fontFamily,
        followCanvasTheme: !result.manualColor,
        baseSize: _measureText(
            result.text, result.fontSize, FontWeight.normal, result.fontFamily),
      ),
    );
  }

  Future<void> _addImage() async {
    final source = await chooseImageSource(context);
    if (source == null) return;
    final picked = await _picker.pickImage(source: source);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    final decoded = img.decodeImage(bytes);
    final aspect =
        (decoded == null || decoded.height == 0) ? 1.0 : decoded.width / decoded.height;
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

  Future<void> _cropImage(CanvasElement element) async {
    final bytes = element.imageBytes;
    if (bytes == null) return;
    final dir = await getTemporaryDirectory();
    final file = File(
      '${dir.path}/mep_crop_${DateTime.now().microsecondsSinceEpoch}.png',
    );
    await file.writeAsBytes(bytes);
    final cropped = await ImageCropper().cropImage(
      sourcePath: file.path,
      compressFormat: ImageCompressFormat.png,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop',
          toolbarColor: colorAccent,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: colorAccent,
          backgroundColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          hideBottomControls: false,
        ),
        IOSUiSettings(
          title: 'Crop',
          aspectRatioLockEnabled: false,
          resetAspectRatioEnabled: true,
        ),
      ],
    );
    if (cropped == null) return;
    final newBytes = await File(cropped.path).readAsBytes();
    final decoded = img.decodeImage(newBytes);
    final aspect = (decoded == null || decoded.height == 0)
        ? 1.0
        : decoded.width / decoded.height;
    final w = element.baseSize.width;
    _controller.beginChange();
    _controller.updateElement(
      element.copyWith(imageBytes: newBytes, baseSize: Size(w, w / aspect)),
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
      backgroundColor: Colors.white,
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

  void _placeBarcode(Barcode barcode, String data) {
    final is2D = _twoDBarcodeNames.contains(barcode.name);
    final minSide =
        (widget.width < widget.height ? widget.width : widget.height).toDouble();
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
      final boundary =
          _boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 1 / _displayScale);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      if (!mounted || byteData == null) return;
      Navigator.pop(context, byteData.buffer.asUint8List());
    } catch (e) {
      if (mounted) _snack('Could not export the canvas: $e');
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFEDEDED),
          appBar: AppBar(
            backgroundColor: colorAccent,
            foregroundColor: Colors.white,
            title: const Text('Editor'),
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
              border: Border.all(color: Colors.grey.shade400, width: 1),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 10),
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
                        onRequestEdit: element.kind == CanvasElementKind.text
                            ? () => _editText(element)
                            : null,
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
    if (_drawMode) return _buildDrawBar();
    return BottomAppBar(
      color: Colors.white,
      elevation: 8,
      padding: EdgeInsets.zero,
      height: 72,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _BarButton(
            label: 'Canvas',
            onTap: _controller.cycleCanvasColor,
            iconWidget: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: _controller.canvasColor,
                border: Border.all(color: Colors.black38, width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          _BarButton(
              icon: Icons.image_outlined, label: 'Image', onTap: _addImage),
          _BarButton(icon: Icons.text_fields, label: 'Text', onTap: _addText),
          _BarButton(icon: Icons.qr_code, label: 'Barcode', onTap: _addBarcode),
          _BarButton(
            icon: Icons.brush_outlined,
            label: 'Draw',
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
    return Material(
      color: Colors.white,
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
                        size: 18,
                        color: !_eraser ? Colors.white : Colors.black54),
                    label: 'Brush',
                    active: !_eraser,
                    onTap: () => setState(() => _eraser = false),
                  ),
                  const SizedBox(width: 8),
                  _modeButton(
                    icon: SizedBox(
                      width: 18,
                      height: 18,
                      child: CustomPaint(
                        painter: _EraserPainter(
                            _eraser ? Colors.white : Colors.black54),
                      ),
                    ),
                    label: 'Eraser',
                    active: _eraser,
                    onTap: () => setState(() => _eraser = true),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => setState(() => _drawMode = false),
                    icon: const Icon(Icons.check),
                    label: const Text('Done'),
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
                      'Size',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
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
                            color: w == _brushWidth
                                ? colorAccent
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Container(
                          width: w + 8,
                          height: w + 8,
                          decoration: const BoxDecoration(
                            color: Colors.black87,
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
                        'Colour',
                        style:
                            TextStyle(color: Colors.grey.shade600, fontSize: 13),
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
                                  : Colors.black38,
                              width:
                                  c.toARGB32() == _brushColor.toARGB32() ? 3 : 1,
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
          color: active ? colorAccent : Colors.grey.shade200,
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
                color: active ? Colors.white : Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<_TextResult?> _showTextSheet({CanvasElement? existing}) {
    final textCtrl = TextEditingController(text: existing?.text ?? '');
    double fontSize = existing?.fontSize ?? 24;
    Color color = existing?.color ??
        _controller.contrastColor(_controller.canvasColor);
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
                    decoration: const InputDecoration(
                      labelText: 'Text',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Size: ${fontSize.round()}'),
                  Slider(
                    min: 8,
                    max: 120,
                    value: fontSize,
                    onChanged: (v) => setSheet(() => fontSize = v),
                  ),
                  const SizedBox(height: 4),
                  const Text('Font'),
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
                                f ?? 'Default',
                                style: f == null
                                    ? null
                                    : GoogleFonts.getFont(f),
                              ),
                              onSelected: (_) => setSheet(() => fontFamily = f),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Colour'),
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
                      child: const Text('Done'),
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
              style: const TextStyle(fontSize: 11, color: Colors.black87),
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
