import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/ndef_screen/models/nfc_operation_result.dart';
import 'package:magicepaperapp/ndef_screen/models/nfc_tag_info.dart';
import 'package:magicepaperapp/ndef_screen/services/ndef_record_parser.dart';
import 'package:magicepaperapp/ndef_screen/services/nfc_session_manager.dart';
import 'package:ndef/ndef.dart' as ndef;

AppLocalizations appLocalizations = getIt.get<AppLocalizations>();

class NFCOperationsService {
  static Future<NFCOperationResult> readNDEF() async {
    try {
      final tag = await NFCSessionManager.pollForTag(
        iosAlertMessage: appLocalizations.scanYourNfcTag,
      );

      final tagInfo = NFCTagInfo(
        type: tag.type.toString(),
        id: tag.id,
        ndefAvailable: tag.ndefAvailable,
        ndefWritable: tag.ndefWritable,
      );

      if (tag.ndefAvailable != true) {
        await NFCSessionManager.finishSession(
            iosMessage: appLocalizations.tagIsNotNdefCompatible);
        return NFCOperationResult.failure(
          error: appLocalizations.tagIsNotNdefCompatible,
          operationType: NFCOperationType.read,
          tagInfo: tagInfo,
        );
      }

      final records = await FlutterNfcKit.readNDEFRecords();
      await NFCSessionManager.finishSession(
          iosMessage: appLocalizations.readOperationCompleted);

      String message = '${tagInfo.toString()}\n\n';
      message += '${appLocalizations.ndefRecordsFound}${records.length}\n\n';

      if (records.isEmpty) {
        message += appLocalizations.theTagIsEmpty;
      } else {
        for (int i = 0; i < records.length; i++) {
          message += '${appLocalizations.record}${i + 1}:\n';
          message +=
              '${appLocalizations.type}${NDEFRecordParser.getRecordTypeString(records[i])}\n';
          message += '${appLocalizations.tnf}${records[i].tnf}\n';
          message +=
              '${appLocalizations.content}${NDEFRecordParser.getRecordInfo(records[i])}\n\n';
        }
      }

      return NFCOperationResult.success(
        message: message,
        operationType: NFCOperationType.read,
        tagInfo: tagInfo,
        records: records,
      );
    } catch (e) {
      await NFCSessionManager.finishSession();
      return NFCOperationResult.failure(
        error:
            '${appLocalizations.errorReadingTag}$e${appLocalizations.holdTagCloseAndTryAgain}',
        operationType: NFCOperationType.read,
      );
    }
  }

  static Future<NFCOperationResult> writeNDEF(
      List<ndef.NDEFRecord> records) async {
    if (records.isEmpty) {
      return NFCOperationResult.failure(
        error: appLocalizations.noRecordsToWrite,
        operationType: NFCOperationType.write,
      );
    }

    try {
      final tag = await NFCSessionManager.pollForTag(
        iosAlertMessage: appLocalizations.scanYourNfcTagToWrite,
      );

      final tagInfo = NFCTagInfo(
        type: tag.type.toString(),
        id: tag.id,
        ndefAvailable: tag.ndefAvailable,
        ndefWritable: tag.ndefWritable,
      );

      if (tag.ndefAvailable != true) {
        await NFCSessionManager.finishSession(
            iosMessage: appLocalizations.tagDoesNotSupportNdef);
        return NFCOperationResult.failure(
          error: appLocalizations.tagDoesNotSupportNdef,
          operationType: NFCOperationType.write,
          tagInfo: tagInfo,
        );
      }

      if (tag.ndefWritable != true) {
        await NFCSessionManager.finishSession(
            iosMessage: appLocalizations.tagIsNotWritable);
        return NFCOperationResult.failure(
          error: appLocalizations.tagIsNotWritable,
          operationType: NFCOperationType.write,
          tagInfo: tagInfo,
        );
      }

      await FlutterNfcKit.writeNDEFRecords(records);
      await NFCSessionManager.finishSession(
          iosMessage: appLocalizations.writeOperationCompleted);

      String message = '${tagInfo.toString()}\n\n';
      message += '${appLocalizations.ndefRecordsWrittenSuccessfully}\n';
      message += '${appLocalizations.recordsWritten}${records.length}\n\n';

      for (int i = 0; i < records.length; i++) {
        message += '${appLocalizations.writtenRecord}${i + 1}:\n';
        message +=
            '${appLocalizations.type}${NDEFRecordParser.getRecordTypeString(records[i])}\n';
        message +=
            '${appLocalizations.content}${NDEFRecordParser.getRecordInfo(records[i])}\n\n';
      }

      return NFCOperationResult.success(
        message: message,
        operationType: NFCOperationType.write,
        tagInfo: tagInfo,
        records: records,
      );
    } catch (e) {
      await NFCSessionManager.finishSession();
      return NFCOperationResult.failure(
        error:
            '${appLocalizations.errorWritingToTag}$e${appLocalizations.tryHoldingTagCloser}',
        operationType: NFCOperationType.write,
      );
    }
  }

