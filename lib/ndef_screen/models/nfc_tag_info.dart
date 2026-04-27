import 'package:magicepaperapp/provider/locale_provider.dart';


class NFCTagInfo {
  final String? type;
  final String? id;
  final bool? ndefAvailable;
  final bool? ndefWritable;

  NFCTagInfo({
    this.type,
    this.id,
    this.ndefAvailable,
    this.ndefWritable,
  });

  @override
  String toString() {
    return '${LocaleProvider.current!.tagType}${type ?? LocaleProvider.current!.unknown}\n'
        '${LocaleProvider.current!.tagId}${id ?? LocaleProvider.current!.unknown}\n'
        '${LocaleProvider.current!.ndefAvailable}${ndefAvailable ?? false}\n'
        '${LocaleProvider.current!.ndefWritable}${ndefWritable ?? false}';
  }
}
