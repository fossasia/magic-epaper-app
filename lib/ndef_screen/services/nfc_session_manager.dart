import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import '../../util/app_logger.dart';

AppLocalizations appLocalizations = getIt.get<AppLocalizations>();

class NFCSessionManager {
  static Future<void> finishSession({String? iosMessage}) async {
    try {
      if (iosMessage != null) {
        await FlutterNfcKit.finish(iosAlertMessage: iosMessage);
      } else {
        await FlutterNfcKit.finish();
      }
    } catch (e) {
      AppLogger.error('${appLocalizations.errorFinishingNfcSession}$e');
      try {
        await FlutterNfcKit.finish();
      } catch (e2) {
        AppLogger.error('${appLocalizations.secondaryCleanupAlsoFailed}$e2');
      }
    }
  }

  static Future<NFCTag> pollForTag({
    Duration timeout = const Duration(seconds: 10),
    String? iosMultipleTagMessage,
    String? iosAlertMessage,
  }) async {
    return await FlutterNfcKit.poll(
      timeout: timeout,
      iosMultipleTagMessage: iosMultipleTagMessage ??
          appLocalizations.multipleTagsFoundPleaseSelectOne,
      iosAlertMessage:
          iosAlertMessage ?? appLocalizations.scanYourNfcTagDefault,
    );
  }
}
