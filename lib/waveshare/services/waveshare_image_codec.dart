import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:magicepaperapp/waveshare/models/waveshare_nfc_exception.dart';
import 'package:magicepaperapp/waveshare/models/waveshare_nfc_profile.dart';

class WaveshareImageData {
  final Uint8List primary;
  final Uint8List secondary;

  const WaveshareImageData({
    required this.primary,
    required this.secondary,
  });
}

class WaveshareImageCodec {
  static const _bufferLength = 58080;
  static const _white = _Argb(255, 255, 255, 255);

  WaveshareImageData encode(WaveshareNfcProfile profile, img.Image image) {
    final normalized = _normalizeInput(profile, image);
    return profile.isHdDisplay
        ? _encodeHd(profile, normalized)
        : _encodeStandard(profile, normalized);
  }

  img.Image _normalizeInput(WaveshareNfcProfile profile, img.Image image) {
    if (image.width == profile.displayWidth &&
        image.height == profile.acceptedHeight) {
      return image;
    }

    if (image.width == profile.acceptedHeight &&
        image.height == profile.displayWidth) {
      return image;
    }

    if (profile.type == 1 &&
        image.width == profile.displayWidth &&
        image.height == profile.payloadRows) {
      return _copyOnWhiteCanvas(
        image,
        width: profile.displayWidth,
        height: profile.acceptedHeight,
      );
    }

    if (profile.type == 1 &&
        image.width == profile.payloadRows &&
        image.height == profile.displayWidth) {
      return _copyOnWhiteCanvas(
        image,
        width: profile.acceptedHeight,
        height: profile.displayWidth,
      );
    }

    throw WaveshareNfcException(
      'INVALID_IMAGE_RESOLUTION',
      'Incorrect image resolution for Waveshare NFC display type ${profile.type}.',
    );
  }

  img.Image _copyOnWhiteCanvas(
    img.Image source, {
    required int width,
    required int height,
  }) {
    final canvas = img.Image(width: width, height: height, numChannels: 4);
    canvas.clear(img.ColorRgba8(255, 255, 255, 255));

    for (var y = 0; y < source.height && y < height; y++) {
      for (var x = 0; x < source.width && x < width; x++) {
        canvas.setPixel(x, y, source.getPixel(x, y));
      }
    }

    return canvas;
  }

  WaveshareImageData _encodeStandard(
    WaveshareNfcProfile profile,
    img.Image image,
  ) {
    final primary = Uint8List(_bufferLength);
    final secondary = Uint8List(_bufferLength);
    final sourcePixels = _preparedPixels(profile, image);
    final redPixels = profile.hasSecondaryFrame
        ? _preparedPixels(profile, _redMaskImage(image))
        : sourcePixels;

    if (!profile.hasSecondaryFrame) {
      if (profile.type == 1) {
        for (var row = 0; row < 250; row++) {
          for (var byteColumn = 0; byteColumn < 16; byteColumn++) {
            var value = 0;
            for (var bit = 0; bit < 8; bit++) {
              value <<= 1;
              final index = bit + byteColumn * 8 + row * 128;
              if (_pixelAt(sourcePixels, index).b > 128) {
                value |= 1;
              }
            }

            primary[row * 16 + byteColumn] = value & 0xff;
            secondary[row * 16 + byteColumn] = 0;
          }
        }
      } else {
        _encodeBlackWhitePlane(
          profile,
          sourcePixels,
          primary,
          secondary,
        );
      }
    } else {
      _encodeTriColorPlane(
          profile, sourcePixels, redPixels, primary, secondary);
    }

    return WaveshareImageData(primary: primary, secondary: secondary);
  }

  WaveshareImageData _encodeHd(WaveshareNfcProfile profile, img.Image image) {
    final primary = Uint8List(_bufferLength);
    final secondary = Uint8List(_bufferLength);
    final sourcePixels = _flatten(image);
    final redPixels = _flatten(_redMaskImage(image));

    for (var row = 0; row < profile.payloadRows; row++) {
      for (var byteColumn = 0;
          byteColumn < profile.displayWidth ~/ 8;
          byteColumn++) {
        var primaryValue = 0;
        var secondaryValue = 0;

        for (var bit = 0; bit < 8; bit++) {
          primaryValue <<= 1;
          secondaryValue <<= 1;
          final index = bit + byteColumn * 8 + row * profile.displayWidth;
          if (_pixelAt(sourcePixels, index).isWhite) {
            primaryValue |= 1;
          }

          if (_pixelAt(redPixels, index).b < 128) {
            secondaryValue |= 1;
          }
        }

        final outputIndex = row * (profile.displayWidth ~/ 8) + byteColumn;
        primary[outputIndex] = primaryValue & 0xff;
        secondary[outputIndex] = secondaryValue & 0xff;
      }
    }

    return WaveshareImageData(primary: primary, secondary: secondary);
  }

