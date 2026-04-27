import 'package:magicepaperapp/util/image_processing/image_processing.dart';
import 'package:magicepaperapp/provider/locale_provider.dart';



class ImageFilterHelper {
  static Map<Function, String> get filterMap => {
        ImageProcessing.bwFloydSteinbergDither: LocaleProvider.current!.floydSteinberg,
        ImageProcessing.bwFalseFloydSteinbergDither:
            LocaleProvider.current!.falseFloydSteinberg,
        ImageProcessing.bwStuckiDither: LocaleProvider.current!.stucki,
        ImageProcessing.bwAtkinsonDither: LocaleProvider.current!.atkinson,
        ImageProcessing.bwThreshold: LocaleProvider.current!.threshold,
        ImageProcessing.bwHalftoneDither: LocaleProvider.current!.halftone,
        ImageProcessing.bwrHalftone: LocaleProvider.current!.colorHalftone,
        ImageProcessing.bwrFloydSteinbergDither:
            LocaleProvider.current!.floydSteinberg,
        ImageProcessing.bwrFalseFloydSteinbergDither:
            LocaleProvider.current!.falseFloydSteinberg,
        ImageProcessing.bwrStuckiDither: LocaleProvider.current!.stucki,
        ImageProcessing.bwrTriColorAtkinsonDither: LocaleProvider.current!.atkinson,
        ImageProcessing.bwrThreshold: LocaleProvider.current!.threshold,
      };

  static String getFilterNameByIndex(
      int index, List<Function> processingMethods) {
    if (index < 0 || index >= processingMethods.length) return "Unknown";
    return filterMap[processingMethods[index]] ?? "Unknown";
  }
}
