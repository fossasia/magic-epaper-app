import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as scanner;
import 'package:pro_image_editor/core/models/layers/layer_interaction.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

class BarcodeEditor extends StatefulWidget {
  final Function(WidgetLayer) onBarcodeCreated;

  final double initialScale;

  const BarcodeEditor({
    super.key,
    required this.onBarcodeCreated,
    this.initialScale = 6.0,
  });

  @override
  State<BarcodeEditor> createState() => _BarcodeEditorState();
}

class _BarcodeEditorState extends State<BarcodeEditor> {
  final TextEditingController _barcodeController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();
  Barcode _selectedBarcode = Barcode.qrCode();
  String _barcodeData = '';
  String _debouncedBarcodeData = '';
  Timer? _validationDebounce;
  bool _showScanner = false;
  bool _isAnalyzingUpload = false;
  bool _torchOn = false;
  bool _scanHandled = false;
  scanner.MobileScannerController? _scannerController;

  static const Duration _validationDebounceDuration = Duration(milliseconds: 450);

  void _showSnackBar(String message, {Color background = Colors.red}) {
    _messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: background,
      ),
    );
  }

  static const List<scanner.BarcodeFormat> _supportedScanFormats = [
    scanner.BarcodeFormat.qrCode,
    scanner.BarcodeFormat.code128,
    scanner.BarcodeFormat.code39,
    scanner.BarcodeFormat.code93,
    scanner.BarcodeFormat.ean13,
    scanner.BarcodeFormat.ean8,
    scanner.BarcodeFormat.upcA,
    scanner.BarcodeFormat.upcE,
    scanner.BarcodeFormat.dataMatrix,
    scanner.BarcodeFormat.pdf417,
    scanner.BarcodeFormat.aztec,
    scanner.BarcodeFormat.codabar,
    scanner.BarcodeFormat.itf,
  ];

  final Map<String, String> barcodeFormatToSupportedChars = {
    'Aztec': 'Any text',
    'CODABAR': 'digits and - \$ . / : +',
    'CODE 128': 'Any printable ASCII',
    'CODE 39': '0–9, A–Z, space, - . \$ / + %',
    'CODE 93': '0–9, A–Z, space, - . \$ / + %',
    'Data Matrix': 'Any text',
    'EAN 13': '0 to 9',
    'EAN 8': '0 to 9',
    'ITF': '0 to 9',
    'PDF417': 'Any text',
    'QR Code': 'Any text',
    'UPC A': '0 to 9',
  };

  /// Formats whose final character is a checksum the package can compute for
  /// us. For these we cap the input one short of the full length and let the
  /// package append the check digit — much friendlier than asking users to
  /// memorise checksum math.
  static const Set<String> _autoChecksumFormats = {
    'EAN 13',
    'EAN 8',
    'UPC A',
  };

  /// Formats whose alphabet only includes uppercase letters — we auto-uppercase
  /// keystrokes so lowercase input isn't silently dropped.
  static const Set<String> _uppercaseOnlyFormats = {
    'CODE 39',
    'CODE 93',
  };

  @override
  void initState() {
    super.initState();
    _barcodeController.addListener(() {
      final text = _barcodeController.text;
      if (text == _barcodeData) return;
      setState(() {
        _barcodeData = text;
      });
      _scheduleValidation(text);
    });
  }

  @override
  void dispose() {
    _validationDebounce?.cancel();
    _barcodeController.dispose();
    _scannerController?.dispose();
    super.dispose();
  }

  void _scheduleValidation(String text) {
    _validationDebounce?.cancel();
    if (text.isEmpty) {
      // Clear instantly so the placeholder reappears with no delay.
      setState(() {
        _debouncedBarcodeData = '';
      });
      return;
    }
    _validationDebounce = Timer(_validationDebounceDuration, () {
      if (!mounted) return;
      setState(() {
        _debouncedBarcodeData = text;
      });
    });
  }

  static const Map<String, String> _friendlyNames = {
    'QR-Code': 'QR Code',
    'EAN 13': 'EAN-13',
    'EAN 8': 'EAN-8',
    'UPC A': 'UPC-A',
    'CODABAR': 'Codabar',
    'CODE 128': 'Code 128',
    'CODE 39': 'Code 39',
    'CODE 93': 'Code 93',
  };

  String _friendlyName(Barcode b) => _friendlyNames[b.name] ?? b.name;

  _ValidationError? _validateBarcodeData(String data, Barcode barcode) {
    if (data.isEmpty) return null;
    final friendly = _friendlyName(barcode);

    if (barcode.charSet.isNotEmpty && barcode.name != 'QR-Code') {
      final allowedChars = barcode.charSet.toSet();
      for (final rune in data.runes) {
        if (!allowedChars.contains(rune)) {
          final char = String.fromCharCode(rune);
          final allowed = barcodeFormatToSupportedChars[barcode.name] ??
              'See barcode rules';
          return _ValidationError(
            title: 'Character not allowed',
            detail:
                "$friendly doesn't allow '$char'.\nAllowed: $allowed",
          );
        }
      }
    }

    final minLen = _effectiveMinLength(barcode);
    if (data.length < minLen) {
      final needed = minLen - data.length;
      return _ValidationError(
        title: 'Data too short',
        detail:
            '$friendly needs ${_lengthRequirement(barcode)}.\nYou entered ${data.length} — add $needed more.',
        showInPreview: false,
      );
    }

    final effMax = _effectiveMaxLength(barcode);
    if (effMax != null && data.length > effMax) {
      final extra = data.length - effMax;
      return _ValidationError(
        title: 'Data too long',
        detail:
            '$friendly fits ${_lengthRequirement(barcode)}.\nYou entered ${data.length} — that\'s $extra too many.',
      );
    }

    // Final check: ask the underlying barcode package to actually encode the
    // data. This catches checksum mismatches (EAN/UPC/ITF) and other format
    // rules that simple length/charset checks miss.
    try {
      barcode.verify(data);
    } on BarcodeException catch (e) {
      return _ValidationError(
        title: 'Invalid $friendly data',
        detail: _humanizeEncodeError(e.message, friendly),
        suggestion: _suggestionFor(barcode, data, e.message),
      );
    } catch (_) {
      return _ValidationError(
        title: 'Invalid $friendly data',
        detail: 'This value can\'t be encoded as $friendly. Please check it.',
      );
    }

    return null;
  }

  /// Builds a context-aware tip when validation fails. Returns null if there's
  /// nothing helpful to add (so the card just shows title + detail).
  _Suggestion? _suggestionFor(Barcode b, String data, String rawError) {
    // ITF needs an even number of digits.
    if (b.name == 'ITF' && data.length.isOdd) {
      return const _Suggestion(
        text: 'ITF needs an even number of digits. Add or remove one digit.',
      );
    }

    // Codabar's start/stop letters are added by the package; if the user
    // typed letters, point that out.
    if (b.name == 'CODABAR' && RegExp(r'[A-Za-z]').hasMatch(data)) {
      return const _Suggestion(
        text:
            'Start and stop letters are added automatically. Use only digits and (\$ . / : +).',
      );
    }

    // A scanned UPC-E that came in as 8 compressed digits won't satisfy
    // UPC-A's 11-digit minimum. Explain instead of showing a bare error.
    if (b.name == 'UPC A' && data.length == 8) {
      return const _Suggestion(
        text:
            'This looks like a compressed UPC-E code. Enter the full 11-digit UPC-A version to edit it here.',
      );
    }

    return null;
  }


  static final RegExp _checksumRegex =
      RegExp(r'checksum "(.)" should be "(.)"');

  String _humanizeEncodeError(String raw, String friendlyName) {
    final match = _checksumRegex.firstMatch(raw);
    if (match != null) {
      final entered = match.group(1);
      final expected = match.group(2);
      return 'The last digit is a check digit. You entered "$entered" but it should be "$expected".\nTip: enter one fewer digit and we\'ll calculate it for you.';
    }
    if (raw.contains('not ') && raw.contains('digits')) {
      return raw.replaceFirst(RegExp(r'^Unable to encode "[^"]*" to [^,]+, '), '')
          .replaceFirst('it is not', 'Length should be');
    }
    // Strip the noisy "Unable to encode ..." prefix if present.
    return raw.replaceFirst(
        RegExp(r'^Unable to encode "[^"]*" to [^,]+,\s*'), '');
  }

  String _lengthRequirement(Barcode b) {
    final minLen = _effectiveMinLength(b);
    final maxLen = _effectiveMaxLength(b);
    if (maxLen == null) {
      return minLen <= 1 ? 'any length' : 'at least $minLen characters';
    }
    if (minLen == maxLen) return '$maxLen characters';
    return '$minLen–$maxLen characters';
  }

  /// User-facing maximum length. For auto-checksum formats we shave one off the
  /// package's max so the user enters only the data portion; the package adds
  /// the check digit when encoding. Returns `null` for unbounded formats.
  int? _effectiveMaxLength(Barcode b) {
    if (b.maxLength >= 10000) return null;
    if (_autoChecksumFormats.contains(b.name)) return b.maxLength - 1;
    return b.maxLength;
  }

  /// Minimum useful length the user must reach before the preview can render
  /// successfully. Mirrors `_effectiveMaxLength` for auto-checksum formats.
  int _effectiveMinLength(Barcode b) {
    if (_autoChecksumFormats.contains(b.name)) return b.maxLength - 1;
    return b.minLength;
  }

  static const Map<String, String> _formatHints = {
    'QR-Code': 'Any text',
    'Data Matrix': 'Any text',
    'Aztec': 'Any text',
    'PDF417': 'Any text',
    'CODE 128': 'Any printable ASCII',
    'CODE 39': 'A to Z, 0 to 9, and (space . \$ / + %)',
    'CODE 93': 'A to Z, 0 to 9, and (space . \$ / + %)',
    'CODABAR': 'Digits and (\$ . / : +)',
    'EAN 13': '12 digits (check digit added automatically)',
    'EAN 8': '7 digits (check digit added automatically)',
    'UPC A': '11 digits (check digit added automatically)',
    'ITF': 'Even number of digits',
  };

  static const Map<String, String> _formatExamples = {
    'QR-Code': 'e.g. https://example.com',
    'Data Matrix': 'e.g. Order #12345',
    'Aztec': 'e.g. AZTEC-DATA-001',
    'PDF417': 'e.g. PDF417 payload',
    'CODE 128': 'e.g. ABC-1234',
    'CODE 39': 'e.g. HELLO-123',
    'CODE 93': 'e.g. HELLO-123',
    'CODABAR': 'e.g. 1234-5678',
    'EAN 13': 'e.g. 590123412345',
    'EAN 8': 'e.g. 1234567',
    'UPC A': 'e.g. 03600029145',
    'ITF': 'e.g. 12345678',
  };

  String _formatHint(Barcode b) => _formatHints[b.name] ?? 'Any text';

  String _formatExample(Barcode b) =>
      _formatExamples[b.name] ?? 'Enter barcode data';

  List<TextInputFormatter> _inputFormattersFor(Barcode b) {
    final formatters = <TextInputFormatter>[];
    if (_uppercaseOnlyFormats.contains(b.name)) {
      formatters.add(_UpperCaseFormatter());
    }
    if (b.charSet.isNotEmpty && b.name != 'QR-Code') {
      formatters.add(_CharSetFormatter(b.charSet.toSet()));
    }
    return formatters;
  }

  /// Strips characters not allowed by [newFormat] and truncates to its max
  /// length. Called when the user explicitly switches format so they're never
  /// stranded with text that's invalid for the new selection.
  void _cleanTextForFormat(Barcode newFormat) {
    final original = _barcodeController.text;
    if (original.isEmpty) return;

    String cleaned = original;
    if (newFormat.charSet.isNotEmpty && newFormat.name != 'QR-Code') {
      final allowed = newFormat.charSet.toSet();
      cleaned = cleaned.runes
          .where(allowed.contains)
          .map(String.fromCharCode)
          .join();
    }
    final maxLen = _effectiveMaxLength(newFormat);
    if (maxLen != null && cleaned.length > maxLen) {
      cleaned = cleaned.substring(0, maxLen);
    }
    if (cleaned != original) {
      _barcodeController.text = cleaned;
      _barcodeController.selection =
          TextSelection.collapsed(offset: cleaned.length);
    }
  }

  Barcode? _getBarcodeType(scanner.BarcodeFormat? format) {
    switch (format) {
      case scanner.BarcodeFormat.qrCode:
        return Barcode.qrCode();
      case scanner.BarcodeFormat.code128:
        return Barcode.code128();
      case scanner.BarcodeFormat.code39:
        return Barcode.code39();
      case scanner.BarcodeFormat.code93:
        return Barcode.code93();
      case scanner.BarcodeFormat.ean13:
        return Barcode.ean13();
      case scanner.BarcodeFormat.ean8:
        return Barcode.ean8();
      case scanner.BarcodeFormat.upcA:
        return Barcode.upcA();
      case scanner.BarcodeFormat.upcE:
        // UPC-E is a compressed UPC-A. Map scans to UPC-A so the user can
        // edit them like any other UPC-A (the scanner returns either the
        // 8-digit compressed form or the 12-digit expanded form; either way
        // UPC-A's encoder accepts the latter and rejects the former, which
        // _handleBarcode then surfaces sensibly).
        return Barcode.upcA();
      case scanner.BarcodeFormat.dataMatrix:
        return Barcode.dataMatrix();
      case scanner.BarcodeFormat.pdf417:
        return Barcode.pdf417();
      case scanner.BarcodeFormat.aztec:
        return Barcode.aztec();
      case scanner.BarcodeFormat.codabar:
        return Barcode.codabar();
      case scanner.BarcodeFormat.itf:
        return Barcode.itf();
      default:
        return null;
    }
  }

  void _handleBarcode(scanner.BarcodeCapture barcodes) {
    if (_scanHandled) return;
    if (mounted && barcodes.barcodes.isNotEmpty) {
      _scanHandled = true;
      final barcode = barcodes.barcodes.first;
      var value = barcode.displayValue ?? barcode.rawValue ?? '';
      final detected = _getBarcodeType(barcode.format);

      // Scanner returns the full barcode including its check digit, but we
      // cap the field at length-1 for auto-checksum formats. Drop the trailing
      // check digit so the value fits and the package re-computes the same
      // digit when rendering.
      if (detected != null &&
          _autoChecksumFormats.contains(detected.name) &&
          value.length == detected.maxLength) {
        value = value.substring(0, value.length - 1);
      }

      HapticFeedback.mediumImpact();

      setState(() {
        _barcodeController.text = value;
        _barcodeData = value;
        _debouncedBarcodeData = value;
        if (detected != null) {
          _selectedBarcode = detected;
        }
        _showScanner = false;
      });

      _scannerController?.dispose();
      _scannerController = null;

      if (detected == null) {
        _showSnackBar(
          'Data filled in. Format could not be auto-detected — please pick the correct format from the dropdown.',
          background: Colors.orange.shade700,
        );
      }
    }
  }

  void _startScanning() {
    setState(() {
      _showScanner = true;
      _torchOn = false;
      _scanHandled = false;
      _scannerController = scanner.MobileScannerController(
        formats: _supportedScanFormats,
        detectionSpeed: scanner.DetectionSpeed.normal,
        detectionTimeoutMs: 150,
      );
    });
  }

  Future<void> _toggleTorch() async {
    final controller = _scannerController;
    if (controller == null) return;
    try {
      await controller.toggleTorch();
      if (!mounted) return;
      setState(() => _torchOn = !_torchOn);
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('Flash is not available on this device.');
    }
  }

  Future<void> _flipCamera() async {
    final controller = _scannerController;
    if (controller == null) return;
    try {
      await controller.switchCamera();
    } catch (_) {
      if (!mounted) return;
      _showSnackBar('No other camera available.');
    }
  }

  Future<scanner.BarcodeCapture?> _analyzeAtPath(
    scanner.MobileScannerController analyzer,
    String path,
  ) async {
    try {
      return await analyzer.analyzeImage(
        path,
        formats: _supportedScanFormats,
      );
    } catch (_) {
      return null;
    }
  }

  Future<scanner.BarcodeCapture?> _analyzeImageVariant(
    scanner.MobileScannerController analyzer,
    img.Image variant,
  ) async {
    final tmpFile = File(
      '${Directory.systemTemp.path}/barcode_upload_${DateTime.now().microsecondsSinceEpoch}.png',
    );
    try {
      await tmpFile.writeAsBytes(img.encodePng(variant));
      return await _analyzeAtPath(analyzer, tmpFile.path);
    } finally {
      try {
        await tmpFile.delete();
      } catch (_) {}
    }
  }

  Future<void> _uploadBarcodeImage() async {
    if (_isAnalyzingUpload) return;
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    // Reset so the _handleBarcode guard (meant to dedupe live-scanner frames)
    // doesn't swallow this upload's one-shot result.
    _scanHandled = false;
    setState(() => _isAnalyzingUpload = true);

    final analyzer = scanner.MobileScannerController(
      formats: _supportedScanFormats,
    );

    try {
      // 1. Fast path: try the file directly. Works for most clean images.
      scanner.BarcodeCapture? result =
          await _analyzeAtPath(analyzer, picked.path);
      if (!mounted) return;
      if (result != null && result.barcodes.isNotEmpty) {
        _handleBarcode(result);
        return;
      }

      // 2. Fallback: decode bytes, normalize EXIF orientation, and try
      //    rotations + a contrast-boosted variant. The live scanner sees
      //    many frames at different angles — analyzeImage only sees one,
      //    so a single still can fail where scanning succeeds.
      final bytes = await picked.readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded == null) {
        if (!mounted) return;
        _showSnackBar("Couldn't read the image. Try a different file.");
        return;
      }
      final normalized = img.bakeOrientation(decoded);

      final variants = <img.Image>[
        normalized,
        img.copyRotate(normalized, angle: 90),
        img.copyRotate(normalized, angle: 180),
        img.copyRotate(normalized, angle: 270),
        img.adjustColor(img.Image.from(normalized), contrast: 1.5),
        img.grayscale(img.Image.from(normalized)),
      ];

      for (final variant in variants) {
        result = await _analyzeImageVariant(analyzer, variant);
        if (!mounted) return;
        if (result != null && result.barcodes.isNotEmpty) {
          _handleBarcode(result);
          return;
        }
      }

      _showSnackBar(
        "This doesn't look like a barcode. Please upload a clear barcode image.",
      );
    } finally {
      await analyzer.dispose();
      if (mounted) setState(() => _isAnalyzingUpload = false);
    }
  }

  void _stopScanning() {
    setState(() {
      _showScanner = false;
    });
    _scannerController?.dispose();
    _scannerController = null;
  }

  void _addBarcodeLayer() {
    final validationError =
        _validateBarcodeData(_barcodeData, _selectedBarcode);
    if (validationError != null) {
      _showSnackBar('${validationError.title}: ${validationError.detail}');
      return;
    }

    final barcodeWidget = BarcodeWidget(
      barcode: _selectedBarcode,
      data: _barcodeData,
      style: const TextStyle(color: Colors.black),
      backgroundColor: Colors.white,
      padding: const EdgeInsets.all(2),
    );

    final layer = WidgetLayer(
      offset: Offset.zero,
      scale: widget.initialScale,
      widget: Container(
        child: barcodeWidget,
      ),
      interaction: LayerInteraction(
        enableEdit: true,
        enableMove: true,
        enableRotate: true,
        enableScale: true,
        enableSelection: true,
      ),
    );

    widget.onBarcodeCreated(layer);

    _barcodeController.clear();
    _barcodeData = '';
    _debouncedBarcodeData = '';
    _validationDebounce?.cancel();
  }

  Widget _buildBarcodeFormatSelector(StateSetter setModalState) {
    final Map<String, Barcode> availableFormats = {
      'QR Code': Barcode.qrCode(),
      'Data Matrix': Barcode.dataMatrix(),
      'Aztec': Barcode.aztec(),
      'PDF417': Barcode.pdf417(),
      'Code 128': Barcode.code128(),
      'Code 93': Barcode.code93(),
      'Code 39': Barcode.code39(),
      'Codabar': Barcode.codabar(),
      'EAN-13': Barcode.ean13(),
      'EAN-8': Barcode.ean8(),
      'ITF': Barcode.itf(),
      'UPC-A': Barcode.upcA(),
    };

    return DropdownButtonFormField<String>(
      initialValue: _selectedBarcode.name,
      isExpanded: true,
      decoration: const InputDecoration(
        labelText: 'Barcode Format',
        border: OutlineInputBorder(),
      ),
      items: availableFormats.entries
          .map((entry) => DropdownMenuItem(
                value: entry.value.name,
                child: Text(
                  entry.key,
                  overflow: TextOverflow.ellipsis,
                ),
              ))
          .toList(),
      onChanged: (newBarcodeName) {
        if (newBarcodeName == null) return;
        final next = availableFormats.values.firstWhere(
          (barcode) => barcode.name == newBarcodeName,
          orElse: () => Barcode.qrCode(),
        );
        setState(() {
          _selectedBarcode = next;
        });
        setModalState(() {});
        _cleanTextForFormat(next);
      },
    );
  }

  Widget _buildBarcodePreviewWidget() {
    if (_debouncedBarcodeData.isEmpty) {
      return _buildEmptyPreviewPlaceholder();
    }

    final validationError =
        _validateBarcodeData(_debouncedBarcodeData, _selectedBarcode);
    if (validationError != null) {
      // Hide length-too-short errors during typing (the orange counter is
      // already signalling). Show actionable errors (checksum, encode rules)
      // because by then the user has typed enough to need a real message.
      if (!validationError.showInPreview) {
        return _buildEmptyPreviewPlaceholder();
      }
      return _buildPreviewErrorCard(validationError);
    }

    final is2D = _isTwoDimensional(_selectedBarcode);
    final aspectRatio = is2D ? 1.0 : 3.0;

    return Container(
      key: ValueKey('preview-barcode-${_selectedBarcode.name}'),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(14),
      child: Center(
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: BarcodeWidget(
            style: const TextStyle(color: Colors.black),
            padding: const EdgeInsets.all(8),
            backgroundColor: Colors.white,
            barcode: _selectedBarcode,
            data: _debouncedBarcodeData,
            drawText: !is2D,
            errorBuilder: (context, error) => _buildPreviewErrorCard(
              _ValidationError(
                title: 'Invalid ${_friendlyName(_selectedBarcode)} data',
                detail: _humanizeEncodeError(
                    error, _friendlyName(_selectedBarcode)),
                suggestion: _suggestionFor(
                    _selectedBarcode, _debouncedBarcodeData, error),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewErrorCard(_ValidationError error) {
    final suggestion = error.suggestion;
    return Container(
      key: const ValueKey('preview-error'),
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.info_outline_rounded,
                color: Colors.amber.shade800,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    error.title,
                    style: TextStyle(
                      color: Colors.amber.shade900,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    error.detail,
                    style: TextStyle(
                      color: Colors.brown.shade800,
                      fontSize: 12.5,
                      height: 1.4,
                    ),
                  ),
                  if (suggestion != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: Colors.amber.shade200, width: 1),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lightbulb_outline_rounded,
                              size: 16, color: Colors.amber.shade800),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              suggestion.text,
                              style: TextStyle(
                                color: Colors.brown.shade900,
                                fontSize: 12,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const Set<String> _twoDimensionalBarcodeNames = {
    'QR-Code',
    'Aztec',
    'Data Matrix',
    'PDF417',
  };

  bool _isTwoDimensional(Barcode barcode) =>
      _twoDimensionalBarcodeNames.contains(barcode.name);

  Widget _buildEmptyPreviewPlaceholder() {
    return Container(
      key: const ValueKey('preview-empty'),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.qr_code_2_rounded,
              size: 36,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            Text(
              'Live preview',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Start typing to see your barcode',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerView() {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Scan Barcode',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: _stopScanning,
        ),
      ),
      body: Stack(
        children: [
          scanner.MobileScanner(
            controller: _scannerController,
            onDetect: _handleBarcode,
            errorBuilder: (context, error) => _buildScannerError(error),
          ),
          const _ScannerOverlay(),
          _buildScannerInstructionPill(),
          _buildScannerControls(),
          if (_isAnalyzingUpload)
            Positioned.fill(
              child: Container(
                color: const Color.fromRGBO(0, 0, 0, 0.6),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        'Analyzing image…',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScannerInstructionPill() {
    return Positioned(
      top: kToolbarHeight + 36,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.center_focus_strong_rounded,
                  color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text(
                'Align barcode within the frame',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScannerControls() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _scannerControlButton(
                  icon: _torchOn
                      ? Icons.flash_on_rounded
                      : Icons.flash_off_rounded,
                  label: 'Flash',
                  active: _torchOn,
                  onTap: _toggleTorch,
                ),
                _scannerControlButton(
                  icon: Icons.flip_camera_ios_rounded,
                  label: 'Flip Camera',
                  onTap: _flipCamera,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _scannerControlButton({
    required IconData icon,
    required String label,
    required VoidCallback? onTap,
    bool active = false,
  }) {
    final color = active ? const Color(0xFF4ADE80) : Colors.white;
    final bg = active
        ? const Color(0xFF4ADE80).withValues(alpha: 0.18)
        : Colors.white.withValues(alpha: 0.08);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: bg,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerError(scanner.MobileScannerException error) {
    final isPermission =
        error.errorCode == scanner.MobileScannerErrorCode.permissionDenied;
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPermission ? Icons.no_photography_rounded : Icons.error_outline,
              color: Colors.white70,
              size: 56,
            ),
            const SizedBox(height: 16),
            Text(
              isPermission ? 'Camera access needed' : 'Camera unavailable',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isPermission
                  ? 'Grant camera permission in Settings to scan barcodes, or upload an image from your gallery.'
                  : 'We couldn\'t start the camera. Try uploading an image instead.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 20),
            FilledButton.tonalIcon(
              onPressed: _isAnalyzingUpload ? null : _uploadBarcodeImage,
              icon: const Icon(Icons.photo_library_rounded),
              label: const Text('Upload from gallery'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showScanner) {
      return _buildScannerView();
    }

    final media = MediaQuery.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: media.size.height * 0.9,
      ),
      child: ScaffoldMessenger(
        key: _messengerKey,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            top: true,
            child: _buildSheetBody(context),
          ),
        ),
      ),
    );
  }

  Widget _buildSheetBody(BuildContext context) {
    final media = MediaQuery.of(context);
    final isNarrow = media.size.width < 360;
    final previewMaxHeight = (media.size.height * 0.32).clamp(160.0, 280.0);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        8,
        16,
        16 + media.viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'Add Barcode',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
                color: Colors.grey.shade900,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _barcodeController,
              maxLength: _effectiveMaxLength(_selectedBarcode),
              inputFormatters: _inputFormattersFor(_selectedBarcode),
              decoration: InputDecoration(
                labelText: 'Barcode Data',
                hintText: _formatExample(_selectedBarcode),
                prefixIcon: const Icon(Icons.qr_code_2_rounded),
                border: const OutlineInputBorder(),
              ),
              buildCounter: (
                context, {
                required currentLength,
                required isFocused,
                maxLength,
              }) {
                final countText = maxLength != null
                    ? '$currentLength / $maxLength'
                    : '$currentLength';
                final overMin =
                    _barcodeData.length >= _selectedBarcode.minLength;
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatHint(_selectedBarcode),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        countText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: overMin
                              ? Colors.grey[600]
                              : Colors.orange[700],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildActionButtons(isNarrow),
            const SizedBox(height: 16),
            StatefulBuilder(
              builder: (context, setModalState) =>
                  _buildBarcodeFormatSelector(setModalState),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 140,
                maxHeight: previewMaxHeight,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.04),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: Center(child: _buildBarcodePreviewWidget()),
              ),
            ),
            const SizedBox(height: 16),
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              child: (_debouncedBarcodeData.isNotEmpty &&
                      _validateBarcodeData(
                              _debouncedBarcodeData, _selectedBarcode) ==
                          null)
                  ? FilledButton.icon(
                      key: const Key('addBarcodeButton'),
                      onPressed: _addBarcodeLayer,
                      icon: const Icon(Icons.check_rounded),
                      label: const Text('Add to canvas'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isNarrow) {
    final scanBtn = _SourceButton(
      icon: Icons.qr_code_scanner_rounded,
      label: 'Scan',
      onPressed: _isAnalyzingUpload ? null : _startScanning,
    );
    final uploadBtn = _SourceButton(
      icon: Icons.image_outlined,
      label: _isAnalyzingUpload ? 'Analyzing…' : 'Upload',
      busy: _isAnalyzingUpload,
      onPressed: _isAnalyzingUpload ? null : _uploadBarcodeImage,
    );

    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          scanBtn,
          const SizedBox(height: 10),
          uploadBtn,
        ],
      );
    }
    return Row(
      children: [
        Expanded(child: scanBtn),
        const SizedBox(width: 12),
        Expanded(child: uploadBtn),
      ],
    );
  }
}

class _SourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool busy;

  const _SourceButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.busy = false,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FilledButton.tonalIcon(
      onPressed: onPressed,
      icon: busy
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2.4),
            )
          : Icon(icon),
      label: Text(label, overflow: TextOverflow.ellipsis),
      style: FilledButton.styleFrom(
        backgroundColor: scheme.surfaceContainerHighest,
        foregroundColor: scheme.onSurface,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
      ),
    );
  }
}

class _ValidationError {
  final String title;
  final String detail;
  final bool showInPreview;
  final _Suggestion? suggestion;

  const _ValidationError({
    required this.title,
    required this.detail,
    this.showInPreview = true,
    this.suggestion,
  });
}

class _Suggestion {
  final String text;

  const _Suggestion({required this.text});
}

class _UpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final upper = newValue.text.toUpperCase();
    if (upper == newValue.text) return newValue;
    return TextEditingValue(text: upper, selection: newValue.selection);
  }
}

class _CharSetFormatter extends TextInputFormatter {
  final Set<int> allowed;

  _CharSetFormatter(this.allowed);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final filtered = newValue.text.runes
        .where(allowed.contains)
        .map(String.fromCharCode)
        .join();
    if (filtered == newValue.text) return newValue;
    final newOffset = newValue.selection.baseOffset
        .clamp(0, filtered.length);
    return TextEditingValue(
      text: filtered,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }
}

class _ScannerOverlay extends StatefulWidget {
  const _ScannerOverlay();

  @override
  State<_ScannerOverlay> createState() => _ScannerOverlayState();
}

class _ScannerOverlayState extends State<_ScannerOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          size: Size.infinite,
          painter: _ScannerOverlayPainter(progress: _controller.value),
        ),
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  static const Color _accent = Color(0xFF4ADE80);
  static const double _cornerRadius = 20.0;
  static const double _cornerLen = 32.0;

  final double progress;

  _ScannerOverlayPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final boxWidth = size.width * 0.86;
    final boxHeight = (boxWidth * 0.6).clamp(0.0, size.height * 0.55);
    final left = (size.width - boxWidth) / 2;
    final top = (size.height - boxHeight) / 2;
    final boxRect = Rect.fromLTWH(left, top, boxWidth, boxHeight);
    final boxRRect =
        RRect.fromRectAndRadius(boxRect, const Radius.circular(_cornerRadius));

    // Dim everything, then punch a clear hole where the scan box sits.
    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color.fromRGBO(0, 0, 0, 0.6),
    );
    canvas.drawRRect(
      boxRRect,
      Paint()..blendMode = BlendMode.clear,
    );
    canvas.restore();

    // Green rounded corner brackets.
    final corner = Paint()
      ..color = _accent
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final l = boxRect.left;
    final t = boxRect.top;
    final r = boxRect.right;
    final b = boxRect.bottom;
    const cr = _cornerRadius;
    const ln = _cornerLen;

    // Top-left
    canvas.drawPath(
      Path()
        ..moveTo(l, t + ln)
        ..lineTo(l, t + cr)
        ..arcToPoint(Offset(l + cr, t), radius: const Radius.circular(cr))
        ..lineTo(l + ln, t),
      corner,
    );
    // Top-right
    canvas.drawPath(
      Path()
        ..moveTo(r - ln, t)
        ..lineTo(r - cr, t)
        ..arcToPoint(Offset(r, t + cr), radius: const Radius.circular(cr))
        ..lineTo(r, t + ln),
      corner,
    );
    // Bottom-left
    canvas.drawPath(
      Path()
        ..moveTo(l, b - ln)
        ..lineTo(l, b - cr)
        ..arcToPoint(Offset(l + cr, b), radius: const Radius.circular(cr))
        ..lineTo(l + ln, b),
      corner,
    );
    // Bottom-right
    canvas.drawPath(
      Path()
        ..moveTo(r - ln, b)
        ..lineTo(r - cr, b)
        ..arcToPoint(Offset(r, b - cr), radius: const Radius.circular(cr))
        ..lineTo(r, b - ln),
      corner,
    );

    // Animated scan line + soft glow, clipped inside the frame.
    canvas.save();
    canvas.clipRRect(boxRRect);

    const inset = 18.0;
    final usableHeight = boxHeight - inset * 2;
    final lineY = top + inset + usableHeight * progress;
    final lineLeft = left + inset;
    final lineWidth = boxWidth - inset * 2;

    final glowRect = Rect.fromLTWH(lineLeft, lineY - 14, lineWidth, 28);
    canvas.drawRect(
      glowRect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _accent.withValues(alpha: 0.0),
            _accent.withValues(alpha: 0.28),
            _accent.withValues(alpha: 0.0),
          ],
        ).createShader(glowRect),
    );

    final lineRect = Rect.fromLTWH(lineLeft, lineY - 1, lineWidth, 2);
    canvas.drawRect(
      lineRect,
      Paint()
        ..shader = LinearGradient(
          colors: [
            _accent.withValues(alpha: 0.0),
            _accent,
            _accent.withValues(alpha: 0.0),
          ],
        ).createShader(lineRect),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ScannerOverlayPainter old) =>
      old.progress != progress;
}
