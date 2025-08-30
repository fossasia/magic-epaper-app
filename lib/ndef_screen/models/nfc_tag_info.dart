import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

AppLocalizations appLocalizations = getIt.get<AppLocalizations>();

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
    return '${appLocalizations.tagType}${type ?? appLocalizations.unknown}\n'
        '${appLocalizations.tagId}${id ?? appLocalizations.unknown}\n'
        '${appLocalizations.ndefAvailable}${ndefAvailable ?? false}\n'
        '${appLocalizations.ndefWritable}${ndefWritable ?? false}';
  }
}
