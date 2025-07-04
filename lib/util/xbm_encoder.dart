import 'package:image/image.dart' as img;

/// A utility class to encode an image into the XBM format.
class XbmEncoder {
  /// Encodes a given monochrome [image] into an XBM formatted string.
  ///
  /// The [variableName] is used for the C variable definitions in the output.
  static String encode(img.Image image, String variableName) {
    final width = image.width;
    final height = image.height;
    final buffer = StringBuffer();

    // Write XBM headers
    buffer.writeln('#define ${variableName}_width $width');
    buffer.writeln('#define ${variableName}_height $height');
    buffer.writeln('');
    buffer.writeln('static unsigned char ${variableName}_bits[] = {');

    final bytes = <String>[];
    final rowStride = (width + 7) ~/ 8;

    for (var y = 0; y < height; y++) {
      for (var xByte = 0; xByte < rowStride; xByte++) {
        int currentByte = 0;
        for (var bit = 0; bit < 8; bit++) {
          final x = xByte * 8 + bit;

          if (x < width) {
            final pixel = image.getPixel(x, y);
            // CORRECTED LOGIC: A pixel is part of the foreground if it is NOT
            // pure white. The ExtractQuantizer ensures that all non-target
            // pixels are turned white, so this reliably finds the extracted color.
            if (pixel.r != 255 || pixel.g != 255 || pixel.b != 255) {
              // Set the corresponding bit in the byte. XBM bits are typically
              // ordered from right to left (least significant first).
              currentByte |= (1 << bit);
            }
          }
        }
        bytes.add('0x${currentByte.toRadixString(16).padLeft(2, '0')}');
      }
    }

    // Write the byte array to the buffer, formatted for C.
    for (int i = 0; i < bytes.length; i++) {
      if (i % 12 == 0) {
        buffer.write('\n  ');
      }
      buffer.write('${bytes[i]},');
      if (i % 12 != 11 && i < bytes.length - 1) {
        buffer.write(' ');
      }
    }

    buffer.writeln('\n};');
    return buffer.toString();
  }
}
