import 'package:get_it/get_it.dart';
import 'package:magicepaperapp/provider/color_palette_provider.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<ColorPaletteProvider>(
      () => ColorPaletteProvider());
}


void registerAppLocalizations(AppLocalizations appLocalizations) {
  if (getIt.isRegistered<AppLocalizations>()) {
    getIt.unregister<AppLocalizations>();
  }
  getIt.registerLazySingleton<AppLocalizations>(() => appLocalizations);
}