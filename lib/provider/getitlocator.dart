import 'package:get_it/get_it.dart';
import 'package:magic_epaper_app/provider/color_palette_provider.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<ColorPaletteProvider>(
      () => ColorPaletteProvider());
}
