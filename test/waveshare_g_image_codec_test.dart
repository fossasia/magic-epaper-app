import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/waveshare/services/waveshare_g_image_codec.dart';

void main() {
  final codec = WaveshareGImageCodec();

  img.Image solid(int w, int h, int r, int g, int b) {
    final image = img.Image(width: w, height: h);
    for (var y = 0; y < h; y++) {
      for (var x = 0; x < w; x++) {
        image.setPixelRgb(x, y, r, g, b);
      }
    }
    return image;
  }

  group('packetCount', () {
    test('matches vendor formula for the 2.13" (G)', () {
      // vendor write4ColorScreen: ceil((w * h / 250) / 2) == 61
      expect(codec.packetCount(250, 122), 61);
      expect(codec.packetCount(122, 250), 61);
    });
  });

  group('portrait framebuffer', () {
    test('122x250 encodes to the panel buffer size (122 * 256 / 4)', () {
      // Native panel orientation is 122 wide x 250 tall; height pads to 256.
      final data = codec.encodeVertical(solid(122, 250, 0, 0, 0));
      expect(data.length, 122 * 256 ~/ 4);
      expect(data.length, 7808);
    });
  });

  group('encodeVertical', () {
    test('all-black image packs to all zero bytes', () {
      final data = codec.encodeVertical(solid(4, 8, 0, 0, 0));
      expect(data.length, 4 * 8 ~/ 4);
      expect(data.every((b) => b == 0), isTrue);
    });

    test('column-major packing, first pixel in the MSB', () {
      // width 4, height 8 (no vertical padding). Make column 0 fully white
      // (code 1 = 0b01), all other columns black (code 0).
      final image = solid(4, 8, 0, 0, 0);
      for (var y = 0; y < 8; y++) {
        image.setPixelRgb(0, y, 255, 255, 255);
      }

      final data = codec.encodeVertical(image);

      // Column 0 -> two bytes, each packing four white pixels: 0b01010101.
      expect(data[0], 0x55);
      expect(data[1], 0x55);
      // Remaining columns are black -> zero.
      for (var i = 2; i < data.length; i++) {
        expect(data[i], 0);
      }
    });

    test('encodes the 2.13" (G) color codes B=0/W=1/Y=2/R=3', () {
      // Single column (width 1, height 4) with black, white, yellow, red.
      final image = img.Image(width: 1, height: 4);
      image.setPixelRgb(0, 0, 0, 0, 0); // black  -> 00
      image.setPixelRgb(0, 1, 255, 255, 255); // white  -> 01
      image.setPixelRgb(0, 2, 255, 255, 0); // yellow -> 10
      image.setPixelRgb(0, 3, 255, 0, 0); // red    -> 11

      // height 4 pads to 8; first byte packs the four visible pixels.
      final data = codec.encodeVertical(image);
      // (00 << 6) | (01 << 4) | (10 << 2) | 11 == 0b00011011
      expect(data[0], 0x1b);
    });
  });
}
