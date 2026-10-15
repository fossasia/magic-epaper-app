import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/constants/asset_paths.dart';
import 'package:magicepaperapp/utils/epd/display_device.dart';
import 'package:magicepaperapp/utils/epd/driver/waveform.dart';
import 'package:magicepaperapp/utils/image_processing/image_processing.dart';
import 'package:magicepaperapp/view/widgets/oepl_transfer_dialog.dart';

import 'brand.dart';

const List<ImageProcessingMethod> _bwMethods = [
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

const List<ImageProcessingMethod> _bwrMethods = [
  ImageProcessing.bwrFloydSteinbergDither,
  ImageProcessing.bwrFalseFloydSteinbergDither,
  ImageProcessing.bwrStuckiDither,
  ImageProcessing.bwrTriColorAtkinsonDither,
  ImageProcessing.bwrHalftone,
  ImageProcessing.bwrThreshold,
  ImageProcessing.bwrBayerDither,
  ImageProcessing.bwrSierra2Dither,
  ImageProcessing.bwrBurkesDither,
];

const List<ImageProcessingMethod> _bwryMethods = [
  ImageProcessing.bwryFloydSteinbergDither,
  ImageProcessing.bwryFalseFloydSteinbergDither,
  ImageProcessing.bwryStuckiDither,
  ImageProcessing.bwryTriColorAtkinsonDither,
  ImageProcessing.bwryHalftone,
  ImageProcessing.bwryThreshold,
  ImageProcessing.bwryBayerDither,
  ImageProcessing.bwrySierra2Dither,
  ImageProcessing.bwryBurkesDither,
];

/// Base class for Telink badges running ATC_BLE_OEPL, transferred over BLE.
///
/// [width] x [height] of each model is the orientation the app edits in
/// (landscape, like the other displays). The badge usually wants the portrait
/// version: the transfer dialog reads the real size from the badge and rotates
/// by [quarterTurns] (1 = clockwise, 3 = counter-clockwise) when swapped.
abstract class OeplBleDisplay extends DisplayDevice {
  int get quarterTurns => 3;

  @override
  Brand get brand => Brand.openEpaperLink;

  @override
  List<String>? get displayChips => null;

  @override
  bool get isBeta => true;

  // TODO: add one asset per model, like ImageAssets.GDEY0154D67.
  @override
  String get imgPath => ImageAssets.customExport;

  @override
  List<ImageProcessingMethod> get processingMethods {
    if (colors.length >= 4) return _bwryMethods;
    if (colors.length == 3) return _bwrMethods;
    return _bwMethods;
  }

  @override
  Future<void> transfer(
      BuildContext context,
      img.Image image, {
        Waveform? waveform,
      }) {
    return OeplTransferDialog.show(context, image: image, display: this);
  }
}

/// OEPL BLE 2.9" BWRY (296x128)
class OeplBle29Bwry extends OeplBleDisplay {
  @override
  int get width => 296;
  @override
  int get height => 128;
  @override
  String get name => 'OEPL BLE 2.9" 4-Color (BWRY)';
  @override
  String get modelId => 'OEPL_BLE_29_BWRY';
  @override
  List<Color> get colors =>
      [Colors.white, Colors.black, Colors.red, Colors.yellow];
}

/// OEPL BLE 2.9" BWR (296x128)
class OeplBle29Bwr extends OeplBleDisplay {
  @override
  int get width => 296;
  @override
  int get height => 128;
  @override
  String get name => 'OEPL BLE 2.9" 3-Color (BWR)';
  @override
  String get modelId => 'OEPL_BLE_29_BWR';
  @override
  List<Color> get colors => [Colors.white, Colors.black, Colors.red];
}

/// OEPL BLE 2.9" B/W (296x128)
class OeplBle29Bw extends OeplBleDisplay {
  @override
  int get width => 296;
  @override
  int get height => 128;
  @override
  String get name => 'OEPL BLE 2.9" B/W';
  @override
  String get modelId => 'OEPL_BLE_29_BW';
  @override
  List<Color> get colors => [Colors.white, Colors.black];
}

/// OEPL BLE 3.5" BWRY (384x184)
/// Size taken from the web uploader default (184x384), not confirmed.
class OeplBle35Bwry extends OeplBleDisplay {
  @override
  int get width => 384;
  @override
  int get height => 184;
  @override
  String get name => 'OEPL BLE 3.5" 4-Color (BWRY)';
  @override
  String get modelId => 'OEPL_BLE_35_BWRY';
  @override
  List<Color> get colors =>
      [Colors.white, Colors.black, Colors.red, Colors.yellow];
}

/// OEPL BLE 2.13" BWRY (250x128). The badge reports 128x250 (portrait).
class OeplBle213Bwry extends OeplBleDisplay {
  @override
  int get width => 250;
  @override
  int get height => 128;
  @override
  String get name => 'OEPL BLE 2.13" 4-Color (BWRY)';
  @override
  String get modelId => 'OEPL_BLE_213_BWRY';
  @override
  List<Color> get colors =>
      [Colors.white, Colors.black, Colors.red, Colors.yellow];
}

/// OEPL BLE 2.13" BWR (250x128). The badge reports 128x250 (portrait).
class OeplBle213Bwr extends OeplBleDisplay {
  @override
  int get width => 250;
  @override
  int get height => 128;
  @override
  String get name => 'OEPL BLE 2.13" 3-Color (BWR)';
  @override
  String get modelId => 'OEPL_BLE_213_BWR';
  @override
  bool get isBeta => false;
  @override
  List<Color> get colors => [Colors.white, Colors.black, Colors.red];
}

/// OEPL BLE 2.13" B/W (250x128). The badge reports 128x250 (portrait).
class OeplBle213Bw extends OeplBleDisplay {
  @override
  int get width => 250;
  @override
  int get height => 128;
  @override
  String get name => 'OEPL BLE 2.13" B/W';
  @override
  String get modelId => 'OEPL_BLE_213_BW';
  @override
  List<Color> get colors => [Colors.white, Colors.black];
}