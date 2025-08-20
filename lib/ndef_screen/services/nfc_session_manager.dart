import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:magicepaperapp/constants/string_constants.dart';

class NFCSessionManager {
  static Future<void> finishSession({String? iosMessage}) async {
    try {
      if (iosMessage != null) {
        await FlutterNfcKit.finish(iosAlertMessage: iosMessage);
      } else {
        await FlutterNfcKit.finish();
      }
    } catch (e) {
      debugPrint('${StringConstants.errorFinishingNfcSession}$e');
      try {
        await FlutterNfcKit.finish();
      } catch (e2) {
        debugPrint('${StringConstants.secondaryCleanupAlsoFailed}$e2');
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
          StringConstants.multipleTagsFoundPleaseSelectOne,
      iosAlertMessage: iosAlertMessage ?? StringConstants.scanYourNfcTagDefault,
    );
  }
}
