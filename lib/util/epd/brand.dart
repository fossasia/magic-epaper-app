import 'package:magicepaperapp/l10n/app_localizations.dart';

enum Brand {
  fossasia,
  goodisplay,
  waveshare,
}

extension BrandLabel on Brand {
  String label(AppLocalizations l) {
    switch (this) {
      case Brand.fossasia:
        return 'FOSSASIA';
      case Brand.goodisplay:
        return 'GoodDisplay';
      case Brand.waveshare:
        return 'Waveshare';
    }
  }
}
