// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get appTitle => 'magicepaperapp_2';
}

/// The translations for Norwegian Bokmål, as used in Norway (`nb_NO`).
class AppLocalizationsNbNo extends AppLocalizationsNb {
  AppLocalizationsNbNo() : super('nb_NO');
}
