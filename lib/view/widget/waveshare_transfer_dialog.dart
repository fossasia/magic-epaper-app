import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/waveshare/services/waveshare_nfc_services.dart';

enum _TransferState { processing, readyToFlash, flashing, complete, error }

class WaveshareTransferDialog extends StatefulWidget {
  final img.Image image;
  final int ePaperSizeEnum;

  const WaveshareTransferDialog({
    super.key,
    required this.image,
    required this.ePaperSizeEnum,
  });

  static Future<void> show(
      BuildContext context, img.Image image, int ePaperSizeEnum) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          WaveshareTransferDialog(image: image, ePaperSizeEnum: ePaperSizeEnum),
    );
  }

  @override
  State<WaveshareTransferDialog> createState() =>
      _WaveshareTransferDialogState();
}

class _WaveshareTransferDialogState extends State<WaveshareTransferDialog>
    with TickerProviderStateMixin {
  _TransferState _currentState = _TransferState.processing;
  String? _message;
  Uint8List? _processedImageBytes;

  double _progress = 0.0;
  StreamSubscription? _progressSubscription;
  static const _progressChannel =
      EventChannel('org.fossasia.magicepaperapp/nfc_progress');

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _processImage();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressSubscription?.cancel();
    super.dispose();
  }

  Future<void> _processImage() async {
    setState(() {
      _currentState = _TransferState.processing;
    });
    await Future.delayed(const Duration(milliseconds: 200));
    final rotatedImage = img.copyRotate(widget.image, angle: 90);
    _processedImageBytes = Uint8List.fromList(img.encodePng(rotatedImage));
    setState(() {
      _currentState = _TransferState.readyToFlash;
    });
  }

  Future<void> _flashImage() async {
    if (_processedImageBytes == null) return;

    setState(() {
      _currentState = _TransferState.flashing;
    });

    _progressSubscription =
        _progressChannel.receiveBroadcastStream().listen((progress) {
      if (progress is int && mounted) {
        setState(() {
          _progress = progress / 100.0;
        });
      }
    });

    final services = WaveShareNfcServices();
    try {
      final result = await services.flashImage(
          _processedImageBytes!, widget.ePaperSizeEnum);
      setState(() {
        _message = result ?? 'Transfer complete!';
        _currentState = _TransferState.complete;
      });
    } on PlatformException catch (e) {
      setState(() {
        _message = "Transfer failed: ${e.message}";
        _currentState = _TransferState.error;
      });
    } finally {
      _progressSubscription?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_currentState) {
      case _TransferState.processing:
        return _buildStateColumn(
            key: 'processing',
            icon: Icons.hourglass_empty,
            color: Colors.blue,
            title: "Processing Image...",
            child: const CircularProgressIndicator());
      case _TransferState.readyToFlash:
        return _buildStateColumn(
          key: 'ready',
          icon: Icons.nfc,
          color: colorPrimary,
          title: "Ready to Flash",
          child: Column(
            children: [
              const Text(
                "Image processed successfully.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) =>
                    Transform.scale(scale: _pulseAnimation.value, child: child),
                child: const Icon(Icons.nfc, size: 60, color: colorPrimary),
              ),
              const SizedBox(height: 24),
              const Text(
                "Tap below and hold your phone near the display.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _flashImage,
                child: const Text("Start Flashing"),
              )
            ],
          ),
        );
      case _TransferState.flashing:
        return _buildStateColumn(
            key: 'flashing',
            icon: Icons.nfc,
            color: colorPrimary,
            title: "Flashing...",
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: _progress,
                  minHeight: 10,
                  backgroundColor: Colors.grey.shade300,
                  color: colorPrimary,
                ),
                const SizedBox(height: 12),
                Text("${(_progress * 100).toInt()}%"),
                const SizedBox(height: 20),
                const Text(
                  "Keep your phone still.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ));
      case _TransferState.complete:
        return _buildStateColumn(
          key: 'complete',
          icon: Icons.check_circle,
          color: Colors.green,
          title: "Success!",
          child: Column(
            children: [
              Text(_message ?? "Transfer complete!",
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Done"),
              )
            ],
          ),
        );
      case _TransferState.error:
        return _buildStateColumn(
          key: 'error',
          icon: Icons.error,
          color: Colors.red,
          title: "Error",
          child: Column(
            children: [
              Text(_message ?? "An unknown error occurred.",
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Close"),
              )
            ],
          ),
        );
    }
  }

  Widget _buildStateColumn({
    required String key,
    required IconData icon,
    required Color color,
    required String title,
    required Widget child,
  }) {
    return Column(
      key: ValueKey(key),
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 40, color: color),
        const SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 24),
        child,
      ],
    );
  }
}