  void _encodeBlackWhitePlane(
    WaveshareNfcProfile profile,
    List<_Argb> sourcePixels,
    Uint8List primary,
    Uint8List secondary,
  ) {
    for (var row = 0; row < profile.payloadRows; row++) {
      for (var byteColumn = 0;
          byteColumn < profile.displayWidth ~/ 8;
          byteColumn++) {
        var value = 0;

        for (var bit = 0; bit < 8; bit++) {
          value <<= 1;
          final index = bit + byteColumn * 8 + row * profile.displayWidth;
          if (_pixelAt(sourcePixels, index).b > 128) {
            value |= 1;
          }
        }

        final outputIndex = row * (profile.displayWidth ~/ 8) + byteColumn;
        primary[outputIndex] = value & 0xff;
        secondary[outputIndex] = 0;
      }
    }
  }

  void _encodeTriColorPlane(
    WaveshareNfcProfile profile,
    List<_Argb> sourcePixels,
    List<_Argb> redPixels,
    Uint8List primary,
    Uint8List secondary,
  ) {
    for (var row = 0; row < profile.payloadRows; row++) {
      for (var byteColumn = 0;
          byteColumn < profile.displayWidth ~/ 8;
          byteColumn++) {
        var primaryValue = 0;
        var secondaryValue = 0;

        for (var bit = 0; bit < 8; bit++) {
          primaryValue <<= 1;
          secondaryValue <<= 1;
          final index = bit + byteColumn * 8 + row * profile.displayWidth;

          if (_pixelAt(sourcePixels, index).isWhite) {
            primaryValue |= 1;
          }

          if (_pixelAt(redPixels, index).b > 128) {
            secondaryValue |= 1;
          }
        }

        final outputIndex = row * (profile.displayWidth ~/ 8) + byteColumn;
        primary[outputIndex] = primaryValue & 0xff;
        secondary[outputIndex] = secondaryValue & 0xff;
      }
    }
  }

  List<_Argb> _preparedPixels(WaveshareNfcProfile profile, img.Image image) {
    final prepared =
        profile.needsRotation ? img.copyRotate(image, angle: 270) : image;
    return _flatten(prepared);
  }

  List<_Argb> _flatten(img.Image image) {
    final pixels = List<_Argb>.filled(image.width * image.height, _white);
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        pixels[y * image.width + x] = _Argb.fromPixel(image.getPixel(x, y));
      }
    }
    return pixels;
  }

  img.Image _redMaskImage(img.Image image) {
    final output = img.Image.from(image);

    for (var y = 1; y < image.height; y++) {
      for (var x = 1; x < image.width - 1; x++) {
        final current = _Argb.fromPixel(image.getPixel(x, y));
        final right = _Argb.fromPixel(image.getPixel(x + 1, y));
        final upperRight = _Argb.fromPixel(image.getPixel(x + 1, y - 1));
        final upper = _Argb.fromPixel(image.getPixel(x, y - 1));
        final upperLeft = _Argb.fromPixel(image.getPixel(x - 1, y - 1));

        if (_isWaveshareRed(current) &&
            _isWaveshareRed(right) &&
            _isWaveshareRed(upperRight) &&
            _isWaveshareRed(upper) &&
            _isWaveshareRed(upperLeft)) {
          output.setPixelRgba(x, y, upperLeft.r, 0, 0, 255);
        } else {
          output.setPixelRgba(x, y, 255, 255, 255, 255);
        }
      }
    }

    return output;
  }

  bool _isWaveshareRed(_Argb pixel) {
    return pixel.r > 150 && pixel.g < 150 && pixel.b < 200;
  }

  _Argb _pixelAt(List<_Argb> pixels, int index) {
    if (index < 0 || index >= pixels.length) {
      return _white;
    }
    return pixels[index];
  }
}

class _Argb {
  final int a;
  final int r;
  final int g;
  final int b;

  const _Argb(this.a, this.r, this.g, this.b);

  factory _Argb.fromPixel(img.Pixel pixel) {
    return _Argb(
      pixel.a.toInt(),
      pixel.r.toInt(),
      pixel.g.toInt(),
      pixel.b.toInt(),
    );
  }

  bool get isWhite => a == 255 && r == 255 && g == 255 && b == 255;
}
