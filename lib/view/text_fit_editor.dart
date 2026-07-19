import 'dart:typed_data' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
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
  Color _textColor = colorBlack;
  Color _backgroundColor = colorWhite;
  TextAlign _align = TextAlign.center;
  late final List<Color> _availableColors;
  String? _errorText;

  bool get _isTextEmpty => _controller.text.trim().isEmpty;

  @override
  void initState() {
    super.initState();
    _availableColors = getIt<ColorPaletteProvider>().colors;
    _backgroundColor = _availableColors.contains(colorWhite)
        ? colorWhite
        : _availableColors.first;
    _textColor = _availableColors.firstWhere(
      (c) => c != _backgroundColor,
      orElse: () => colorBlack,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  Future<void> _handleConfirm(
      Size canvasSize, AppLocalizations appLocalizations) async {
    if (_isTextEmpty) {
      setState(() => _errorText = appLocalizations.emptyTextError);
      final messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: Text(appLocalizations.emptyTextWarning),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final bytes = await _export(canvasSize);
    if (!mounted) return;
    Navigator.pop(context, bytes);
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
    final appLocalizations = AppLocalizations.of(context)!;
    final Size canvasSize = _calculateCanvas(MediaQuery.sizeOf(context));
    final double padding = Dimens.spacingL;
    final double fontSize = _fitFontSize(
      _controller.text,
      canvasSize.width - padding * 2,
      canvasSize.height - padding * 2,
      _align,
    );
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: colorWhite),
        titleSpacing: 0.0,
        backgroundColor: colorAccent,
        elevation: 0,
        title: Text(appLocalizations.textEditorTitle,
            style: const TextStyle(
                color: colorWhite,
                fontSize: 13.8,
                fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            tooltip: appLocalizations.done,
            onPressed: () => _handleConfirm(canvasSize, appLocalizations),
            icon: Icon(
              Icons.check,
              color:
                  _isTextEmpty ? colorWhite.withValues(alpha: .4) : colorWhite,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Dimens.spacingM, Dimens.spacingM,
                Dimens.spacingM, Dimens.spacingS),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: colorWhite,
                    borderRadius: BorderRadius.circular(Dimens.radiusXl),
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
                    autofocus: true,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (value) => setState(() {
                      if (value.trim().isNotEmpty) {
                        _errorText = null;
                      }
                    }),
                    style: const TextStyle(fontSize: Dimens.fontSizeM),
                    decoration: InputDecoration(
                      hintText: appLocalizations.enterTextHint,
                      errorText: _errorText,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: Dimens.spacingM,
                          vertical: Dimens.spacingMd),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimens.radiusXl),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimens.radiusXl),
                        borderSide: BorderSide.none,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimens.radiusXl),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.error,
                            width: Dimens.borderWidthThin),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimens.radiusXl),
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.error,
                            width: Dimens.borderWidthThin),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: Dimens.spacingMd),
                Row(
                  children: [
                    Text(appLocalizations.text,
                        style: const TextStyle(
                            fontSize: Dimens.fontSizeS,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(width: Dimens.spacingS),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _availableColors.map((c) {
                            final bool selected = c == _textColor;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimens.spacingXs),
                              child: InkWell(
                                onTap: () => setState(() => _textColor = c),
                                borderRadius:
                                    BorderRadius.circular(Dimens.radiusXxl),
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: c,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: selected ? colorAccent : grey300,
                                      width: selected
                                          ? Dimens.borderWidthThick
                                          : Dimens.borderWidthThin,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(width: Dimens.spacingS),
                    ToggleButtons(
                      isSelected: [
                        _align == TextAlign.left,
                        _align == TextAlign.center,
                        _align == TextAlign.right,
                      ],
                      borderRadius: BorderRadius.circular(Dimens.radiusM),
                      selectedColor: colorWhite,
                      color: colorBlack54,
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
                const SizedBox(height: Dimens.spacingMd),
                Row(
                  children: [
                    Text(appLocalizations.backgroundLabel,
                        style: const TextStyle(
                            fontSize: Dimens.fontSizeS,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(width: Dimens.spacingS),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _availableColors.map((c) {
                            final bool selected = c == _backgroundColor;
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: Dimens.spacingXs),
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
                                borderRadius:
                                    BorderRadius.circular(Dimens.radiusXxl),
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: c,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: selected ? colorAccent : grey300,
                                      width: selected
                                          ? Dimens.borderWidthThick
                                          : Dimens.borderWidthThin,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(width: Dimens.spacingS),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimens.spacingS,
                          vertical: Dimens.spacingSm),
                      decoration: BoxDecoration(
                        color: grey100,
                        borderRadius: BorderRadius.circular(Dimens.radiusM),
                      ),
                      child: Text(
                        '${_controller.text.length}',
                        style: const TextStyle(
                            fontSize: Dimens.fontSizeS, color: colorBlack54),
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
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: colorWhite,
                  border:
                      Border.all(color: grey600, width: Dimens.borderWidthThin),
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
