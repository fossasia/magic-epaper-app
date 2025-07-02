import 'package:magic_epaper_app/constants/string_constants.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'dart:typed_data';

class NDEFRecordFactory {
  static ndef.NDEFRecord createTextRecord(String text,
      {String language = StringConstants.defaultLanguage}) {
    if (text.trim().isEmpty) {
      throw ArgumentError(StringConstants.textCannotBeEmpty);
    }
    return ndef.TextRecord(
      text: text.trim(),
      language: language,
      encoding: ndef.TextEncoding.UTF8,
    );
  }

  static ndef.NDEFRecord createUrlRecord(String url) {
    if (url.trim().isEmpty) {
      throw ArgumentError(StringConstants.urlCannotBeEmpty);
    }

    String formattedUrl = url.trim();
    if (!formattedUrl.startsWith(StringConstants.httpPrefix) &&
        !formattedUrl.startsWith(StringConstants.httpsPrefix)) {
      formattedUrl = '${StringConstants.httpsPrefix}$formattedUrl';
    }

    return ndef.UriRecord.fromString(formattedUrl);
  }

  static ndef.NDEFRecord createWifiRecord(String ssid, String password) {
    if (ssid.trim().isEmpty) {
      throw ArgumentError(StringConstants.wifiSsidCannotBeEmpty);
    }

    String wifiConfig = '${StringConstants.wifiConfigFormat}${ssid.trim()}${StringConstants.wifiPasswordPrefix}${password.trim()}${StringConstants.wifiConfigSuffix}';
    return ndef.TextRecord(
      text: wifiConfig,
      language: StringConstants.defaultLanguage,
      encoding: ndef.TextEncoding.UTF8,
    );
  }

  static ndef.NDEFRecord createEmptyTextRecord() {
    return ndef.TextRecord(
      text: '',
      language: StringConstants.defaultLanguage,
      encoding: ndef.TextEncoding.UTF8,
    );
  }

  static ndef.NDEFRecord createEmptyRecord() {
    return ndef.NDEFRecord(
      tnf: ndef.TypeNameFormat.empty,
      type: Uint8List(0),
      id: Uint8List(0),
      payload: Uint8List(0),
    );
  }

  static ndef.NDEFRecord createMinimalRecord() {
    return ndef.TextRecord(
      text: StringConstants.emptySpace,
      language: StringConstants.defaultLanguage,
      encoding: ndef.TextEncoding.UTF8,
    );
  }
}

class NDEFRecordParser {
  static String getRecordTypeString(ndef.NDEFRecord record) {
    try {
      if (record.type != null) {
        return String.fromCharCodes(record.type!);
      } else {
        return StringConstants.unknownNull;
      }
    } catch (e) {
      return '${StringConstants.unknownType}${record.type}${StringConstants.closingParenthesis}';
    }
  }

  static String getRecordInfo(ndef.NDEFRecord record) {
    try {
      if (record is ndef.TextRecord) {
        return '${StringConstants.textPrefix}${record.text}${StringConstants.textSuffix}${record.language}${StringConstants.closingParenthesis}';
      } else if (record is ndef.UriRecord) {
        return '${StringConstants.uriPrefix}${record.content}';
      } else if (record is ndef.MimeRecord) {
        return '${StringConstants.mimePrefix}${record.decodedType}';
      } else if (record is ndef.AbsoluteUriRecord) {
        return '${StringConstants.absoluteUriPrefix}${record.decodedType}';
      } else {
        return _parseRawRecord(record);
      }
    } catch (e) {
      return '${StringConstants.errorDecodingRecord}$e';
    }
  }

  static String _parseRawRecord(ndef.NDEFRecord record) {
    try {
      if (record.payload != null && record.payload!.isNotEmpty) {
        List<int> payloadList = record.payload!.toList();
        String decoded = String.fromCharCodes(payloadList);
        return '${StringConstants.rawPrefix}$decoded';
      } else {
        return StringConstants.emptyPayload;
      }
    } catch (e) {
      int payloadLength = record.payload?.length ?? 0;
      return '${StringConstants.binaryDataPrefix}$payloadLength${StringConstants.binaryDataSuffix}${record.decodedType}';
    }
  }

  static String formatRecordsForDisplay(List<ndef.NDEFRecord> records) {
    if (records.isEmpty) {
      return StringConstants.noNdefRecordsFound;
    }

    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < records.length; i++) {
      var record = records[i];
      buffer.writeln('${StringConstants.recordPrefix}${i + 1}${StringConstants.recordSuffix}');
      buffer.writeln('${StringConstants.tnfLabel}${record.tnf}');
      buffer.writeln('${StringConstants.typeLabel}${getRecordTypeString(record)}');
      buffer.writeln('${StringConstants.payloadSizeLabel}${record.payload?.length ?? 0}${StringConstants.bytesLabel}');
      buffer.writeln('${StringConstants.contentLabel}${getRecordInfo(record)}');

      if (record.payload != null) {
        String hexPayload = record.payload!
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join(' ');
        buffer.writeln('${StringConstants.rawPayloadLabel}$hexPayload');
      } else {
        buffer.writeln('${StringConstants.rawPayloadLabel}${StringConstants.nullPayload}');
      }
      buffer.writeln();
    }
    return buffer.toString();
  }
}