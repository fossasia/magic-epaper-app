import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/util/epd/goodisplay_nfc_protocol.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

class GoodisplayTransferDialog extends StatefulWidget {
  final img.Image image;
  final int width;
  final int height;

  const GoodisplayTransferDialog({
    super.key,
    required this.image,
    required this.width,
    required this.height,
  });

  static Future<void> show(
    BuildContext context,
    img.Image image, {
    required int width,
    required int height,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GoodisplayTransferDialog(
        image: image,
        width: width,
        height: height,
      ),
    );
  }

  @override
  State<GoodisplayTransferDialog> createState() => _GoodisplayTransferDialogState();
}

class _GoodisplayTransferDialogState extends State<GoodisplayTransferDialog> {
  double _progress = 0.0;
  String _status = '';
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _startTransmission();
  }

  Future<void> _startTransmission() async {
    setState(() {
      _progress = 0.0;
      _status = appLocalizations.waitingForNfcTag;
      _isError = false;
    });

    try {
      final protocol = GoodisplayNfcProtocol();
      await protocol.sendImage(
        image: widget.image,
        width: widget.width,
        height: widget.height,
        onProgress: (progress, status) {
          if (mounted) {
            setState(() {
              _progress = progress;
              _status = status;
            });
          }
        },
      );

      if (mounted) {
        await Future.delayed(const Duration(milliseconds: 600));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isError = true;
          _status = e.toString().replaceAll('Exception: ', '');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.radiusL)),
      title: Text(
        'Goodisplay NFC Transfer',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: Dimens.fontSizeL),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(
            value: _progress > 0 ? _progress : null,
            backgroundColor: grey200,
            valueColor: AlwaysStoppedAnimation<Color>(_isError ? Colors.red : colorAccent),
          ),
          const SizedBox(height: Dimens.spacingL),
          Text(
            _status,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Dimens.fontSizeM,
              color: _isError ? Colors.red : colorBlack,
            ),
          ),
        ],
      ),
      actions: [
        if (_isError)
          TextButton(
            onPressed: _startTransmission,
            child: Text(appLocalizations.retry, style: const TextStyle(color: colorAccent)),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(appLocalizations.cancel),
        ),
      ],
    );
  }
}