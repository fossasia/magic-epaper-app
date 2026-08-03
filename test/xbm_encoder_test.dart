// Tests for lib/util/xbm_encoder.dart, which produces the .xbm files
// consumed by GxEPD2's drawXBitmap() in the "Arduino / GxEPD Export" flow
// (see https://github.com/fossasia/magic-epaper-app/issues/183).

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/util/xbm_encoder.dart';

img.Image _blackWhiteImage(int width, int height, Set<int> blackXs) {
  final image = img.Image(width: width, height: height, numChannels: 4);
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      if (blackXs.contains(x)) {
        image.setPixelRgba(x, y, 0, 0, 0, 255);
      } else {
        image.setPixelRgba(x, y, 255, 255, 255, 255);
      }
    }
  }
  return image;
}

void main() {
  group('XbmEncoder.encode', () {
    test('writes width/height #define headers and array name', () {
      final image = _blackWhiteImage(8, 1, {});
      final result = XbmEncoder.encode(image, 'my_image');

      expect(result, contains('#define my_image_width 8'));
      expect(result, contains('#define my_image_height 1'));
      expect(result, contains('static unsigned char my_image_bits[] = {'));
      expect(result.trim(), endsWith('};'));
    });

    test('an all-white image encodes to all-zero bytes', () {
      final image = _blackWhiteImage(8, 2, {});
      final result = XbmEncoder.encode(image, 'blank');

      expect(result, contains('0x00, 0x00,'));
      expect(result, isNot(contains(RegExp(r'0x(?!00)'))));
    });

    test('sets bit 0 (LSB) for the leftmost pixel of a byte', () {
      // XBM is LSB-first: the leftmost pixel in a byte maps to bit 0.
      final image = _blackWhiteImage(8, 1, {0});
      final result = XbmEncoder.encode(image, 'img');
      expect(result, contains('0x01,'));
    });

    test('sets bit 7 (MSB) for the rightmost pixel of a full byte', () {
      final image = _blackWhiteImage(8, 1, {7});
      final result = XbmEncoder.encode(image, 'img');
      expect(result, contains('0x80,'));
    });

    test('a fully black single byte row encodes to 0xff', () {
      final image = _blackWhiteImage(8, 1, {0, 1, 2, 3, 4, 5, 6, 7});
      final result = XbmEncoder.encode(image, 'img');
      expect(result, contains('0xff,'));
    });

    test('pads the final partial byte of a non-multiple-of-8 width', () {
      // width=3 -> 1 byte per row (rowStride = ceil(3/8) = 1), only the
      // low 3 bits can ever be set; out-of-range bits (3..7) stay 0.
      final allBlack = _blackWhiteImage(3, 1, {0, 1, 2});
      final result = XbmEncoder.encode(allBlack, 'img');
      // 0b0000_0111 = 0x07
      expect(result, contains('0x07,'));
    });

    test('row stride is independent per row for multi-row images', () {
      // 9px wide -> 2 bytes/row (ceil(9/8)=2). Row 0 all black, row 1 all white.
      final image = img.Image(width: 9, height: 2, numChannels: 4);
      for (var x = 0; x < 9; x++) {
        image.setPixelRgba(x, 0, 0, 0, 0, 255);
        image.setPixelRgba(x, 1, 255, 255, 255, 255);
      }
      final result = XbmEncoder.encode(image, 'img');

      // Row 0: byte0 = 0xff (bits 0-7 set), byte1 = 0x01 (only bit0/x=8 set).
      // Row 1: byte0 = 0x00, byte1 = 0x00.
      expect(result, contains('0xff, 0x01,'));
      expect(result, contains('0x00, 0x00,'));
    });

    test('treats any non-white pixel as foreground, not just pure black',
        () {
      final image = img.Image(width: 1, height: 1, numChannels: 4);
      image.setPixelRgba(0, 0, 200, 0, 0, 255); // dark red, not pure black
      final result = XbmEncoder.encode(image, 'img');
      expect(result, contains('0x01,'));
    });
  });
}
