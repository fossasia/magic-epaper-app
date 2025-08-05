import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:magic_epaper_app/util/epd/display_device.dart';
import 'package:magic_epaper_app/util/epd/driver/waveform.dart';
import 'package:magic_epaper_app/util/image_processing/image_processing.dart';
import 'package:magic_epaper_app/waveshare/services/waveshare_nfc_services.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class WaveshareNfcDisplay extends DisplayDevice {
  final int ePaperSizeEnum;

  WaveshareNfcDisplay({required this.ePaperSizeEnum});

  @override
  List<Color> get colors => [Colors.black, Colors.white];

  @override
  List<img.Image Function(img.Image)> get processingMethods => [
        ImageProcessing.bwFloydSteinbergDither,
        ImageProcessing.bwFalseFloydSteinbergDither,
        ImageProcessing.bwStuckiDither,
        ImageProcessing.bwAtkinsonDither,
        ImageProcessing.bwHalftoneDither,
        ImageProcessing.bwThreshold,
      ];

  @override
  Future<void> transfer(BuildContext context, img.Image image,
      {Waveform? waveform}) async {
    Fluttertoast.showToast(msg: "Processing image...");

    final WaveShareNfcServices services = WaveShareNfcServices();
    final img.Image rotatedImage = img.copyRotate(image, angle: 90);

    final Uint8List processedImageBytes =
        Uint8List.fromList(img.encodePng(rotatedImage));

    Fluttertoast.showToast(
        msg: "Image processed. Hold phone near the display to flash.",
        toastLength: Toast.LENGTH_LONG);

    final String? result =
        await services.flashImage(processedImageBytes, ePaperSizeEnum);

    Fluttertoast.showToast(
      msg: result ?? 'Transfer complete!',
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
