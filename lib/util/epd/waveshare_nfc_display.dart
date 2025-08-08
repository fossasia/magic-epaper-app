import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:magic_epaper_app/util/epd/display_device.dart';
import 'package:magic_epaper_app/util/epd/driver/waveform.dart';
import 'package:magic_epaper_app/util/image_processing/image_processing.dart';
import 'package:magic_epaper_app/view/widget/waveshare_transfer_dialog.dart';

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
    return WaveshareTransferDialog.show(context, image, ePaperSizeEnum);
  }
}
