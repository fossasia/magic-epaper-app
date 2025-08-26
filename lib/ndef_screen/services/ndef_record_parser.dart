import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/ndef_screen/models/v_card_data.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'dart:typed_data';

AppLocalizations appLocalizations = getIt.get<AppLocalizations>();

class NDEFRecordFactory {
  static ndef.NDEFRecord createVCardRecord(VCardData vCardData) {
    String vCardString = vCardData.toVCardString();

    if (vCardString.trim().isEmpty) {
      throw ArgumentError(appLocalizations.vCardDataCannotBeEmpty);
    }

    return ndef.MimeRecord(
      decodedType: 'text/vcard',
      payload: Uint8List.fromList(vCardString.codeUnits),
    );
  }

  static ndef.NDEFRecord createTextRecord(String text,
      {String language = 'en'}) {
    if (text.trim().isEmpty) {
      throw ArgumentError(appLocalizations.textCannotBeEmpty);
    }
    return ndef.TextRecord(
      text: text.trim(),
      language: language,
      encoding: ndef.TextEncoding.UTF8,
    );
  }

  static ndef.NDEFRecord createUrlRecord(String url) {
    if (url.trim().isEmpty) {
      throw ArgumentError(appLocalizations.urlCannotBeEmpty);
    }

    String formattedUrl = url.trim();
    if (!formattedUrl.startsWith(appLocalizations.httpPrefix) &&
        !formattedUrl.startsWith(appLocalizations.httpsPrefix)) {
      formattedUrl = '${appLocalizations.httpsPrefix}$formattedUrl';
    }

    return ndef.UriRecord.fromString(formattedUrl);
  }

  static ndef.NDEFRecord createWifiRecord(String ssid, String password) {
    if (ssid.trim().isEmpty) {
      throw ArgumentError(appLocalizations.wifiSsidCannotBeEmpty);
    }

    String wifiConfig =
        '${appLocalizations.wifiConfigFormat}${ssid.trim()}${appLocalizations.wifiPasswordPrefix}${password.trim()}${appLocalizations.wifiConfigSuffix}';
    return ndef.TextRecord(
      text: wifiConfig,
      language: appLocalizations.defaultLanguage,
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
      text: appLocalizations.emptySpace,
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
        return appLocalizations.unknownNull;
      }
    } catch (e) {
      return '${appLocalizations.unknownType}${record.type}${appLocalizations.closingParenthesis}';
    }
  }

  static String getRecordInfo(ndef.NDEFRecord record) {
    try {
      if (record is ndef.TextRecord) {
        if (record.text!.startsWith('BEGIN:VCARD')) {
          return 'vCard: ${_extractVCardName(record.text!)}';
        }
        return '${appLocalizations.textPrefix}${record.text}${appLocalizations.textSuffix}${record.language}${appLocalizations.closingParenthesis}';
      } else if (record is ndef.UriRecord) {
        return '${appLocalizations.uriPrefix}${record.content}';
      } else if (record is ndef.MimeRecord) {
        if (record.decodedType == 'text/vcard') {
          String vCardContent = String.fromCharCodes(record.payload!);
          return 'vCard: ${_extractVCardName(vCardContent)}';
        }
        return '${appLocalizations.mimePrefix}${record.decodedType}';
      } else if (record is ndef.AbsoluteUriRecord) {
        return '${appLocalizations.absoluteUriPrefix}${record.decodedType}';
      } else {
        return _parseRawRecord(record);
      }
    } catch (e) {
      return '${appLocalizations.errorDecodingRecord}$e';
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
        return '${appLocalizations.rawPrefix}$decoded';
      } else {
        return appLocalizations.emptyPayload;
      }
    } catch (e) {
      int payloadLength = record.payload?.length ?? 0;
      return '${appLocalizations.binaryDataPrefix}$payloadLength${appLocalizations.binaryDataSuffix}${record.decodedType}';
    }
  }

  static String formatRecordsForDisplay(List<ndef.NDEFRecord> records) {
    if (records.isEmpty) {
      return appLocalizations.noNdefRecordsFound;
    }

    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < records.length; i++) {
      var record = records[i];
      buffer.writeln(
          '${appLocalizations.recordPrefix}${i + 1}${appLocalizations.recordSuffix}');
      buffer.writeln('${appLocalizations.tnfLabel}${record.tnf}');
      buffer.writeln(
          '${appLocalizations.typeLabel}${getRecordTypeString(record)}');
      buffer.writeln(
          '${appLocalizations.payloadSizeLabel}${record.payload?.length ?? 0}${appLocalizations.bytesLabel}');
      buffer.writeln('${appLocalizations.contentLabel}${getRecordInfo(record)}');

      if (record.payload != null) {
        String hexPayload = record.payload!
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join(' ');
        buffer.writeln('${appLocalizations.rawPayloadLabel}$hexPayload');
      } else {
        buffer.writeln(
            '${appLocalizations.rawPayloadLabel}${appLocalizations.nullPayload}');
      }
      buffer.writeln();
    }
    return buffer.toString();
  }
}