  static Future<NFCOperationResult> clearNDEF() async {
    try {
      final tag = await NFCSessionManager.pollForTag(
        iosAlertMessage: appLocalizations.scanYourNfcTagToClear,
      );

      final tagInfo = NFCTagInfo(
        type: tag.type.toString(),
        id: tag.id,
        ndefAvailable: tag.ndefAvailable,
        ndefWritable: tag.ndefWritable,
      );

      if (tag.ndefAvailable != true) {
        await NFCSessionManager.finishSession(
            iosMessage: appLocalizations.tagDoesNotSupportNdef);
        return NFCOperationResult.failure(
          error: appLocalizations.tagDoesNotSupportNdefCannotClear,
          operationType: NFCOperationType.clear,
          tagInfo: tagInfo,
        );
      }

      if (tag.ndefWritable != true) {
        await NFCSessionManager.finishSession(
            iosMessage: appLocalizations.tagIsNotWritable);
        return NFCOperationResult.failure(
          error: appLocalizations.tagIsNotWritableCannotClear,
          operationType: NFCOperationType.clear,
          tagInfo: tagInfo,
        );
      }

      String clearMethod = await _attemptClearMethods();
      await NFCSessionManager.finishSession(
          iosMessage: appLocalizations.clearOperationCompleted);

      String message = '${tagInfo.toString()}\n\n';
      message += '${appLocalizations.tagClearedSuccessfully}\n';
      message += '${appLocalizations.method}$clearMethod\n';
      message += appLocalizations.tagIsNowReadyForNewData;

      return NFCOperationResult.success(
        message: message,
        operationType: NFCOperationType.clear,
        tagInfo: tagInfo,
      );
    } catch (e) {
      await NFCSessionManager.finishSession();
      return NFCOperationResult.failure(
        error:
            '${appLocalizations.errorClearingTag}$e${appLocalizations.tryMovingTagCloser}',
        operationType: NFCOperationType.clear,
      );
    }
  }

  static Future<String> _attemptClearMethods() async {
    try {
      final emptyRecord = NDEFRecordFactory.createEmptyTextRecord();
      await FlutterNfcKit.writeNDEFRecords([emptyRecord]);
      return appLocalizations.emptyTextRecord;
    } catch (e) {
      print('${appLocalizations.method1EmptyTextRecordFailed}$e');
    }

    try {
      final emptyRecord = NDEFRecordFactory.createEmptyRecord();
      await FlutterNfcKit.writeNDEFRecords([emptyRecord]);
      return appLocalizations.emptyNdefRecord;
    } catch (e) {
      print('${appLocalizations.method2EmptyNdefRecordFailed}$e');
    }

    try {
      final minimalRecord = NDEFRecordFactory.createMinimalRecord();
      await FlutterNfcKit.writeNDEFRecords([minimalRecord]);
      return appLocalizations.minimalSpaceCharacter;
    } catch (e) {
      print('${appLocalizations.method3MinimalRecordFailed}$e');
    }

    try {
      await FlutterNfcKit.writeNDEFRecords([]);
      return appLocalizations.emptyRecordList;
    } catch (e) {
      print('${appLocalizations.method4EmptyListFailed}$e');
      throw Exception('${appLocalizations.allClearingMethodsFailed}$e');
    }
  }

  static Future<NFCOperationResult> verifyTag() async {
    try {
      final tag = await NFCSessionManager.pollForTag(
        iosAlertMessage: appLocalizations.scanTagToVerifyContent,
      );

      final tagInfo = NFCTagInfo(
        type: tag.type.toString(),
        id: tag.id,
        ndefAvailable: tag.ndefAvailable,
        ndefWritable: tag.ndefWritable,
      );

      if (tag.ndefAvailable != true) {
        await NFCSessionManager.finishSession(
            iosMessage: appLocalizations.tagDoesNotSupportNdef);
        return NFCOperationResult.failure(
          error: appLocalizations.tagDoesNotSupportNdef,
          operationType: NFCOperationType.verify,
          tagInfo: tagInfo,
        );
      }

      final records = await FlutterNfcKit.readNDEFRecords();
      await NFCSessionManager.finishSession();

      String message = '${appLocalizations.verificationResults}\n';
      message += '${tagInfo.toString()}\n';
      message += '${appLocalizations.recordsFound}${records.length}\n\n';

      if (records.isEmpty) {
        message += '${appLocalizations.noNdefRecordsFoundOnTag}\n';
        message += appLocalizations.theTagIsEmptyCleared;
      } else {
        message += NDEFRecordParser.formatRecordsForDisplay(records);
      }

      return NFCOperationResult.success(
        message: message,
        operationType: NFCOperationType.verify,
        tagInfo: tagInfo,
        records: records,
      );
    } catch (e) {
      await NFCSessionManager.finishSession();
      return NFCOperationResult.failure(
        error: '${appLocalizations.verificationError}$e',
        operationType: NFCOperationType.verify,
      );
    }
  }
}
