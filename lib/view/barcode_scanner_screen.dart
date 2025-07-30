import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobile_scanner/mobile_scanner.dart' as scanner;
import 'package:barcode_widget/barcode_widget.dart';
import 'package:magic_epaper_app/constants/color_constants.dart';
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

  @override
  void dispose() {
    _textController.dispose();
    _scannerController?.dispose();
    super.dispose();
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Format: ${_selectedBarcode.name}',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: DropdownButton<String>(
              value: _selectedBarcode.name,
              isExpanded: true,
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
            ),
          ),
        ],
      ),
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
        child: const Center(
          child: Text(
            'Enter or scan barcode data',
            style: TextStyle(color: Colors.grey),
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
        return Container(
          width: 240,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.red[100],
            border: Border.all(color: colorPrimary),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              error.toString(),
              style: const TextStyle(color: colorPrimary),
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
        title: const Text('Scan Barcode'),
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
              child: const Center(
                child: Text(
                  'Point camera at barcode to scan',
                  style: TextStyle(color: colorWhite, fontSize: 16),
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
        title: const Text('Barcode Generator'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: colorAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Barcode Data',
                hintText: 'Enter barcode data or scan',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.qr_code),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _startScanning,
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan Barcode'),
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
                  child: const Text('Generate Image'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
