import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/constants/asset_paths.dart';
import 'package:magicepaperapp/util/epd/display_device.dart';
import 'package:magicepaperapp/util/epd/epd.dart';
import 'package:magicepaperapp/util/epd/driver/driver.dart';
import 'package:magicepaperapp/util/epd/driver/uc8253.dart';
import 'package:magicepaperapp/util/epd/driver/waveform.dart';
import 'package:magicepaperapp/view/widget/waveshare_transfer_dialog.dart';
import 'package:magicepaperapp/util/image_processing/image_processing.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/util/epd/waveshare_displays.dart';

enum DisplaySdk { fossasia, waveshare }

class CustomDisplayDevice extends DisplayDevice {
  @override
  final String name;
  @override
  final String modelId;
  @override
  final int width;
  @override
  final int height;
  @override
  final List<Color> colors;
  final DisplaySdk sdk;

  CustomDisplayDevice({
    required this.name,
    required this.modelId,
    required this.width,
    required this.height,
    required this.colors,
    required this.sdk,
  });

  @override
  String get imgPath => ImageAssets.customExport;

  @override
  List<String>? get displayChips =>
      sdk == DisplaySdk.fossasia ? ['FOSSASIA Hardware'] : ['Waveshare SDK'];

  @override
  List<img.Image Function(img.Image)> get processingMethods {
    final palette = img.PaletteUint8(colors.length, 3);
    for (int i = 0; i < colors.length; i++) {
      palette.setRgb(i, colors[i].red, colors[i].green, colors[i].blue);
    }

    return [
      (img.Image i) => ImageProcessing.customFloydSteinbergDither(i, palette),
      (img.Image i) =>
          ImageProcessing.customFalseFloydSteinbergDither(i, palette),
      (img.Image i) => ImageProcessing.customStuckiDither(i, palette),
      (img.Image i) => ImageProcessing.customAtkinsonDither(i, palette),
      (img.Image i) => ImageProcessing.customHalftoneDither(i, palette),
      (img.Image i) => ImageProcessing.customThreshold(i, palette),
    ];
  }

  @override
  Future<void> transfer(BuildContext context, img.Image image,
      {Waveform? waveform}) async {
    if (sdk == DisplaySdk.waveshare) {
      int index = 0; // default (usually 2.13inch)
      // Try to find a matching waveshare display by dimensions to pick the correct SDK index
      final wsDisplays = [
        Waveshare2in13(),
        Waveshare2in9(),
        Waveshare4in2(),
        Waveshare7in5(),
        Waveshare7in5HD(),
        Waveshare2in7(),
        Waveshare2in9b(),
      ];

      for (var d in wsDisplays) {
        if (d.width == width && d.height == height) {
          index = d.ePaperSizeEnum;
          break;
        }
      }
      return WaveshareTransferDialog.show(context, image, index);
    } else {
      return _FossasiaEpdWrapper(this)
          .transfer(context, image, waveform: waveform);
    }
  }
}

class _FossasiaEpdWrapper extends Epd {
  final CustomDisplayDevice customDevice;
  _FossasiaEpdWrapper(this.customDevice);

  @override
  String get name => customDevice.name;
  @override
  String get modelId => customDevice.modelId;
  @override
  String get imgPath => customDevice.imgPath;
  @override
  int get width => customDevice.width;
  @override
  int get height => customDevice.height;
  @override
  List<Color> get colors => customDevice.colors;

  @override
  Driver get controller => Uc8253() as Driver;

  @override
  List<img.Image Function(img.Image)> get processingMethods =>
      customDevice.processingMethods;
}

class CustomPlaceholder extends DisplayDevice {
  final AppLocalizations _l10n;

  CustomPlaceholder(this._l10n);

  @override
  String get name => _l10n.custom;
  @override
  String get modelId => 'CUSTOM';
  @override
  String get imgPath => ImageAssets.customExport;
  @override
  int get width => 0;
  @override
  int get height => 0;
  @override
  List<Color> get colors => [Colors.white, Colors.black];
  @override
  List<String>? get displayChips => [_l10n.configureManually];
  @override
  List<img.Image Function(img.Image)> get processingMethods => [];
  @override
  Future<void> transfer(BuildContext context, img.Image image,
      {Waveform? waveform}) async {}
}
