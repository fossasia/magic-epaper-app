import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:magic_epaper_app/epdutils.dart';
import 'package:magic_epaper_app/util/extract_quantizer.dart';
import 'package:magic_epaper_app/util/remap_quantizer.dart';

class ImageLoader extends ChangeNotifier {

  img.Image? _orgImg;
  img.Image? _orgCroppedImg;
  final List<img.Image> _processedImgs = List.empty(growable: true);

  Widget get orgCroppedImg {
    if (_orgImg == null) {
      return Image.asset('assets/images/black-red.png');
    }
    final rotatedImg = img.copyRotate(_orgCroppedImg!, angle: 90);
    return Image.memory(img.encodePng(rotatedImg), height: 100, isAntiAlias: false,);
  }

  Widget get processedImgs {
    List<Widget> imgWidgets = List.empty(growable: true);
    for (var i in _processedImgs) {
      var rotatedImg = img.copyRotate(i, angle: 90);
      var uiImage = Image.memory(img.encodePng(rotatedImg), height: 100, isAntiAlias: false, );
      imgWidgets.add(uiImage);
    }
    return Wrap(spacing: 10, direction: Axis.vertical, children: imgWidgets);
  }

  void pickImage({required int width, required int height}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: file!.path,
      aspectRatio: CropAspectRatio(ratioX: width.toDouble(), ratioY: height.toDouble()),
    );

    _processedImgs.clear();
    _orgImg = await img.decodeImageFile(croppedFile!.path);
    _orgImg = _orgImg!.convert(numChannels: 4);

    _orgCroppedImg = img.copyResize(_orgImg!, width: width, height: height);
    processImg();

    notifyListeners();
  }

  img.Image _binaryDither() {
    var image = img.Image.from(_orgCroppedImg!);
    return img.ditherImage(image, quantizer: img.BinaryQuantizer());
  }

  img.Image _halftone() {
    final image = img.Image.from(_orgCroppedImg!);
    img.grayscale(image);
    img.colorHalftone(image);
    return img.ditherImage(image, quantizer: img.BinaryQuantizer());
  }

  img.Image _colorHalftone() {
    var image = img.Image.from(_orgCroppedImg!);

    // Tri-color palette
    final palette = img.PaletteUint8(3, 3);
    palette.setRgb(0, 255, 0, 0); // red
    palette.setRgb(1, 0, 0, 0); // black
    palette.setRgb(2, 255, 255, 255); // white

    img.colorHalftone(image);
    return img.ditherImage(image,
        quantizer: RemapQuantizer(palette: palette),
        kernel: img.DitherKernel.floydSteinberg);
  }

  img.Image _rwbTriColorDither() {
    var image = img.Image.from(_orgCroppedImg!);

    // Tri-color palette
    final palette = img.PaletteUint8(3, 3);
    palette.setRgb(0, 255, 0, 0); // red
    palette.setRgb(1, 0, 0, 0); // black
    palette.setRgb(2, 255, 255, 255); // white

    return img.ditherImage(image,
        quantizer: RemapQuantizer(palette: palette),
        kernel: img.DitherKernel.floydSteinberg);
  }

  img.Image _extractRed() {
    var image = img.Image.from(_orgCroppedImg!);

    return img.ditherImage(image,
        quantizer: ExtractQuantizer(toBeExtract: Colors.red, hThres: 80),
        kernel: img.DitherKernel.none);
  }

  img.Image _experiment() {
    var image = img.Image.from(_orgCroppedImg!);

    // Tri-color palette
    final palette = img.PaletteUint8(3, 3);
    palette.setRgb(0, 255, 0, 0); // red
    palette.setRgb(1, 0, 0, 0); // black
    palette.setRgb(2, 255, 255, 255); // white

    return img.ditherImage(image,
        quantizer: RemapQuantizer(palette: palette),
        kernel: img.DitherKernel.none);
  }

  void processImg() {
    _processedImgs.add(_extractRed());
    // _processedImgs.add(_experiment());
    _processedImgs.add(_rwbTriColorDither());
    _processedImgs.add(_binaryDither());
    _processedImgs.add(_halftone());
    _processedImgs.add(_colorHalftone());
  }

  Uint8List toEpdBitmap(img.Image image) {
    List<int> bytes = List.empty(growable: true);
    int j=0;
    int byte = 0;
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        var bin = image.getPixel(x, y).luminanceNormalized < 0.5 ? 0 : 1;
        if (bin == 1) {
          byte |= 0x80 >> j;
        }

        j++;
        if (j >= 8) {
          bytes.add(byte);
          byte = 0;
          j = 0;
        }
      }
    }

    return Uint8List.fromList(bytes);
  }

  (Uint8List, Uint8List) toEpdBiColor(img.Image image) {
    List<int> red = List.empty(growable: true);
    List<int> black = List.empty(growable: true);
    int j=0;
    int rbyte = 0xff;
    int bbyte = 0;
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        var p = image.getPixel(x, y);
        num excessRed = 2 * p.rNormalized - p.gNormalized - p.bNormalized;
        if (excessRed >= 0.5) { // red
          rbyte &= ~(0x80 >> j);
          // bbyte |= 0x80 >> j; // to make this b-pixel white
        } else if (p.luminanceNormalized >= 0.5) { // black
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
    }
    return (Uint8List.fromList(red), Uint8List.fromList(black));
  }

  void writeToNfc() async {
    debugPrint('$_processedImgs[0]');
    var (red, black) = toEpdBiColor(_processedImgs[0]);
    // final black = toEpdBitmap(_processedImgs[0]);
    // final black = _processedImgs[0].buffer.asUint8List();
    // final red = Uint8List.fromList([]);

    int chunkSize = 220; // NFC tag can handle 255 bytes per chunk.
    List<Uint8List> redChunks = MagicEpd.divideUint8List(red, chunkSize);
    List<Uint8List> blackChunks = MagicEpd.divideUint8List(black, chunkSize);
    MagicEpd.writeChunk(blackChunks, redChunks);
  }
}