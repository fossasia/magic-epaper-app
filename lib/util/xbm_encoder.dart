import 'dart:typed_data';
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
    // Calculate the number of bytes needed for each row of pixels.
    final rowStride = (width + 7) ~/ 8;

    for (var y = 0; y < height; y++) {
      for (var xByte = 0; xByte < rowStride; xByte++) {
        int currentByte = 0;
        for (var bit = 0; bit < 8; bit++) {
          final x = xByte * 8 + bit;

          // Ensure we don't read past the image's width
          if (x < width) {
            final pixel = image.getPixel(x, y);
            // In a monochrome image, a pixel's "on" state is typically white.
            // We check the red channel, but luminance would also work.
            if (pixel.r > 128) {
              // Set the corresponding bit in the byte.
              // XBM bits are typically ordered from right to left.
              currentByte |= (1 << bit);
            }
          }
        }
        // Add the hex representation of the byte to our list.
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
