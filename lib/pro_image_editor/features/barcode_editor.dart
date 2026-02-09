import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
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
  Barcode _selectedBarcode = Barcode.qrCode();
  String _barcodeData = '';
  bool _showScanner = false;
  scanner.MobileScannerController? _scannerController;

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

  @override
  void initState() {
    super.initState();
    _barcodeController.addListener(() {
      setState(() {
        _barcodeData = _barcodeController.text;
      });
    });
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _scannerController?.dispose();
    super.dispose();
  }

  String? _validateBarcodeData(String data, Barcode barcode) {
    if (data.isEmpty) {
      return null;
    }
    if (barcode.charSet.isEmpty || barcode.name == 'QR-Code') {
      // No character validation needed
    } else {
      final allowedChars = barcode.charSet.toSet();
      for (final rune in data.runes) {
        if (!allowedChars.contains(rune)) {
          final char = String.fromCharCode(rune);
          final rules = barcodeFormatToSupportedChars[_selectedBarcode.name];
          return "Invalid character '$char' \nSupported characters: ${rules ?? 'Please check barcode rules'}";
        }
      }
    }
    if (data.length < barcode.minLength) {
      return 'Data too short for ${barcode.name}. Minimum length is ${barcode.minLength}.';
    }
    if (barcode.maxLength < 10000 && data.length > barcode.maxLength) {
      return 'Data too long for ${barcode.name}. Maximum length is ${barcode.maxLength}.';
    }
    return null;
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
        return Barcode.qrCode();
    }
  }

  void _handleBarcode(scanner.BarcodeCapture barcodes) {
    if (mounted && barcodes.barcodes.isNotEmpty) {
      final barcode = barcodes.barcodes.first;
      final value = barcode.displayValue ?? barcode.rawValue ?? '';

      setState(() {
        _barcodeController.text = value;
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

  void _addBarcodeLayer() {
    final validationError =
        _validateBarcodeData(_barcodeData, _selectedBarcode);
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validationError),
          backgroundColor: Colors.red,
        ),
      );
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
      initialValue: _selectedBarcode.name,
      decoration: const InputDecoration(
        labelText: 'Barcode Format',
        border: OutlineInputBorder(),
      ),
      items: availableFormats.entries
          .map((entry) => DropdownMenuItem(
                value: entry.value.name,
                child: Text(entry.key),
              ))
          .toList(),
      onChanged: (newBarcodeName) {
        if (newBarcodeName != null) {
          setModalState(() {
            _selectedBarcode = availableFormats.values.firstWhere(
              (barcode) => barcode.name == newBarcodeName,
              orElse: () => Barcode.qrCode(),
            );
          });
        }
      },
    );
  }

  Widget _buildBarcodePreviewWidget() {
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
            'Enter barcode data to see preview',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    final validationError =
        _validateBarcodeData(_barcodeData, _selectedBarcode);
    if (validationError != null) {
      return Container(
        width: double.infinity,
        height: 200,
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
                'Invalid Barcode',
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
                    validationError,
                    style: TextStyle(
                      color: Colors.red[600],
                      fontSize: 16,
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
    }

    return BarcodeWidget(
      style: const TextStyle(color: Colors.black),
      padding: const EdgeInsets.all(10),
      backgroundColor: Colors.white,
      barcode: _selectedBarcode,
      data: _barcodeData,
    );
  }

  Widget _buildScannerView() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode'),
        backgroundColor: colorAccent,
        foregroundColor: Colors.white,
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
                  'Point camera at barcode',
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

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Add Barcode',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _barcodeController,
            decoration: const InputDecoration(
              labelText: 'Barcode Data',
              hintText: 'Enter barcode data',
              prefixIcon: Icon(Icons.qr_code_2_rounded),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _barcodeData = value;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 4.0),
            child: Text(
              'Characters: ${_barcodeData.length}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
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
            ],
          ),
          const SizedBox(height: 20),
          StatefulBuilder(
            builder: (context, setModalState) =>
                _buildBarcodeFormatSelector(setModalState),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: _buildBarcodePreviewWidget(),
            ),
          ),
          const SizedBox(height: 20),
          if (_barcodeData.isNotEmpty &&
              _validateBarcodeData(_barcodeData, _selectedBarcode) == null)
            ElevatedButton(
              key: const Key('addBarcodeButton'),
              onPressed: _addBarcodeLayer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Add Barcode'),
            ),
        ],
      ),
    );
  }
}
