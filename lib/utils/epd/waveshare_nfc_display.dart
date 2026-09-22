import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/utils/epd/display_device.dart';
import 'package:magicepaperapp/utils/epd/driver/waveform.dart';
import 'package:magicepaperapp/utils/image_processing/image_processing.dart';
import 'package:magicepaperapp/view/widgets/waveshare_transfer_dialog.dart';

abstract class WaveshareNfcDisplay extends DisplayDevice {
  final int ePaperSizeEnum;

  WaveshareNfcDisplay({required this.ePaperSizeEnum});

  @override
  List<Color> get colors => [Colors.white, Colors.black];

  @override
  List<ImageProcessingMethod> get processingMethods => [
        ImageProcessing.bwFloydSteinbergDither,
        ImageProcessing.bwFalseFloydSteinbergDither,
        ImageProcessing.bwStuckiDither,
        ImageProcessing.bwAtkinsonDither,
        ImageProcessing.bwHalftoneDither,
        ImageProcessing.bwThreshold,
        ImageProcessing.bwBayerDither,
        ImageProcessing.bwSierra2Dither,
        ImageProcessing.bwBurkesDither,
      ];

  @override
  Future<void> transfer(BuildContext context, img.Image image,
      {Waveform? waveform}) async {
    return WaveshareTransferDialog.show(context, image, ePaperSizeEnum);
  }

  @override
  List<String>? get displayChips => null;
}
