import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:magic_epaper_app/constants/string_constants.dart';
import 'package:magic_epaper_app/ndef_screen/models/nfc_operation_result.dart';
import 'package:magic_epaper_app/ndef_screen/models/nfc_tag_info.dart';
import 'package:magic_epaper_app/ndef_screen/services/ndef_record_parser.dart';
import 'package:magic_epaper_app/ndef_screen/services/nfc_session_manager.dart';
import 'package:ndef/ndef.dart' as ndef;

class NFCOperationsService {
  static Future<NFCOperationResult> readNDEF() async {
    try {
      final tag = await NFCSessionManager.pollForTag(
        iosAlertMessage: StringConstants.scanYourNfcTag,
      );

      final tagInfo = NFCTagInfo(
        type: tag.type.toString(),
        id: tag.id,
        ndefAvailable: tag.ndefAvailable,
        ndefWritable: tag.ndefWritable,
      );

      if (tag.ndefAvailable != true) {
        await NFCSessionManager.finishSession(
            iosMessage: StringConstants.tagIsNotNdefCompatible);
        return NFCOperationResult.failure(
          error: StringConstants.tagIsNotNdefCompatible,
          operationType: NFCOperationType.read,
          tagInfo: tagInfo,
        );
      }

      final records = await FlutterNfcKit.readNDEFRecords();
      await NFCSessionManager.finishSession(
          iosMessage: StringConstants.readOperationCompleted);

      String message = '${tagInfo.toString()}\n\n';
      message += '${StringConstants.ndefRecordsFound}${records.length}\n\n';

      if (records.isEmpty) {
        message += StringConstants.theTagIsEmpty;
      } else {
        for (int i = 0; i < records.length; i++) {
          message += '${StringConstants.record}${i + 1}:\n';
          message +=
              '${StringConstants.type}${NDEFRecordParser.getRecordTypeString(records[i])}\n';
          message += '${StringConstants.tnf}${records[i].tnf}\n';
          message +=
              '${StringConstants.content}${NDEFRecordParser.getRecordInfo(records[i])}\n\n';
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
            '${StringConstants.errorReadingTag}$e${StringConstants.holdTagCloseAndTryAgain}',
        operationType: NFCOperationType.read,
      );
    }
  }

  static Future<NFCOperationResult> writeNDEF(
      List<ndef.NDEFRecord> records) async {
    if (records.isEmpty) {
      return NFCOperationResult.failure(
        error: StringConstants.noRecordsToWrite,
        operationType: NFCOperationType.write,
      );
    }

    try {
      final tag = await NFCSessionManager.pollForTag(
        iosAlertMessage: StringConstants.scanYourNfcTagToWrite,
      );

      final tagInfo = NFCTagInfo(
        type: tag.type.toString(),
        id: tag.id,
        ndefAvailable: tag.ndefAvailable,
        ndefWritable: tag.ndefWritable,
      );

      if (tag.ndefAvailable != true) {
        await NFCSessionManager.finishSession(
            iosMessage: StringConstants.tagDoesNotSupportNdef);
        return NFCOperationResult.failure(
          error: StringConstants.tagDoesNotSupportNdef,
          operationType: NFCOperationType.write,
          tagInfo: tagInfo,
        );
      }

      if (tag.ndefWritable != true) {
        await NFCSessionManager.finishSession(
            iosMessage: StringConstants.tagIsNotWritable);
        return NFCOperationResult.failure(
          error: StringConstants.tagIsNotWritable,
          operationType: NFCOperationType.write,
          tagInfo: tagInfo,
        );
      }

      await FlutterNfcKit.writeNDEFRecords(records);
      await NFCSessionManager.finishSession(
          iosMessage: StringConstants.writeOperationCompleted);

      String message = '${tagInfo.toString()}\n\n';
      message += '${StringConstants.ndefRecordsWrittenSuccessfully}\n';
      message += '${StringConstants.recordsWritten}${records.length}\n\n';

      for (int i = 0; i < records.length; i++) {
        message += '${StringConstants.writtenRecord}${i + 1}:\n';
        message +=
            '${StringConstants.type}${NDEFRecordParser.getRecordTypeString(records[i])}\n';
        message +=
            '${StringConstants.content}${NDEFRecordParser.getRecordInfo(records[i])}\n\n';
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
            '${StringConstants.errorWritingToTag}$e${StringConstants.tryHoldingTagCloser}',
        operationType: NFCOperationType.write,
      );
    }
  }

  static Future<NFCOperationResult> clearNDEF() async {
    try {
      final tag = await NFCSessionManager.pollForTag(
        iosAlertMessage: StringConstants.scanYourNfcTagToClear,
      );

      final tagInfo = NFCTagInfo(
        type: tag.type.toString(),
        id: tag.id,
        ndefAvailable: tag.ndefAvailable,
        ndefWritable: tag.ndefWritable,
      );

      if (tag.ndefAvailable != true) {
        await NFCSessionManager.finishSession(
            iosMessage: StringConstants.tagDoesNotSupportNdef);
        return NFCOperationResult.failure(
          error: StringConstants.tagDoesNotSupportNdefCannotClear,
          operationType: NFCOperationType.clear,
          tagInfo: tagInfo,
        );
      }

      if (tag.ndefWritable != true) {
        await NFCSessionManager.finishSession(
            iosMessage: StringConstants.tagIsNotWritable);
        return NFCOperationResult.failure(
          error: StringConstants.tagIsNotWritableCannotClear,
          operationType: NFCOperationType.clear,
          tagInfo: tagInfo,
        );
      }

      String clearMethod = await _attemptClearMethods();
      await NFCSessionManager.finishSession(
          iosMessage: StringConstants.clearOperationCompleted);

      String message = '${tagInfo.toString()}\n\n';
      message += '${StringConstants.tagClearedSuccessfully}\n';
      message += '${StringConstants.method}$clearMethod\n';
      message += StringConstants.tagIsNowReadyForNewData;

      return NFCOperationResult.success(
        message: message,
        operationType: NFCOperationType.clear,
        tagInfo: tagInfo,
      );
    } catch (e) {
      await NFCSessionManager.finishSession();
      return NFCOperationResult.failure(
        error:
            '${StringConstants.errorClearingTag}$e${StringConstants.tryMovingTagCloser}',
        operationType: NFCOperationType.clear,
      );
    }
  }

  static Future<String> _attemptClearMethods() async {
    try {
      final emptyRecord = NDEFRecordFactory.createEmptyTextRecord();
      await FlutterNfcKit.writeNDEFRecords([emptyRecord]);
      return StringConstants.emptyTextRecord;
    } catch (e) {
      print('${StringConstants.method1EmptyTextRecordFailed}$e');
    }

    try {
      final emptyRecord = NDEFRecordFactory.createEmptyRecord();
      await FlutterNfcKit.writeNDEFRecords([emptyRecord]);
      return StringConstants.emptyNdefRecord;
    } catch (e) {
      print('${StringConstants.method2EmptyNdefRecordFailed}$e');
    }

    try {
      final minimalRecord = NDEFRecordFactory.createMinimalRecord();
      await FlutterNfcKit.writeNDEFRecords([minimalRecord]);
      return StringConstants.minimalSpaceCharacter;
    } catch (e) {
      print('${StringConstants.method3MinimalRecordFailed}$e');
    }

    try {
      await FlutterNfcKit.writeNDEFRecords([]);
      return StringConstants.emptyRecordList;
    } catch (e) {
      print('${StringConstants.method4EmptyListFailed}$e');
      throw Exception('${StringConstants.allClearingMethodsFailed}$e');
    }
  }

  static Future<NFCOperationResult> verifyTag() async {
    try {
      final tag = await NFCSessionManager.pollForTag(
        iosAlertMessage: StringConstants.scanTagToVerifyContent,
      );

      final tagInfo = NFCTagInfo(
        type: tag.type.toString(),
        id: tag.id,
        ndefAvailable: tag.ndefAvailable,
        ndefWritable: tag.ndefWritable,
      );

      if (tag.ndefAvailable != true) {
        await NFCSessionManager.finishSession(
            iosMessage: StringConstants.tagDoesNotSupportNdef);
        return NFCOperationResult.failure(
          error: StringConstants.tagDoesNotSupportNdef,
          operationType: NFCOperationType.verify,
          tagInfo: tagInfo,
        );
      }

      final records = await FlutterNfcKit.readNDEFRecords();
      await NFCSessionManager.finishSession();

      String message = '${StringConstants.verificationResults}\n';
      message += '${tagInfo.toString()}\n';
      message += '${StringConstants.recordsFound}${records.length}\n\n';

      if (records.isEmpty) {
        message += '${StringConstants.noNdefRecordsFoundOnTag}\n';
        message += StringConstants.theTagIsEmptyCleared;
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
        error: '${StringConstants.verificationError}$e',
        operationType: NFCOperationType.verify,
      );
    }
  }
}
