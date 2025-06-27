import 'package:magic_epaper_app/util/image_processing/image_processing.dart';

class ImageFilterHelper {
  static const Map<Function, String> filterMap = {
    ImageProcessing.bwFloydSteinbergDither: 'Floyd-Steinberg',
    ImageProcessing.bwFalseFloydSteinbergDither: 'False Floyd-Steinberg',
    ImageProcessing.bwStuckiDither: 'Stucki',
    ImageProcessing.bwAtkinsonDither: 'Atkinson',
    ImageProcessing.bwThreshold: 'Threshold',
    ImageProcessing.bwHalftoneDither: 'Halftone',
    ImageProcessing.bwrHalftone: 'Color Halftone',
    ImageProcessing.bwrFloydSteinbergDither: 'BWR Floyd-Steinberg',
    ImageProcessing.bwrFalseFloydSteinbergDither: 'BWR False Floyd-Steinberg',
    ImageProcessing.bwrStuckiDither: 'BWR Stucki',
    ImageProcessing.bwrTriColorAtkinsonDither: 'BWR Atkinson',
    ImageProcessing.bwrThreshold: 'BWR Threshold',
  };

  static String getFilterNameByIndex(
      int index, List<Function> processingMethods) {
    if (index < 0 || index >= processingMethods.length) return "Unknown";
    return filterMap[processingMethods[index]] ?? "Unknown";
  }
}
