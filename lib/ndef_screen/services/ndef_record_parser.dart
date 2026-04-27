import 'package:magicepaperapp/provider/locale_provider.dart';
import 'package:magicepaperapp/ndef_screen/models/v_card_data.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'dart:typed_data';


class NDEFRecordFactory {
  static ndef.NDEFRecord createVCardRecord(VCardData vCardData) {
    String vCardString = vCardData.toVCardString();

    if (vCardString.trim().isEmpty) {
      throw ArgumentError(LocaleProvider.current!.vCardDataCannotBeEmpty);
    }

    return ndef.MimeRecord(
      decodedType: 'text/vcard',
      payload: Uint8List.fromList(vCardString.codeUnits),
    );
  }

  static ndef.NDEFRecord createTextRecord(String text,
      {String language = 'en'}) {
    if (text.trim().isEmpty) {
      throw ArgumentError(LocaleProvider.current!.textCannotBeEmpty);
    }
    return ndef.TextRecord(
      text: text.trim(),
      language: language,
      encoding: ndef.TextEncoding.UTF8,
    );
  }

  static List<ndef.NDEFRecord> createAppLauncherRecords(String packageName,
      {String? appUri}) {
    if (packageName.trim().isEmpty) {
      throw ArgumentError(LocaleProvider.current!.appCannotBeEmpty);
    }
    List<ndef.NDEFRecord> records = [];
    if (appUri != null && appUri.trim().isNotEmpty) {
      records.add(ndef.UriRecord.fromString(appUri.trim()));
    }
    records.add(_createAndroidApplicationRecord(packageName.trim()));
    return records;
  }

  static ndef.NDEFRecord _createAndroidApplicationRecord(String packageName) {
    List<int> packageBytes = packageName.codeUnits;
    return ndef.NDEFRecord(
      tnf: ndef.TypeNameFormat.nfcExternal,
      type: Uint8List.fromList('android.com:pkg'.codeUnits),
      id: Uint8List(0),
      payload: Uint8List.fromList(packageBytes),
    );
  }

  static ndef.NDEFRecord createUrlRecord(String url) {
    if (url.trim().isEmpty) {
      throw ArgumentError(LocaleProvider.current!.urlCannotBeEmpty);
    }

    String formattedUrl = url.trim();
    if (!formattedUrl.startsWith(LocaleProvider.current!.httpPrefix) &&
        !formattedUrl.startsWith(LocaleProvider.current!.httpsPrefix)) {
      formattedUrl = '${LocaleProvider.current!.httpsPrefix}$formattedUrl';
    }

    return ndef.UriRecord.fromString(formattedUrl);
  }

  static ndef.NDEFRecord createWifiRecord(String ssid, String password) {
    if (ssid.trim().isEmpty) {
      throw ArgumentError(LocaleProvider.current!.wifiSsidCannotBeEmpty);
    }

    String wifiConfig =
        '${LocaleProvider.current!.wifiConfigFormat}${ssid.trim()}${LocaleProvider.current!.wifiPasswordPrefix}${password.trim()}${LocaleProvider.current!.wifiConfigSuffix}';
    return ndef.TextRecord(
      text: wifiConfig,
      language: LocaleProvider.current!.defaultLanguage,
      encoding: ndef.TextEncoding.UTF8,
    );
  }

  static ndef.NDEFRecord createEmptyTextRecord() {
    return ndef.TextRecord(
      text: '',
      language: 'en',
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
      text: LocaleProvider.current!.emptySpace,
      language: 'en',
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
        return LocaleProvider.current!.unknownNull;
      }
    } catch (e) {
      return '${LocaleProvider.current!.unknownType}${record.type}${LocaleProvider.current!.closingParenthesis}';
    }
  }

  static String getRecordInfo(ndef.NDEFRecord record) {
    try {
      if (record is ndef.TextRecord) {
        if (record.text!.startsWith('BEGIN:VCARD')) {
          return 'vCard: ${_extractVCardName(record.text!)}';
        }
        return '${LocaleProvider.current!.textPrefix}${record.text}${LocaleProvider.current!.textSuffix}${record.language}${LocaleProvider.current!.closingParenthesis}';
      } else if (record is ndef.UriRecord) {
        return '${LocaleProvider.current!.uriPrefix}${record.content}';
      } else if (record is ndef.MimeRecord) {
        if (record.decodedType == 'text/vcard') {
          String vCardContent = String.fromCharCodes(record.payload!);
          return 'vCard: ${_extractVCardName(vCardContent)}';
        }
        return '${LocaleProvider.current!.mimePrefix}${record.decodedType}';
      } else if (record is ndef.AbsoluteUriRecord) {
        return '${LocaleProvider.current!.absoluteUriPrefix}${record.decodedType}';
      } else {
        return _parseRawRecord(record);
      }
    } catch (e) {
      return '${LocaleProvider.current!.errorDecodingRecord}$e';
    }
  }

  static String _extractVCardName(String vCardContent) {
    try {
      RegExp fnRegex = RegExp(r'FN[^:]*:(.+)', caseSensitive: false);
      Match? match = fnRegex.firstMatch(vCardContent);
      if (match != null) {
        return match.group(1)?.trim() ?? 'Contact';
      }

      RegExp nRegex = RegExp(r'N[^:]*:([^;]*);([^;]*)', caseSensitive: false);
      Match? nMatch = nRegex.firstMatch(vCardContent);
      if (nMatch != null) {
        String lastName = nMatch.group(1)?.trim() ?? '';
        String firstName = nMatch.group(2)?.trim() ?? '';
        return '$firstName $lastName'.trim();
      }

      return 'Contact';
    } catch (e) {
      return 'Contact';
    }
  }

  static String _parseRawRecord(ndef.NDEFRecord record) {
    try {
      if (record.payload != null && record.payload!.isNotEmpty) {
        List<int> payloadList = record.payload!.toList();
        String decoded = String.fromCharCodes(payloadList);
        return '${LocaleProvider.current!.rawPrefix}$decoded';
      } else {
        return LocaleProvider.current!.emptyPayload;
      }
    } catch (e) {
      int payloadLength = record.payload?.length ?? 0;
      return '${LocaleProvider.current!.binaryDataPrefix}$payloadLength${LocaleProvider.current!.binaryDataSuffix}${record.decodedType}';
    }
  }

  static String formatRecordsForDisplay(List<ndef.NDEFRecord> records) {
    if (records.isEmpty) {
      return LocaleProvider.current!.noNdefRecordsFound;
    }

    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < records.length; i++) {
      var record = records[i];
      buffer.writeln(
          '${LocaleProvider.current!.recordPrefix}${i + 1}${LocaleProvider.current!.recordSuffix}');
      buffer.writeln('${LocaleProvider.current!.tnfLabel}${record.tnf}');
      buffer.writeln(
          '${LocaleProvider.current!.typeLabel}${getRecordTypeString(record)}');
      buffer.writeln(
          '${LocaleProvider.current!.payloadSizeLabel}${record.payload?.length ?? 0}${LocaleProvider.current!.bytesLabel}');
      buffer
          .writeln('${LocaleProvider.current!.contentLabel}${getRecordInfo(record)}');

      if (record.payload != null) {
        String hexPayload = record.payload!
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join(' ');
        buffer.writeln('${LocaleProvider.current!.rawPayloadLabel}$hexPayload');
      } else {
        buffer.writeln(
            '${LocaleProvider.current!.rawPayloadLabel}${LocaleProvider.current!.nullPayload}');
      }
      buffer.writeln();
    }
    return buffer.toString();
  }
}
