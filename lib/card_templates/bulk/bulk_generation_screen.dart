import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:magicepaperapp/card_templates/bulk/bulk_result.dart';
import 'package:magicepaperapp/card_templates/bulk/bulk_results_screen.dart';
import 'package:magicepaperapp/card_templates/bulk/bulk_template.dart';
import 'package:magicepaperapp/card_templates/bulk/photo_source.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/native_canvas/model/canvas_document.dart';
import 'package:magicepaperapp/native_canvas/model/canvas_element.dart';
import 'package:magicepaperapp/native_canvas/model/card_layout.dart';
import 'package:magicepaperapp/native_canvas/widgets/badge_canvas_view.dart';
import 'package:magicepaperapp/provider/color_palette_provider.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/util/epd/display_device.dart';

class BulkGenerationScreen extends StatefulWidget {
  const BulkGenerationScreen({
    super.key,
    required this.template,
    required this.rows,
    required this.photos,
    required this.width,
    required this.height,
    this.device,
  });

  final BulkTemplate template;
  final List<Map<String, String>> rows;
  final List<File?> photos;
  final int width;
  final int height;
  final DisplayDevice? device;

  @override
  State<BulkGenerationScreen> createState() => _BulkGenerationScreenState();
}

class _BulkGenerationScreenState extends State<BulkGenerationScreen> {
  final GlobalKey _boundaryKey = GlobalKey();
  final PhotoResolver _resolver = PhotoResolver();

  late final List<Color> _palette;
  late final Color _canvasColor;

  List<CanvasElement> _currentElements = const [];
  int _done = 0;

  @override
  void initState() {
    super.initState();
    final colors = getIt<ColorPaletteProvider>().colors;
    _palette = colors.isNotEmpty ? colors : const [colorWhite, colorBlack];
    _canvasColor = _palette.first;
    WidgetsBinding.instance.addPostFrameCallback((_) => _run());
  }

  File? _photoFor(int index) {
    if (index < 0 || index >= widget.photos.length) return null;
    return widget.photos[index];
  }

  String _nameFor(Map<String, String> row, int index) {
    final value = row[widget.template.nameField.key]?.trim() ?? '';
    if (value.isNotEmpty) return value;
    return appLocalizations.bulkCardNumber(index + 1);
  }

  Future<void> _run() async {
    final results = <GeneratedBadge>[];
    for (var i = 0; i < widget.rows.length; i++) {
      final row = widget.rows[i];
      var photo = _photoFor(i);
      photo ??= await _resolver.resolve(row['photo']);
      Uint8List? photoBytes;
      if (photo != null && mounted) {
        await precacheImage(FileImage(photo), context);
        photoBytes = await photo.readAsBytes();
      }
      final layers =
          widget.template.buildLayers(row, photo, widget.width, widget.height);
      final elements = buildTemplateElements(
        width: widget.width,
        height: widget.height,
        palette: _palette,
        layers: layers,
      );
      if (!mounted) return;
      setState(() => _currentElements = elements);
      await WidgetsBinding.instance.endOfFrame;
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;
      final bytes = await _capture();
      if (bytes != null) {
        final document = CanvasDocument(
          width: widget.width,
          height: widget.height,
          canvasColor: _canvasColor,
          elements: toSerializableElements(
            elements,
            photoBytes: photoBytes,
            qrData: row['qr'],
            barcodeData: row['barcode'],
          ),
          strokes: const [],
        );
        results.add(GeneratedBadge(
            name: _nameFor(row, i),
            bytes: bytes,
            layers: layers,
            document: document));
      }
      if (!mounted) return;
      setState(() => _done = i + 1);
    }

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => BulkResultsScreen(
          badges: results,
          width: widget.width,
          height: widget.height,
          device: widget.device,
        ),
      ),
    );
  }

  Future<Uint8List?> _capture() async {
    try {
      final boundary = _boundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final image = await boundary.toImage(pixelRatio: 1);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      return byteData?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.rows.length;
    final progress = total == 0 ? 0.0 : _done / total;
    return Scaffold(
      backgroundColor: colorWhite,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: FittedBox(
              child: RepaintBoundary(
                key: _boundaryKey,
                child: BadgeCanvasView(
                  width: widget.width,
                  height: widget.height,
                  canvasColor: _canvasColor,
                  elements: _currentElements,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: ColoredBox(
              color: colorWhite.withValues(alpha: 0.82),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 220,
                    child: LinearProgressIndicator(
                      value: progress == 0 ? null : progress,
                      color: colorPrimary,
                      backgroundColor: grey200,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    appLocalizations.bulkGenerating(_done, total),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colorBlack,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();
