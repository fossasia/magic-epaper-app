import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as scanner;
import 'package:barcode_widget/barcode_widget.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:image/image.dart' as img;

AppLocalizations appLocalizations = getIt.get<AppLocalizations>();

class BarcodeScannerScreen extends StatefulWidget {
  final int width;
  final int height;

  const BarcodeScannerScreen({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final GlobalKey _barcodeKey = GlobalKey();
  final TextEditingController _textController = TextEditingController();
  String _barcodeData = '';
  bool _hasError = false;
  Barcode _selectedBarcode = Barcode.qrCode();
  bool _showScanner = false;
  scanner.MobileScannerController? _scannerController;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        _barcodeData = _textController.text;
        _hasError = false;
      });
    });
  }

  final Map<String, String> barcodeFormatToSupportedChars = {
    'Aztec': 'All',
    'CODABAR': '0-9 \$ - . / : +',
    'CODE 128': 'All',
    'CODE 39': '0-9 A-Z - . \$ / + % , ',
    'CODE 93': '0-9 A-Z - . \$ / + % , ',
    'Data Matrix': 'All',
    'EAN 13': '0-9',
    'EAN 2': '0-9',
    'EAN 5': '0-9',
    'EAN 8': '0-9',
    'GS1 128': 'All',
    'ISBN': '0-9',
    'ITF': '0-9',
    'ITF 14': '0-9',
    'ITF 16': '0-9',
    'PDF417': 'All',
    'QR Code': 'All',
    'RM4SCC': '0-9 A-Z',
    'Telepen': 'All',
    'UPC A': '0-9',
    'UPC E': '0-9',
  };

  String? _validateBarcodeData(String data, Barcode barcode) {
    if (data.isEmpty) {
      return null;
    }
    final allowedChars = barcode.charSet.toSet();
    for (final rune in data.runes) {
      if (!allowedChars.contains(rune)) {
        final char = String.fromCharCode(rune);
        final rules = barcodeFormatToSupportedChars[_selectedBarcode.name];
        return "${appLocalizations.invalidCharacter} '$char' \n${appLocalizations.supportedCharacters} ${rules ?? appLocalizations.pleaseCheckBarcodeRules}";
      }
    }
    if (data.length < barcode.minLength) {
      return '${appLocalizations.dataTooShort} ${barcode.name} ${appLocalizations.isText} ${barcode.minLength}.';
    }
    if (barcode.maxLength < 10000 && data.length > barcode.maxLength) {
      return '${appLocalizations.dataTooLong} ${barcode.name} ${appLocalizations.isText} ${barcode.maxLength}.';
    }
    return null;
  }

  void _handleBarcode(scanner.BarcodeCapture barcodes) {
    if (mounted && barcodes.barcodes.isNotEmpty) {
      final barcode = barcodes.barcodes.first;
      final value = barcode.displayValue ?? barcode.rawValue ?? '';

      setState(() {
        _textController.text = value;
        _barcodeData = value;
        _selectedBarcode = _getBarcodeType(barcode.format);
        _showScanner = false;
      });

      _scannerController?.dispose();
      _scannerController = null;
    }
  }

  @override
  void dispose() {
    _textController.dispose();

    _scannerController?.dispose();

    super.dispose();
  }

  void _startScanning() {
    setState(() {
      _showScanner = true;
      _scannerController = scanner.MobileScannerController();
    });
  }

  void _stopScanning() {
    setState(() {
      _showScanner = false;
    });
    _scannerController?.dispose();
    _scannerController = null;
  }

  Barcode _getBarcodeType(scanner.BarcodeFormat? format) {
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
        return Barcode.upcE();
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
        return Barcode.code128();
    }
  }

  Future<void> _generateBarcodeImage() async {
    RenderRepaintBoundary boundary =
        _barcodeKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    img.Image? barcodeImage = img.decodeImage(pngBytes);
    if (barcodeImage == null) return;

    img.Image resizedImage;
    if (barcodeImage.width > widget.width) {
      resizedImage = img.copyRotate(barcodeImage, angle: 270);
    } else {
      resizedImage = img.copyResize(barcodeImage,
          width: widget.width, height: widget.height);
    }
    final resultBytes = Uint8List.fromList(img.encodePng(resizedImage));
    Navigator.of(context).pop(resultBytes);
  }

  Widget _buildFormatSelector() {
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
      'EAN-5': Barcode.ean5(),
      'EAN-2': Barcode.ean2(),
      'GS1 128': Barcode.gs128(),
      'ISBN': Barcode.isbn(),
      'ITF': Barcode.itf(),
      'ITF-16': Barcode.itf16(),
      'ITF-14': Barcode.itf14(),
      'RM4SCC': Barcode.rm4scc(),
      'Telepen': Barcode.telepen(),
      'UPC-A': Barcode.upcA(),
      'UPC-E': Barcode.upcE(),
    };

    return DropdownButtonFormField<String>(
      value: _selectedBarcode.name,
      decoration: InputDecoration(
        labelText: appLocalizations.barcodeFormat,
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
      items: availableFormats.entries
          .map((entry) => DropdownMenuItem(
                value: entry.value.name,
                child: Text(entry.key),
              ))
          .toList(),
      onChanged: (newBarcodeName) {
        if (newBarcodeName != null) {
          setState(() {
            _selectedBarcode = availableFormats.values.firstWhere(
              (barcode) => barcode.name == newBarcodeName,
              orElse: () => Barcode.qrCode(),
            );
            _hasError = false;
          });
        }
      },
    );
  }

  Widget _buildBarcodePreview() {
    if (_barcodeData.isEmpty) {
      return Container(
        width: 240,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            appLocalizations.enterOrScanBarcodeData,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return BarcodeWidget(
      errorBuilder: (context, error) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _hasError = true;
          });
        });

        final validationError =
            _validateBarcodeData(_barcodeData, _selectedBarcode);
        if (validationError != null) {
          error = validationError;
        }

        return Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.red[50],
            border: Border.all(color: Colors.red[400]!, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red[600],
                  size: 45,
                ),
                const SizedBox(height: 8),
                Text(
                  appLocalizations.invalidBarcode,
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      error.toString(),
                      style: TextStyle(
                        color: Colors.red[600],
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      style: const TextStyle(color: colorBlack),
      padding: const EdgeInsets.all(10),
      backgroundColor: colorWhite,
      barcode: _selectedBarcode,
      data: _barcodeData,
    );
  }

  Widget _buildScannerView() {
    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.scanBarcode),
        backgroundColor: colorAccent,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _stopScanning,
        ),
      ),
      backgroundColor: colorBlack,
      body: Stack(
        children: [
          scanner.MobileScanner(
            controller: _scannerController,
            onDetect: _handleBarcode,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: const Color.fromRGBO(0, 0, 0, 0.4),
              child: Center(
                child: Text(
                  appLocalizations.pointCameraAtBarcode,
                  style: const TextStyle(color: colorWhite, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showScanner) {
      return _buildScannerView();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.barcodeGenerator),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: colorAccent,
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      labelText: appLocalizations.barcodeData,
                      hintText: appLocalizations.barcodeDataHint,
                      prefixIcon: const Icon(Icons.qr_code_2_rounded),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                    child: Text(
                      '${appLocalizations.characters}: ${_barcodeData.length}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _startScanning,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: Text(appLocalizations.scanBarcode),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorAccent,
                    foregroundColor: colorWhite,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              if (_barcodeData.isNotEmpty) _buildFormatSelector(),
              RepaintBoundary(
                key: _barcodeKey,
                child: Center(child: _buildBarcodePreview()),
              ),
              const SizedBox(height: 20),
              if (_barcodeData.isNotEmpty && !_hasError)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _generateBarcodeImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: colorWhite,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(appLocalizations.generateImage),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
