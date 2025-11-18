import 'dart:typed_data' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/provider/color_palette_provider.dart';

class TextFitEditor extends StatefulWidget {
  final int width;
  final int height;
  const TextFitEditor({super.key, required this.width, required this.height});
  @override
  State<TextFitEditor> createState() => TextFitEditorState();
}

class TextFitEditorState extends State<TextFitEditor> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey _repaintKey = GlobalKey();
  Color _textColor = Colors.black;
  Color _backgroundColor = Colors.white;
  TextAlign _align = TextAlign.center;
  late final List<Color> _availableColors;

  @override
  void initState() {
    super.initState();
    _availableColors = getIt<ColorPaletteProvider>().colors;
    _backgroundColor = _availableColors.contains(Colors.white)
        ? Colors.white
        : _availableColors.first;
    _textColor = _availableColors.firstWhere(
      (c) => c != _backgroundColor,
      orElse: () => Colors.black,
    );
  }

  Size _calculateCanvas(Size screenSize) {
    final double targetAspect = widget.width / widget.height;
    final double availableWidth = screenSize.width - 32;
    final double availableHeight =
        screenSize.height - kToolbarHeight - kBottomNavigationBarHeight - 140;
    double w = availableWidth;
    double h = w / targetAspect;
    if (h > availableHeight) {
      h = availableHeight;
      w = h * targetAspect;
    }
    return Size(w, h);
  }

  double _fitFontSize(String text, double maxW, double maxH, TextAlign align) {
    if (text.isEmpty) return maxH * 0.6;
    double low = 8;
    double high = maxH;
    double best = low;
    while (high - low > 0.5) {
      final mid = (low + high) / 2;
      final painter = TextPainter(
        text: TextSpan(
            style: TextStyle(fontSize: mid, color: _textColor), text: text),
        textDirection: TextDirection.ltr,
        maxLines: null,
        textAlign: align,
      );
      painter.layout(maxWidth: maxW);
      if (painter.height <= maxH && painter.width <= maxW) {
        best = mid;
        low = mid;
      } else {
        high = mid;
      }
    }
    return best;
  }

  Future<Uint8List?> _export(Size canvasSize) async {
    final boundary = _repaintKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final pixelRatio = widget.width / canvasSize.width;
    final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
    final ui.ByteData? data =
        await image.toByteData(format: ui.ImageByteFormat.png);
    return data?.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    final Size canvasSize = _calculateCanvas(MediaQuery.sizeOf(context));
    final double padding = 16;
    final double fontSize = _fitFontSize(
      _controller.text,
      canvasSize.width - padding * 2,
      canvasSize.height - padding * 2,
      _align,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0.0,
        backgroundColor: colorAccent,
        elevation: 0,
        title: const Text('Text Editor',
            style: TextStyle(
                color: Colors.white,
                fontSize: 13.8,
                fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () async {
              final bytes = await _export(canvasSize);
              if (!mounted) return;
              Navigator.pop(context, bytes);
            },
            icon: const Icon(Icons.check, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: colorBlack.withValues(alpha: .06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Enter text',
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Text',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _availableColors.map((c) {
                            final bool selected = c == _textColor;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: InkWell(
                                onTap: () => setState(() => _textColor = c),
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: c,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: selected
                                          ? colorAccent
                                          : Colors.grey.shade300,
                                      width: selected ? 2 : 1,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ToggleButtons(
                      isSelected: [
                        _align == TextAlign.left,
                        _align == TextAlign.center,
                        _align == TextAlign.right,
                      ],
                      borderRadius: BorderRadius.circular(8),
                      selectedColor: Colors.white,
                      color: Colors.black54,
                      fillColor: colorAccent,
                      constraints:
                          const BoxConstraints(minWidth: 36, minHeight: 32),
                      onPressed: (i) {
                        setState(() {
                          _align = i == 0
                              ? TextAlign.left
                              : i == 1
                                  ? TextAlign.center
                                  : TextAlign.right;
                        });
                      },
                      children: const [
                        Icon(Icons.format_align_left, size: 18),
                        Icon(Icons.format_align_center, size: 18),
                        Icon(Icons.format_align_right, size: 18),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Background',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _availableColors.map((c) {
                            final bool selected = c == _backgroundColor;
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _backgroundColor = c;
                                    if (_textColor == _backgroundColor) {
                                      _textColor = _availableColors.firstWhere(
                                        (col) => col != _backgroundColor,
                                        orElse: () => _textColor,
                                      );
                                    }
                                  });
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: c,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: selected
                                          ? colorAccent
                                          : Colors.grey.shade300,
                                      width: selected ? 2 : 1,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${_controller.text.length}',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade600, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: colorBlack.withValues(alpha: .08),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: RepaintBoundary(
                  key: _repaintKey,
                  child: Container(
                    width: canvasSize.width,
                    height: canvasSize.height,
                    color: _backgroundColor,
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Text(
                        _controller.text,
                        textAlign: _align,
                        softWrap: true,
                        style: TextStyle(
                          color: _textColor,
                          fontSize: fontSize,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
