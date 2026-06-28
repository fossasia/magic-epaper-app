import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

Future<String?> scanCode(BuildContext context) {
  return Navigator.of(context).push<String>(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => const BarcodeScannerScreen(),
    ),
  );
}

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  final ImagePicker _picker = ImagePicker();
  bool _handled = false;

  void _onDetect(BarcodeCapture capture) {
    if (_handled || capture.barcodes.isEmpty) return;
    _finish(capture);
  }

  void _finish(BarcodeCapture capture) {
    if (_handled) return;
    final barcode = capture.barcodes.first;
    final value = barcode.displayValue ?? barcode.rawValue ?? '';
    if (value.isEmpty) return;

    _handled = true;
    Navigator.of(context).pop(value);
  }

  Future<void> _scanFromGallery() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final result = await _controller.analyzeImage(picked.path);
    if (!mounted) return;

    if (result != null && result.barcodes.isNotEmpty) {
      _finish(result);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(appLocalizations.noCodeFound)),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBlack,
      appBar: AppBar(
        title: Text(appLocalizations.scanCode),
        backgroundColor: colorAccent,
        foregroundColor: colorWhite,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              border: Border.all(color: colorWhite, width: 3),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 80,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  appLocalizations.pointCameraAtCode,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: colorWhite, fontSize: 16),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _scanFromGallery,
                  icon: const Icon(Icons.photo_library_outlined,
                      color: colorWhite),
                  label: Text(
                    appLocalizations.scanFromGallery,
                    style: const TextStyle(color: colorWhite),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: colorWhite),
                    backgroundColor: const Color.fromRGBO(0, 0, 0, 0.4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
