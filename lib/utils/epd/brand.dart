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
        return l.brandFossasia;
      case Brand.goodisplay:
        return l.brandGoodisplay;
      case Brand.waveshare:
        return l.brandWaveshare;
    }
  }
}
