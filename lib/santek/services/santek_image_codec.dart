import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

class SantekImageCodec {
  static const int _white = 0;

  static const int width = 250;
  static const int height = 128;

  static const List<List<int>> _palette = [
    [255, 255, 255],  // 00 → white
    [0, 0, 0],        // 01 → black
    [255, 255, 0],    // 10 → yellow
    [255, 0, 0],      // 11 → red
  ];

  // Off-thread wrapper so the UI stays responsive.
  static Future<Uint8List> encodeAsync(img.Image image) {
    final bytes = Uint8List.fromList(image.getBytes(order: img.ChannelOrder.rgba));
    final packed = Uint8List(8 + bytes.length);
    final bd = packed.buffer.asByteData();
    bd.setInt32(0, image.width);
    bd.setInt32(4, image.height);
    packed.setRange(8, packed.length, bytes);
    return compute(_encodeIsolate, packed);
  }

  static Uint8List _encodeIsolate(Uint8List packed) {
    final bd = packed.buffer.asByteData();
    final w = bd.getInt32(0);
    final h = bd.getInt32(4);
    final bytes = Uint8List.sublistView(packed, 8);
    final image = img.Image.fromBytes(
      width: w,
      height: h,
      bytes: bytes.buffer,
      numChannels: 4,
    );
    return SantekImageCodec().encode(image);
  }

  Uint8List encode(img.Image image) {
    final resized = img.copyResize(
      image,
      width: width,
      height: height,
      interpolation: img.Interpolation.nearest,
    );

    final data = Uint8List(width * height * 2 ~/ 8);
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final p = resized.getPixel(width - 1 - x, y);
        final idx = _nearest(p.r.toInt(), p.g.toInt(), p.b.toInt());
        final bitPos = (x * height + y) * 2;
        data[bitPos >> 3] |= (idx & 0x03) << (6 - (bitPos & 7));
      }
    }
    return data;
  }

  int _nearest(int r, int g, int b) {
    var best = _white;
    var bestDist = 1 << 30;
    for (var i = 0; i < _palette.length; i++) {
      final pr = _palette[i][0], pg = _palette[i][1], pb = _palette[i][2];
      final d = (r - pr) * (r - pr) + (g - pg) * (g - pg) + (b - pb) * (b - pb);
      if (d < bestDist) {
        bestDist = d;
        best = i;
      }
    }
    return best;
  }
}
