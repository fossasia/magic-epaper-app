import 'package:magicepaperapp/ndef_screen/models/nfc_tag_info.dart';

enum NFCOperationType { read, write, clear, verify }

class NFCOperationResult {
  final bool success;
  final String message;
  final NFCOperationType operationType;
  final NFCTagInfo? tagInfo;
  final List<dynamic>? records;
  final String? error;

  NFCOperationResult({
    required this.success,
    required this.message,
    required this.operationType,
    this.tagInfo,
    this.records,
    this.error,
  });

  factory NFCOperationResult.success({
    required String message,
    required NFCOperationType operationType,
    NFCTagInfo? tagInfo,
    List<dynamic>? records,
  }) {
    return NFCOperationResult(
      success: true,
      message: message,
      operationType: operationType,
      tagInfo: tagInfo,
      records: records,
    );
  }

  factory NFCOperationResult.failure({
    required String error,
    required NFCOperationType operationType,
    NFCTagInfo? tagInfo,
  }) {
    return NFCOperationResult(
      success: false,
      message: error,
      operationType: operationType,
      tagInfo: tagInfo,
      error: error,
    );
  }
}
