import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';

class ImageHandler {

  img.Image? image;

  // TODO: load SVG
  Future<void> loadRaster(String assetPath) async {
    final imgBin = await rootBundle.load(assetPath);
    final Uint8List byteArray = imgBin.buffer.asUint8List();
    image = img.decodeImage(byteArray)!;
  }

  Uint8List toEpdBitmap() {
    final imgArray = image?.buffer.asUint8List();
    List<int> bytes = List.empty(growable: true);
    int j=0;
    int byte = 0;
    for (int i=3; i<imgArray!.length; i+=4) {
      double gray = (0.299*imgArray[i-3] 
                    + 0.587*imgArray[i-2] 
                    + 0.114*imgArray[i-1]);
                    // * imgArray[i] / 255;
      if (gray >= 127) {
        byte |= 0x80 >> j;
      }

      j++;
      if (j >= 8) {
        bytes.add(byte);
        byte = 0;
        j = 0;
      }
    }
    return Uint8List.fromList(bytes);
  }

  // FIXME: won't work with images that have color channels < 4
  (Uint8List, Uint8List) toEpdBiColor()
  {
    final imgArray = image?.buffer.asUint8List();
    List<int> red = List.empty(growable: true);
    List<int> black = List.empty(growable: true);
    int j=0;
    int rbyte = 0xff;
    int bbyte = 0;
    for (int i=3; i<imgArray!.length; i+=4) {
      double gray = (0.299*imgArray[i-3] 
                    + 0.587*imgArray[i-2] 
                    + 0.114*imgArray[i-1]);
      int excessRed = ((imgArray[i-3] * 2) - imgArray[i-2]) - imgArray[i-1];
      if (excessRed >= 128+64) { // red
        rbyte &= ~(0x80 >> j);
        // bbyte |= 0x80 >> j; // make this b-pixel white
      } else if (gray >= 128+64) { // black
        bbyte |= 0x80 >> j;
      }

      j++;
      if (j >= 8) {
        red.add(rbyte);
        black.add(bbyte);
        rbyte = 0xff;
        bbyte = 0;
        j = 0;
      }
    }
    return (Uint8List.fromList(red), Uint8List.fromList(black));
  }
}