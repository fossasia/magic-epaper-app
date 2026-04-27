import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:magicepaperapp/provider/locale_provider.dart';
import 'package:magicepaperapp/ndef_screen/models/nfc_operation_result.dart';
import 'package:magicepaperapp/ndef_screen/models/nfc_tag_info.dart';
import 'package:magicepaperapp/ndef_screen/services/ndef_record_parser.dart';
import 'package:magicepaperapp/ndef_screen/services/nfc_session_manager.dart';
import 'package:ndef/ndef.dart' as ndef;


class NFCOperationsService {
  static Future<NFCOperationResult> readNDEF() async {
    try {
      final tag = await NFCSessionManager.pollForTag(
        iosAlertMessage: LocaleProvider.current!.scanYourNfcTag,
      );

      final tagInfo = NFCTagInfo(
        type: tag.type.toString(),
        id: tag.id,
        ndefAvailable: tag.ndefAvailable,
        ndefWritable: tag.ndefWritable,
      );

      if (tag.ndefAvailable != true) {
        await NFCSessionManager.finishSession(
            iosMessage: LocaleProvider.current!.tagIsNotNdefCompatible);
        return NFCOperationResult.failure(
          error: LocaleProvider.current!.tagIsNotNdefCompatible,
          operationType: NFCOperationType.read,
          tagInfo: tagInfo,
        );
      }

      final records = await FlutterNfcKit.readNDEFRecords();
      await NFCSessionManager.finishSession(
          iosMessage: LocaleProvider.current!.readOperationCompleted);

      String message = '${tagInfo.toString()}\n\n';
      message += '${LocaleProvider.current!.ndefRecordsFound}${records.length}\n\n';

      if (records.isEmpty) {
        message += LocaleProvider.current!.theTagIsEmpty;
      } else {
        for (int i = 0; i < records.length; i++) {
          message += '${LocaleProvider.current!.record}${i + 1}:\n';
          message +=
              '${LocaleProvider.current!.type}${NDEFRecordParser.getRecordTypeString(records[i])}\n';
          message += '${LocaleProvider.current!.tnf}${records[i].tnf}\n';
          message +=
              '${LocaleProvider.current!.content}${NDEFRecordParser.getRecordInfo(records[i])}\n\n';
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
            '${LocaleProvider.current!.errorReadingTag}$e${LocaleProvider.current!.holdTagCloseAndTryAgain}',
        operationType: NFCOperationType.read,
      );
    }
  }

  static Future<NFCOperationResult> writeNDEF(
      List<ndef.NDEFRecord> records) async {
    if (records.isEmpty) {
      return NFCOperationResult.failure(
        error: LocaleProvider.current!.noRecordsToWrite,
        operationType: NFCOperationType.write,
      );
    }

    try {
      final tag = await NFCSessionManager.pollForTag(
        iosAlertMessage: LocaleProvider.current!.scanYourNfcTagToWrite,
      );

      final tagInfo = NFCTagInfo(
        type: tag.type.toString(),
        id: tag.id,
        ndefAvailable: tag.ndefAvailable,
        ndefWritable: tag.ndefWritable,
      );

      if (tag.ndefAvailable != true) {
        await NFCSessionManager.finishSession(
            iosMessage: LocaleProvider.current!.tagDoesNotSupportNdef);
        return NFCOperationResult.failure(
          error: LocaleProvider.current!.tagDoesNotSupportNdef,
          operationType: NFCOperationType.write,
          tagInfo: tagInfo,
        );
      }

      if (tag.ndefWritable != true) {
        await NFCSessionManager.finishSession(
            iosMessage: LocaleProvider.current!.tagIsNotWritable);
        return NFCOperationResult.failure(
          error: LocaleProvider.current!.tagIsNotWritable,
          operationType: NFCOperationType.write,
          tagInfo: tagInfo,
        );
      }

      await FlutterNfcKit.writeNDEFRecords(records);
      await NFCSessionManager.finishSession(
          iosMessage: LocaleProvider.current!.writeOperationCompleted);

      String message = '${tagInfo.toString()}\n\n';
      message += '${LocaleProvider.current!.ndefRecordsWrittenSuccessfully}\n';
      message += '${LocaleProvider.current!.recordsWritten}${records.length}\n\n';

      for (int i = 0; i < records.length; i++) {
        message += '${LocaleProvider.current!.writtenRecord}${i + 1}:\n';
        message +=
            '${LocaleProvider.current!.type}${NDEFRecordParser.getRecordTypeString(records[i])}\n';
        message +=
            '${LocaleProvider.current!.content}${NDEFRecordParser.getRecordInfo(records[i])}\n\n';
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
            '${LocaleProvider.current!.errorWritingToTag}$e${LocaleProvider.current!.tryHoldingTagCloser}',
        operationType: NFCOperationType.write,
      );
    }
  }

  static Future<NFCOperationResult> clearNDEF() async {
    try {
      final tag = await NFCSessionManager.pollForTag(
        iosAlertMessage: LocaleProvider.current!.scanYourNfcTagToClear,
      );

      final tagInfo = NFCTagInfo(
        type: tag.type.toString(),
        id: tag.id,
        ndefAvailable: tag.ndefAvailable,
        ndefWritable: tag.ndefWritable,
      );

      if (tag.ndefAvailable != true) {
        await NFCSessionManager.finishSession(
            iosMessage: LocaleProvider.current!.tagDoesNotSupportNdef);
        return NFCOperationResult.failure(
          error: LocaleProvider.current!.tagDoesNotSupportNdefCannotClear,
          operationType: NFCOperationType.clear,
          tagInfo: tagInfo,
        );
      }

      if (tag.ndefWritable != true) {
        await NFCSessionManager.finishSession(
            iosMessage: LocaleProvider.current!.tagIsNotWritable);
        return NFCOperationResult.failure(
          error: LocaleProvider.current!.tagIsNotWritableCannotClear,
          operationType: NFCOperationType.clear,
          tagInfo: tagInfo,
        );
      }

      String clearMethod = await _attemptClearMethods();
      await NFCSessionManager.finishSession(
          iosMessage: LocaleProvider.current!.clearOperationCompleted);

      String message = '${tagInfo.toString()}\n\n';
      message += '${LocaleProvider.current!.tagClearedSuccessfully}\n';
      message += '${LocaleProvider.current!.method}$clearMethod\n';
      message += LocaleProvider.current!.tagIsNowReadyForNewData;

      return NFCOperationResult.success(
        message: message,
        operationType: NFCOperationType.clear,
        tagInfo: tagInfo,
      );
    } catch (e) {
      await NFCSessionManager.finishSession();
      return NFCOperationResult.failure(
        error:
            '${LocaleProvider.current!.errorClearingTag}$e${LocaleProvider.current!.tryMovingTagCloser}',
        operationType: NFCOperationType.clear,
      );
    }
  }

  static Future<String> _attemptClearMethods() async {
    try {
      final emptyRecord = NDEFRecordFactory.createEmptyTextRecord();
      await FlutterNfcKit.writeNDEFRecords([emptyRecord]);
      return LocaleProvider.current!.emptyTextRecord;
    } catch (e) {
      print('${LocaleProvider.current!.method1EmptyTextRecordFailed}$e');
    }

    try {
      final emptyRecord = NDEFRecordFactory.createEmptyRecord();
      await FlutterNfcKit.writeNDEFRecords([emptyRecord]);
      return LocaleProvider.current!.emptyNdefRecord;
    } catch (e) {
      print('${LocaleProvider.current!.method2EmptyNdefRecordFailed}$e');
    }

    try {
      final minimalRecord = NDEFRecordFactory.createMinimalRecord();
      await FlutterNfcKit.writeNDEFRecords([minimalRecord]);
      return LocaleProvider.current!.minimalSpaceCharacter;
    } catch (e) {
      print('${LocaleProvider.current!.method3MinimalRecordFailed}$e');
    }

    try {
      await FlutterNfcKit.writeNDEFRecords([]);
      return LocaleProvider.current!.emptyRecordList;
    } catch (e) {
      print('${LocaleProvider.current!.method4EmptyListFailed}$e');
      throw Exception('${LocaleProvider.current!.allClearingMethodsFailed}$e');
    }
  }

  static Future<NFCOperationResult> verifyTag() async {
    try {
      final tag = await NFCSessionManager.pollForTag(
        iosAlertMessage: LocaleProvider.current!.scanTagToVerifyContent,
      );

      final tagInfo = NFCTagInfo(
        type: tag.type.toString(),
        id: tag.id,
        ndefAvailable: tag.ndefAvailable,
        ndefWritable: tag.ndefWritable,
      );

      if (tag.ndefAvailable != true) {
        await NFCSessionManager.finishSession(
            iosMessage: LocaleProvider.current!.tagDoesNotSupportNdef);
        return NFCOperationResult.failure(
          error: LocaleProvider.current!.tagDoesNotSupportNdef,
          operationType: NFCOperationType.verify,
          tagInfo: tagInfo,
        );
      }

      final records = await FlutterNfcKit.readNDEFRecords();
      await NFCSessionManager.finishSession();

      String message = '${LocaleProvider.current!.verificationResults}\n';
      message += '${tagInfo.toString()}\n';
      message += '${LocaleProvider.current!.recordsFound}${records.length}\n\n';

      if (records.isEmpty) {
        message += '${LocaleProvider.current!.noNdefRecordsFoundOnTag}\n';
        message += LocaleProvider.current!.theTagIsEmptyCleared;
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
        error: '${LocaleProvider.current!.verificationError}$e',
        operationType: NFCOperationType.verify,
      );
    }
  }
}
