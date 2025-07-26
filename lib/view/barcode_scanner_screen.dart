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
  scanner.BarcodeFormat? _barcodeFormat;
  bool _showScanner = false;
  scanner.MobileScannerController? _scannerController;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        _barcodeData = _textController.text;
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
        _barcodeFormat = barcode.format;
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
        return Barcode.code128(); // Default fallback
    }
  }

  Future<void> _generateBarcodeImage() async {
    try {
      RenderRepaintBoundary boundary = _barcodeKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      img.Image? barcodeImage = img.decodeImage(pngBytes);
      if (barcodeImage == null) return;

      // Resize and rotate to fit the display
      img.Image resizedImage;
      if (barcodeImage.width > widget.width) {
        // If barcode is wider than the screen, rotate it
        resizedImage = img.copyRotate(barcodeImage, angle: 270);
        //resizedImage = img.copyResize(resizedImage, width: widget.width, height: widget.height);
      } else {
        resizedImage = img.copyResize(barcodeImage, width: widget.width, height: widget.height);
      }

      // Convert back to bytes and return
      final resultBytes = Uint8List.fromList(img.encodePng(resizedImage));
      Navigator.of(context).pop(resultBytes);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating barcode image: $e')),
      );
    }
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

    try {
      return BarcodeWidget(
        style: const TextStyle(color: Colors.black),
        padding: const EdgeInsets.all(10),
        backgroundColor: colorWhite,
        barcode: _getBarcodeType(_barcodeFormat),
        data: _barcodeData,
        width: 240,
        height: 120,
      );
    } catch (e) {
      return Container(
        width: 240,
        height: 120,
        decoration: BoxDecoration(
          color: Colors.red[100],
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'Invalid barcode data',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }
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
      backgroundColor: Colors.black,
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
                  style: TextStyle(color: Colors.white, fontSize: 16),
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
        backgroundColor: colorAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            
            // Text field for barcode data
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
            
            // Scan button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _startScanning,
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan Barcode'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Barcode preview
            const Text(
              'Barcode Preview:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            
            const SizedBox(height: 20),
            
            RepaintBoundary(
              key: _barcodeKey,
              child: Center(child: _buildBarcodePreview()),
            ),
            
            const Spacer(),
            
            // Save button (if needed for future functionality)
            if (_barcodeData.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _generateBarcodeImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
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
