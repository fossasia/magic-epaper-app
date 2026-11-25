import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/vidabay/vidabay_codec.dart';

void main() {
  img.Image solid(int w, int h, int r, int g, int b) {
    final image = img.Image(width: w, height: h);
    for (var y = 0; y < h; y++) {
      for (var x = 0; x < w; x++) {
        image.setPixelRgb(x, y, r, g, b);
      }
    }
    return image;
  }

  final token = [0x00, 0x00, 0x90, 0x00];

  group('pixelCode', () {
    test('maps the BWRY palette', () {
      expect(VidabayCodec.pixelCode(0, 0, 0), VidabayCodec.black);
      expect(VidabayCodec.pixelCode(255, 255, 255), VidabayCodec.white);
      // Flutter's Colors.red / Colors.yellow as produced by the dithering
      expect(VidabayCodec.pixelCode(244, 67, 54), VidabayCodec.red);
      expect(VidabayCodec.pixelCode(255, 235, 59), VidabayCodec.yellow);
      expect(VidabayCodec.pixelCode(128, 128, 128), VidabayCodec.white);
    });
  });

  group('encode (400x400 Snap)', () {
    test('produces 2 bits per pixel', () {
      final data = VidabayCodec.encode(solid(400, 400, 255, 255, 255));
      expect(data.length, 400 * 400 ~/ 4);
      // white = 0b01 in all four pixel slots
      expect(data.every((b) => b == 0x55), isTrue);
    });

    test('rotates: each source row is emitted right to left', () {
      final image = solid(400, 400, 255, 255, 255);
      image.setPixelRgb(399, 0, 255, 0, 0); // top-right -> first pixel
      image.setPixelRgb(0, 0, 0, 0, 0); // top-left -> last pixel of row 0
      image.setPixelRgb(399, 1, 255, 255, 0); // first pixel of row 1

      final data = VidabayCodec.encode(image);

      expect(data[0], 0xD5); // red (11) in the MSBs, then 3x white (01)
      expect(data[99], 0x54); // 3x white, then black (00) in the LSBs
      expect(data[100], 0x95); // yellow (10) in the MSBs of row 1
    });

    test('resizes images that are not 400x400', () {
      // left half black, right half white
      final image = solid(100, 100, 255, 255, 255);
      for (var y = 0; y < 100; y++) {
        for (var x = 0; x < 50; x++) {
          image.setPixelRgb(x, y, 0, 0, 0);
        }
      }

      final data = VidabayCodec.encode(image);

      expect(data.length, 40000);
      // every row: 200 white pixels (right half first), then 200 black
      for (final row in [0, 200, 399]) {
        expect(data.sublist(row * 100, row * 100 + 45).every((b) => b == 0x55),
            isTrue,
            reason: 'row $row, right half');
        expect(
            data.sublist(row * 100 + 55, row * 100 + 100).every((b) => b == 0),
            isTrue,
            reason: 'row $row, left half');
      }
    });
  });

  group('chunks', () {
    test('splits 40000 bytes into 223 chunks of 180 data + sum8', () {
      final data = Uint8List.fromList(List.generate(40000, (i) => i & 0xFF));
      final chunks = VidabayCodec.chunks(data);

      expect(chunks.length, 223);
      for (var c = 0; c < chunks.length; c++) {
        final chunk = chunks[c];
        expect(chunk.length, 181);
        final sum =
            chunk.sublist(0, 180).fold<int>(0, (s, b) => (s + b) & 0xFF);
        expect(chunk[180], sum, reason: 'checksum of chunk $c');
        final end = (c * 180 + 180).clamp(0, data.length);
        expect(chunk.sublist(0, end - c * 180), data.sublist(c * 180, end),
            reason: 'data of chunk $c');
      }
    });

    test('pads the last chunk with 0xFF', () {
      final data = Uint8List.fromList(List.filled(40000, 0x11));
      final last = VidabayCodec.chunks(data).last;

      expect(last.sublist(0, 40).every((b) => b == 0x11), isTrue);
      expect(last.sublist(40, 180).every((b) => b == 0xFF), isTrue);
    });
  });

  group('command payloads', () {
    test('32-byte commands end with the token', () {
      for (final cmd in [
        VidabayCodec.hwInfo(token),
        VidabayCodec.startSession(token),
        VidabayCodec.startTransfer(223, token),
        VidabayCodec.pollRefresh(token),
      ]) {
        expect(cmd.length, 32);
        expect(cmd.sublist(28), token);
      }
      expect(VidabayCodec.probe().length, 32);
      expect(VidabayCodec.getToken().sublist(0, 4), [0x00, 0x4A, 0x01, 0x00]);
    });

    test('start transfer carries the chunk count big-endian', () {
      final cmd = VidabayCodec.startTransfer(223, token);
      expect(cmd.sublist(0, 7), [0x00, 0x4A, 0x09, 0x01, 0x02, 0x00, 0xDF]);
    });

    test('chunk frame: header, 1-based index, chunk, trailing zero', () {
      final chunk = Uint8List.fromList(List.filled(181, 0xAB));
      final frame = VidabayCodec.chunkFrame(300, chunk);

      expect(frame.length, 188);
      expect(frame.sublist(0, 6), [0x00, 0x4A, 0x09, 0x02, 0x01, 0x2C]);
      expect(frame.sublist(6, 187).every((b) => b == 0xAB), isTrue);
      expect(frame.last, 0x00);
    });

    test('APDU wraps the payload as 00 4A 00 00 Lc', () {
      final payload = VidabayCodec.getToken();
      final apdu = VidabayCodec.apdu(payload);
      expect(apdu.sublist(0, 5), [0x00, 0x4A, 0x00, 0x00, 32]);
      expect(apdu.length, 37);
      expect(apdu.sublist(5), payload);
    });
  });
}
