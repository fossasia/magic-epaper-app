import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/constants/asset_paths.dart';
import 'package:magicepaperapp/util/epd/display_device.dart';
import 'package:magicepaperapp/util/epd/driver/waveform.dart';
import 'package:magicepaperapp/util/epd/gicisky/gicisky_ble_protocol.dart';
import 'package:magicepaperapp/util/epd/gicisky/gicisky_encoder.dart';
import 'package:magicepaperapp/util/image_processing/image_processing.dart';
import 'package:magicepaperapp/view/widget/transfer_progress_dialog.dart';

/// Experimental support for ATC GICISKY / Picksmart BLE electronic shelf labels.
///
/// Primary target: 2.1" 250x122 BWR model (common Picksmart tag).
/// Protocol based on reverse engineering by atc1441 and the gicisky-tag project.
///
/// Requires Bluetooth permissions and a real device for verification.
class Gicisky250x122Bwr extends DisplayDevice {
  @override
  String get name => 'Gicisky / Picksmart 2.1" BWR (BLE)';

  @override
  String get modelId => 'GICISKY-250x122-BWR';

  @override
  String get imgPath => ImageAssets.waveshare2_13; // reuse similar aspect

  @override
  int get width => 250;

  @override
  int get height => 122;

  @override
  List<Color> get colors => [Colors.white, Colors.black, Colors.red];

  @override
  List<String>? get displayChips => ['Gicisky / Picksmart BLE ESL'];

  @override
  List<ImageProcessingMethod> get processingMethods => [
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

  @override
  Future<void> transfer(
    BuildContext context,
    img.Image image, {
    Waveform? waveform,
  }) async {
    if (!context.mounted) return;

    await TransferProgressDialog.show(
      context: context,
      finalImg: image,
      transferFunction: (imgData, onProgress, onTagDetected) async {
        onProgress(0.0, 'Scanning for Gicisky / Picksmart tag...');

        // Ensure Bluetooth is on
        if (await FlutterBluePlus.isSupported == false) {
          throw Exception('Bluetooth is not supported on this device');
        }

        final adapterState = await FlutterBluePlus.adapterState.first;
        if (adapterState != BluetoothAdapterState.on) {
          throw Exception('Please turn on Bluetooth');
        }

        BluetoothDevice? target;
        final subscription = FlutterBluePlus.onScanResults.listen((results) {
          for (final r in results) {
            final name = r.device.platformName.toUpperCase();
            final adv = r.advertisementData;
            // Picksmart often advertises as PICKSMART or NEMR...
            // Manufacturer ID 20563 (0x5053) is used by some tags.
            final isCandidate = name.startsWith('PICKSMART') ||
                name.startsWith('NEMR') ||
                name.startsWith('GICISKY') ||
                adv.manufacturerData.keys.contains(20563) ||
                r.device.remoteId.str.toUpperCase().startsWith('FF:FF');
            if (isCandidate) {
              target = r.device;
              FlutterBluePlus.stopScan();
              break;
            }
          }
        });

        await FlutterBluePlus.startScan(timeout: const Duration(seconds: 12));
        await Future.delayed(const Duration(seconds: 12));
        await subscription.cancel();
        await FlutterBluePlus.stopScan();

        if (target == null) {
          throw Exception(
            'No Gicisky / Picksmart tag found. '
            'Make sure the tag is powered and in range.',
          );
        }

        onTagDetected();
        onProgress(0.1, 'Encoding image...');

        final encoded = GiciskyEncoder.encode(
          imgData,
          width: width,
          height: height,
        );

        final protocol = GiciskyBleProtocol(
          device: target!,
          imageData: encoded,
          onProgress: onProgress,
        );

        await protocol.transfer();
      },
      colorAccent: Colors.red,
    );
  }
}
