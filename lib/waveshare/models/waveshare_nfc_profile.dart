import 'package:magicepaperapp/waveshare/models/waveshare_nfc_exception.dart';

class WaveshareNfcProfile {
  static const _displayWidths = [0, 250, 296, 400, 800, 880, 264, 296, 200];
  static const _payloadRows = [0, 122, 128, 300, 480, 528, 176, 128, 200];
  static const _packetLengths = [0, 19, 19, 103, 123, 123, 124, 77, 103];
  static const _packetCounts = [0, 250, 296, 150, 400, 484, 48, 64, 50];
  static const _panelInitCodes = [0, 4, 7, 10, 14, 17, 16, 8, 127];
  static const _secondaryFrameModes = [0, 0, 0, 0, 0, 0, 0, 1, 1];
  static const _acceptedHeights = [0, 128, 128, 300, 480, 528, 176, 128, 200];

  final int type;
  final int displayWidth;
  final int payloadRows;
  final int packetLength;
  final int packetCount;
  final int panelInitCode;
  final bool hasSecondaryFrame;
  final int acceptedHeight;

  const WaveshareNfcProfile._({
    required this.type,
    required this.displayWidth,
    required this.payloadRows,
    required this.packetLength,
    required this.packetCount,
    required this.panelInitCode,
    required this.hasSecondaryFrame,
    required this.acceptedHeight,
  });

  factory WaveshareNfcProfile.fromType(int type) {
    if (type <= 0 || type >= _displayWidths.length) {
      throw WaveshareNfcException(
        'INVALID_DISPLAY',
        'Unsupported Waveshare NFC display type: $type',
      );
    }

    return WaveshareNfcProfile._(
      type: type,
      displayWidth: _displayWidths[type],
      payloadRows: _payloadRows[type],
      packetLength: _packetLengths[type],
      packetCount: _packetCounts[type],
      panelInitCode: _panelInitCodes[type],
      hasSecondaryFrame: _secondaryFrameModes[type] == 1,
      acceptedHeight: _acceptedHeights[type],
    );
  }

  int get payloadLength => packetLength - 3;
  bool get isHdDisplay => type == 8;
  bool get needsRotation => type == 1 || type == 2 || type == 6 || type == 7;

  bool acceptsSize(int width, int height) {
    return width == displayWidth && height == acceptedHeight ||
        width == acceptedHeight && height == displayWidth ||
        _acceptsVisibleSize(width, height);
  }

  bool _acceptsVisibleSize(int width, int height) {
    return type == 1 &&
        (width == displayWidth && height == payloadRows ||
            width == payloadRows && height == displayWidth);
  }
}
