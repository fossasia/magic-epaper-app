import 'package:image/image.dart' as img;

/// Provides functionality to encode images into the XBM (X BitMap) format.
///
/// The XBM format is a monochrome bitmap format commonly used for embedding images in C source code, such as for e-paper displays or microcontroller projects.
class XbmEncoder {
  /// Encodes a given monochrome [image] into an XBM formatted string.
  ///
  /// The [image] must be a monochrome (black and white) image. Each non-white pixel is treated as foreground (bit set to 1),
  /// and white pixels are treated as background (bit set to 0). The resulting string contains C definitions for the image width,
  /// height, and a static unsigned char array with the image data in XBM format.
  ///
  /// The [variableName] parameter is used as the base name for the C variable definitions in the output.
  ///
  /// Returns a string containing the XBM representation of the image, suitable for direct inclusion in C/C++ source files.
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
            // Treat any non-white pixel as foreground (bit set to 1) for XBM encoding.
            if (pixel.r != 255 || pixel.g != 255 || pixel.b != 255) {
              // Set the corresponding bit in the byte. XBM format expects bits to be ordered from least significant to most significant within each byte.
              currentByte |= (1 << bit);
            }
          }
        }
        bytes.add('0x${currentByte.toRadixString(16).padLeft(2, '0')}');
      }
    }

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
