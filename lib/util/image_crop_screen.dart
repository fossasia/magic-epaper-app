import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';

Future<Uint8List?> showImageCropScreen(
  BuildContext context,
  Uint8List imageBytes, {
  double? aspectRatio,
}) {
  return Navigator.of(context).push<Uint8List>(
    MaterialPageRoute(
      builder: (_) => ImageCropScreen(
        imageBytes: imageBytes,
        aspectRatio: aspectRatio,
      ),
    ),
  );
}

class ImageCropScreen extends StatefulWidget {
  final Uint8List imageBytes;
  final double? aspectRatio;

  const ImageCropScreen({
    super.key,
    required this.imageBytes,
    this.aspectRatio,
  });

  @override
  State<ImageCropScreen> createState() => _ImageCropScreenState();
}

class _ImageCropScreenState extends State<ImageCropScreen> {
  final CropController _controller = CropController();
  bool _isCropping = false;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: colorAccent,
        foregroundColor: Colors.white,
        title: Text(appLocalizations.cropImage),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _isCropping
                ? null
                : () {
                    setState(() => _isCropping = true);
                    _controller.crop();
                  },
          ),
        ],
      ),
      body: Stack(
        children: [
          Crop(
            controller: _controller,
            image: widget.imageBytes,
            aspectRatio: widget.aspectRatio,
            interactive: true,
            baseColor: Colors.black,
            maskColor: Colors.black.withValues(alpha: 0.6),
            onCropped: (result) {
              switch (result) {
                case CropSuccess(:final croppedImage):
                  if (mounted) Navigator.of(context).pop(croppedImage);
                case CropFailure():
                  if (mounted) setState(() => _isCropping = false);
              }
            },
          ),
          if (_isCropping)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
