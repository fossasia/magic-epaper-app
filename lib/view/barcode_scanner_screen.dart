import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as scanner;
import 'package:barcode_widget/barcode_widget.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:image/image.dart' as img;

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
        return "Invalid character '$char' \nSupported characters are ${rules ?? 'Please check the barcode rules.'}";
      }
    }
    if (data.length < barcode.minLength) {
      return 'Data is too short. Minimum length for ${barcode.name} is ${barcode.minLength}.';
    }
    if (barcode.maxLength < 10000 && data.length > barcode.maxLength) {
      return 'Data is too long. Maximum length for ${barcode.name} is ${barcode.maxLength}.';
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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Barcode Format',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorBlack,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: colorAccent.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedBarcode.name,
                  isExpanded: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  items: availableFormats.entries
                      .map((entry) => DropdownMenuItem(
                            value: entry.value.name,
                            child: Text(
                              entry.key,
                              style: const TextStyle(
                                color: colorBlack,
                                fontSize: 16,
                              ),
                            ),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarcodePreview() {
    if (_barcodeData.isEmpty) {
      return Container(
        width: double.infinity,
        height: 200,
        margin: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code_2,
              size: 64,
              color: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Enter or scan barcode data',
              style: TextStyle(
                color: Colors.grey.withOpacity(0.7),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The barcode preview will appear here',
              style: TextStyle(
                color: Colors.grey.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BarcodeWidget(
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
              height: 100,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.05),
                border:
                    Border.all(color: Colors.red.withOpacity(0.3), width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Invalid Barcode',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          error.toString(),
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 10,
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
          padding: const EdgeInsets.all(16),
          backgroundColor: Colors.white,
          barcode: _selectedBarcode,
          data: _barcodeData,
          width: 300,
          height: 220,
        ),
      ),
    );
  }

  Widget _buildScannerView() {
    return Scaffold(
      backgroundColor: colorBlack,
      appBar: AppBar(
        title: const Text(
          'Scan Barcode',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _stopScanning,
        ),
      ),
      body: Stack(
        children: [
          scanner.MobileScanner(
            controller: _scannerController,
            onDetect: _handleBarcode,
          ),
          // Overlay with scanning instructions
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Point your camera at a barcode to scan it',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Bottom instruction bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
              child: const Center(
                child: Text(
                  'Make sure the barcode is clearly visible',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Barcode Generator',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Input Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Barcode Data',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorBlack,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _textController,
                        maxLines: 3,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Enter your barcode data here...',
                          hintStyle: TextStyle(
                            color: Colors.grey.withOpacity(0.6),
                          ),
                          prefixIcon: const Icon(
                            Icons.qr_code_2_rounded,
                            color: colorAccent,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: colorAccent.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: colorAccent,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.05),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Characters: ${_barcodeData.length}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (_barcodeData.isNotEmpty && !_hasError)
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 16,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Scan Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _startScanning,
                  icon: const Icon(Icons.qr_code_scanner, size: 24),
                  label: const Text(
                    'Scan Barcode',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Format Selector (only show when there's data)
              if (_barcodeData.isNotEmpty) _buildFormatSelector(),

              // Barcode Preview
              RepaintBoundary(
                key: _barcodeKey,
                child: _buildBarcodePreview(),
              ),

              const SizedBox(height: 24),

              // Generate Button
              if (_barcodeData.isNotEmpty && !_hasError)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _generateBarcodeImage,
                    icon: const Icon(Icons.download, size: 24),
                    label: const Text(
                      'Generate Image',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
