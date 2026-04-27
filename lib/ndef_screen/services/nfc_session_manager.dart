import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:magicepaperapp/provider/locale_provider.dart';
import '../../util/app_logger.dart';


class NFCSessionManager {
  static Future<void> finishSession({String? iosMessage}) async {
    try {
      if (iosMessage != null) {
        await FlutterNfcKit.finish(iosAlertMessage: iosMessage);
      } else {
        await FlutterNfcKit.finish();
      }
    } catch (e) {
      AppLogger.error('${LocaleProvider.current!.errorFinishingNfcSession}$e');
      try {
        await FlutterNfcKit.finish();
      } catch (e2) {
        AppLogger.error('${LocaleProvider.current!.secondaryCleanupAlsoFailed}$e2');
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
          LocaleProvider.current!.multipleTagsFoundPleaseSelectOne,
      iosAlertMessage:
          iosAlertMessage ?? LocaleProvider.current!.scanYourNfcTagDefault,
    );
  }
}
