import 'package:magicepaperapp/constants/string_constants.dart';

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
    return '${StringConstants.tagType}${type ?? StringConstants.unknown}\n'
        '${StringConstants.tagId}${id ?? StringConstants.unknown}\n'
        '${StringConstants.ndefAvailable}${ndefAvailable ?? false}\n'
        '${StringConstants.ndefWritable}${ndefWritable ?? false}';
  }
}
