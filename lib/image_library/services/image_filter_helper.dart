import 'package:magicepaperapp/util/image_processing/image_processing.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

AppLocalizations appLocalizations = getIt.get<AppLocalizations>();

class ImageFilterHelper {
  static Map<Function, String> get filterMap => {
        ImageProcessing.bwFloydSteinbergDither: appLocalizations.floydSteinberg,
        ImageProcessing.bwFalseFloydSteinbergDither:
            appLocalizations.falseFloydSteinberg,
        ImageProcessing.bwStuckiDither: appLocalizations.stucki,
        ImageProcessing.bwAtkinsonDither: appLocalizations.atkinson,
        ImageProcessing.bwThreshold: appLocalizations.threshold,
        ImageProcessing.bwHalftoneDither: appLocalizations.halftone,
        ImageProcessing.bwrHalftone: appLocalizations.colorHalftone,
        ImageProcessing.bwrFloydSteinbergDither:
            appLocalizations.floydSteinberg,
        ImageProcessing.bwrFalseFloydSteinbergDither:
            appLocalizations.falseFloydSteinberg,
        ImageProcessing.bwrStuckiDither: appLocalizations.stucki,
        ImageProcessing.bwrTriColorAtkinsonDither: appLocalizations.atkinson,
        ImageProcessing.bwrThreshold: appLocalizations.threshold,
      };

  static String getFilterNameByIndex(
      int index, List<Function> processingMethods) {
    if (index < 0 || index >= processingMethods.length) return "Unknown";
    return filterMap[processingMethods[index]] ?? "Unknown";
  }
}
