import 'package:flutter/services.dart' show PlatformException;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_ui/material_ui.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/constants/asset_paths.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/theme/colors.dart';
import 'package:magicepaperapp/utils/epd/brand.dart';
import 'package:magicepaperapp/utils/epd/display_device.dart';
import 'package:magicepaperapp/utils/epd/driver/waveform.dart';
import 'package:magicepaperapp/utils/image_processing/image_processing.dart';
import 'package:magicepaperapp/view/widgets/transfer_progress_dialog.dart';

import 'vidabay_protocol.dart';

AppLocalizations get _l => getIt.get<AppLocalizations>();

/// VidaBay "Snap" NFC e-paper display: 2.6", 400 x 400,
/// black/white/yellow/red, battery-less.
class VidabaySnap extends DisplayDevice {
  @override
  int get width => 400;
  @override
  int get height => 400;
  @override
  String get name => 'VidaBay Snap 2.6" BWRY';
  @override
  String get modelId => 'vidabay-snap';
  @override
  String get imgPath => ImageAssets.vidabaySnap;
  @override
  List<Color> get colors =>
      [Colors.white, Colors.black, Colors.red, Colors.yellow];
  @override
  List<ImageProcessingMethod> get processingMethods => const [
        ImageProcessing.bwryFloydSteinbergDither,
        ImageProcessing.bwryFalseFloydSteinbergDither,
        ImageProcessing.bwryStuckiDither,
        ImageProcessing.bwryTriColorAtkinsonDither,
        ImageProcessing.bwryThreshold,
        ImageProcessing.bwryBayerDither,
        ImageProcessing.bwrySierra2Dither,
        ImageProcessing.bwryBurkesDither,
      ];
  @override
  bool get isBeta => true;
  @override
  Brand get brand => Brand.vidabay;
  @override
  List<String>? get displayChips => ['Fudan ISO 14443-4'];

  @override
  Future<void> transfer(BuildContext context, img.Image image,
      {Waveform? waveform}) async {
    if (!context.mounted) return;
    // The protocol reports progress 1.0 when the image data is sent; the
    // dialog then asks to keep the phone close while the panel refreshes.
    // The protocol keeps waiting for the refresh in the background and a
    // toast tells when the tag confirmed it, even if the dialog was already
    // closed. Progress callbacks and a late error are ignored then.
    var closed = false;
    try {
      await TransferProgressDialog.show(
        context: context,
        finalImg: image,
        transferFunction: (image, onProgress, onTagDetected) async {
          try {
            await VidabayProtocol().send(
              image,
              onProgress: (p, s) {
                if (!closed) onProgress(p, s);
              },
              onTagDetected: () {
                if (!closed) onTagDetected();
              },
            );
            Fluttertoast.showToast(msg: _l.transferCompleteMessage);
          } on PlatformException catch (e) {
            if (closed) return;
            if (e.code == '500') {
              throw VidabayException(_l.connectionLostDuringTransfer);
            }
            rethrow;
          } catch (_) {
            if (!closed) rethrow;
          }
        },
        colorAccent: colorAccent,
      );
    } finally {
      closed = true;
    }
  }
}
