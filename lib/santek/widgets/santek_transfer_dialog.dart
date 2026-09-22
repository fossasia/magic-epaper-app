import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/santek/services/santek_nfc_services.dart';

AppLocalizations get _appLocalizations => getIt.get<AppLocalizations>();

enum _TransferState { waitingForNfc, flashing, complete, error }

class SantekTransferDialog extends StatefulWidget {
  final img.Image image;

  const SantekTransferDialog({super.key, required this.image});

  static Future<void> show(BuildContext context, img.Image image) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SantekTransferDialog(image: image),
    );
  }

  @override
  State<SantekTransferDialog> createState() => _SantekTransferDialogState();
}

class _SantekTransferDialogState extends State<SantekTransferDialog>
    with TickerProviderStateMixin {
  _TransferState _currentState = _TransferState.waitingForNfc;
  String? _message;
  double _progress = 0.0;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _flash();
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
    super.dispose();
  }

  Future<void> _flash() async {
    try {
      await SantekNfcServices().flashImage(
        widget.image,
        onProgress: (progress) {
          if (mounted) {
            setState(() {
              _currentState = _TransferState.flashing;
              _progress = progress / 100.0;
            });
          }
        },
      );
      if (mounted) {
        setState(() {
          _currentState = _TransferState.complete;
          _message = _appLocalizations.transferCompleteMessage;
        });
      }
    } on PlatformException catch (e) {
      if (mounted) {
        setState(() {
          _currentState = _TransferState.error;
          _message = e.message ?? _appLocalizations.unknownErrorOccurred;
        });
      }
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
      case _TransferState.waitingForNfc:
        return _buildStateColumn(
          key: 'waiting',
          icon: Icons.nfc,
          color: colorPrimary,
          title: 'Ready to Transfer',
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) =>
                    Transform.scale(scale: _pulseAnimation.value, child: child),
                child: const Icon(Icons.nfc, size: 60, color: colorPrimary),
              ),
              const SizedBox(height: 24),
              const Text(
                'Hold your phone near the display to begin.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      case _TransferState.flashing:
        return _buildStateColumn(
          key: 'flashing',
          icon: Icons.nfc,
          color: colorPrimary,
          title: _appLocalizations.flashing,
          child: Column(
            children: [
              LinearProgressIndicator(
                value: _progress,
                minHeight: 10,
                backgroundColor: Colors.grey.shade300,
                color: colorPrimary,
              ),
              const SizedBox(height: 12),
              Text('${(_progress * 100).toInt()}%'),
              const SizedBox(height: 20),
              Text(
                _appLocalizations.keepPhoneStill,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      case _TransferState.complete:
        return _buildStateColumn(
          key: 'complete',
          icon: Icons.check_circle,
          color: Colors.green,
          title: _appLocalizations.success,
          child: Column(
            children: [
              Text(_message ?? _appLocalizations.transferCompleteMessage,
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(_appLocalizations.done),
              ),
            ],
          ),
        );
      case _TransferState.error:
        return _buildStateColumn(
          key: 'error',
          icon: Icons.error,
          color: Colors.red,
          title: _appLocalizations.error,
          child: Column(
            children: [
              Text(_message ?? _appLocalizations.unknownErrorOccurred,
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(_appLocalizations.close),
              ),
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
