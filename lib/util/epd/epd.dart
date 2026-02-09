import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/util/epd/display_device.dart';
import 'package:magicepaperapp/util/epd/driver/waveform.dart';
import 'package:magicepaperapp/util/protocol.dart';
import 'package:magicepaperapp/view/widget/transfer_progress_dialog.dart';
import 'driver/driver.dart';

abstract class Epd extends DisplayDevice {
  Driver get controller;
  String get driverName => controller.driverName;
  @override
  List<String>? get displayChips => ['FOSSASIA Hardware'];

  @override
  Future<void> transfer(BuildContext context, img.Image image,
      {Waveform? waveform}) async {
    if (!context.mounted) return;

    final rotatedImage = img.copyRotate(image, angle: 90);
    await TransferProgressDialog.show(
      context: context,
      finalImg: rotatedImage,
      transferFunction: (img, onProgress, onTagDetected) async {
        if (!context.mounted) return;
        final currentEpdDevice = this;
        return await Protocol(epd: currentEpdDevice).writeImages(
          img,
          onProgress: onProgress,
          onTagDetected: onTagDetected,
          waveform: waveform,
        );
      },
      colorAccent: colorAccent,
    );
  }
}
