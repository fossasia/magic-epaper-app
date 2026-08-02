import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Encodes images for Gicisky / Picksmart BLE ESL tags.
///
/// Based on the reverse-engineered format used by atc1441 and the
/// gicisky-tag Python library. Currently targets the common
/// 250x122 BWR (black/white/red) model using uncompressed line data.
///
/// Image layout after rotation: width=250, height=122.
class GiciskyEncoder {
  static const List<int> _black = [0, 0, 0];
  static const List<int> _white = [255, 255, 255];
  static const List<int> _red = [255, 0, 0];

  /// Encode a processed BWR image into the payload expected by the tag.
  ///
  /// [image] should already be sized to [width] x [height] and contain
  /// only black, white and red pixels (dithered).
  static Uint8List encode(
    img.Image image, {
    int width = 250,
    int height = 122,
  }) {
    if (image.width != width || image.height != height) {
      image = img.copyResize(image, width: width, height: height);
    }

    // Build bitmaps: true = white (for BW plane), true = red (for red plane).
    // After rotation the Python code expects shape (width, height) with
    // columns packed.
    final bwBitmap = List.generate(width, (_) => List.filled(height, false));
    final redBitmap = List.generate(width, (_) => List.filled(height, false));

    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final p = image.getPixel(x, y);
        final r = p.r.toInt();
        final g = p.g.toInt();
        final b = p.b.toInt();

        final isRed = _isCloser(r, g, b, _red);
        final isWhite = !isRed && _isCloser(r, g, b, _white);

        // Rotate 90° CCW equivalent used by reference: flipud + rot90
        // Here we store column-major as the compressor expects.
        final col = x;
        final row = height - 1 - y;
        bwBitmap[col][row] = isWhite;
        redBitmap[col][row] = isRed;
      }
    }

    final bwData = _compressBitmap(bwBitmap, width, height);
    final redData = _compressBitmap(redBitmap, width, height);

    final payload = BytesBuilder();
    final totalLen = bwData.length + redData.length;
    payload.add(_intToLittleEndian(totalLen, 4));
    payload.add(bwData);
    payload.add(redData);
    return payload.toBytes();
  }

  static bool _isCloser(int r, int g, int b, List<int> target) {
    final dr = r - target[0];
    final dg = g - target[1];
    final db = b - target[2];
    final dist = dr * dr + dg * dg + db * db;
    // Simple threshold: closer to target than to the other primaries
    return dist < 20000;
  }

  /// Uncompressed line encoding used by the Python reference
  /// (compression markers all zero).
  static Uint8List _compressBitmap(
    List<List<bool>> bitmap,
    int width,
    int height,
  ) {
    final numLineBytes = math.ceil(height / 8).toInt();
    final out = BytesBuilder();
    const compressionMarkers = [0, 0, 0, 0];

    for (var col = 0; col < width; col++) {
      final lineBytes = List<int>.filled(numLineBytes, 0);
      for (var row = 0; row < height; row++) {
        if (bitmap[col][row]) {
          final byteIndex = row ~/ 8;
          final bitIndex = 7 - (row % 8);
          lineBytes[byteIndex] |= 1 << bitIndex;
        }
      }

      // 0x75 | length | num_line_bytes | markers | line data
      final lineLen = 3 + compressionMarkers.length + lineBytes.length;
      out.addByte(0x75);
      out.addByte(lineLen);
      out.addByte(numLineBytes);
      out.add(compressionMarkers);
      out.add(lineBytes);
    }
    return out.toBytes();
  }

  static Uint8List _intToLittleEndian(int value, int byteCount) {
    final bytes = Uint8List(byteCount);
    for (var i = 0; i < byteCount; i++) {
      bytes[i] = (value >> (8 * i)) & 0xff;
    }
    return bytes;
  }
}
