import 'dart:io' show ZLibEncoder;
import 'dart:math' show min;
import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Error raised by the OEPL BLE layer. [message] is safe to show to the user.
class OeplException implements Exception {
  OeplException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// What the badge reports for command 0x0005 ("Read Screen infos").
class OeplDisplayInfo {
  const OeplDisplayInfo({
    required this.width,
    required this.height,
    required this.colors,
  });

  /// Native canvas size in the orientation the firmware expects.
  final int width;
  final int height;

  /// Number of colors excluding white: 1 = BW, 2 = BWR, 3 = BWRY.
  final int colors;

  bool get hasRed => colors >= 2;
  bool get hasYellow => colors >= 3;

  /// [payload] is the notification without the 2 command bytes.
  static OeplDisplayInfo? tryParse(Uint8List payload) {
    if (payload.length < 31) return null;
    int u16(int o) => payload[o] | (payload[o + 1] << 8);

    final inverted = payload[19] == 1;
    final h = inverted ? u16(24) : u16(22);
    final w = inverted ? u16(22) : u16(24);
    if (w <= 0 || h <= 0 || w >= 4000 || h >= 4000) return null;

    return OeplDisplayInfo(width: w, height: h, colors: payload[30]);
  }
}

/// Wire format of the ATC_BLE_OEPL firmware, ported 1:1 from the reference
/// web uploader. Everything here is pure Dart (no BLE) so it can be unit tested.
class OeplProtocol {
  OeplProtocol._();

  static const String serviceUuid = '00001337-0000-1000-8000-00805f9b34fb';
  static const String characteristicUuid = serviceUuid;

  static const int blockDataSize = 4096;
  static const int blockPartDataSize = 230;

  /// ATT header (3) + command (2) + part header (3) + payload (230).
  static const int minMtu = 3 + 2 + 3 + blockPartDataSize;

  // Commands (app -> badge)
  static const int cmdTransferStart = 0x0002; // sent on every block request
  static const int cmdTransferDone = 0x0003; // sent when the upload ends
  static const int cmdReadDisplayInfo = 0x0005;
  static const int cmdDataInfo = 0x0064;
  static const int cmdBlockPart = 0x0065;

  // Notifications (badge -> app)
  static const int evtPartError = 0x00C4;
  static const int evtPartAck = 0x00C5;
  static const int evtBlockRequest = 0x00C6;
  static const int evtUploadOk = 0x00C7;
  static const int evtAlreadyPresent = 0x00C8;
  static const int evtError = 0xFFFF;

  // Data types for cmdDataInfo
  static const int typeRawBw = 0x20;
  static const int typeRawColor = 0x21;
  static const int typeCompressed = 0x30;

  static Uint8List command(int id, [List<int> payload = const []]) {
    final out = Uint8List(2 + payload.length);
    out[0] = (id >> 8) & 0xFF;
    out[1] = id & 0xFF;
    out.setRange(2, out.length, payload);
    return out;
  }

  // ---------------------------------------------------------------- CRC ----

  static final List<int> _crcTable = List<int>.generate(256, (i) {
    var c = i;
    for (var j = 0; j < 8; j++) {
      c = (c & 1) != 0 ? (c >> 1) ^ 0xEDB88320 : c >> 1;
    }
    return c;
  });

  static int crc32(List<int> data) {
    var crc = 0xFFFFFFFF;
    for (final b in data) {
      crc = (crc >> 8) ^ _crcTable[(crc ^ b) & 0xFF];
    }
    return (crc ^ 0xFFFFFFFF) & 0xFFFFFFFF;
  }

  /// `[len lo, len hi, sum lo, sum hi, ...data]`. Used for the whole-image
  /// "version" hash and for every 4 KiB block. The length is deliberately
  /// truncated to 16 bits, exactly like the web uploader does.
  static Uint8List frameWithHeader(List<int> data) {
    final out = Uint8List(4 + data.length);
    var sum = 0;
    for (var i = 0; i < data.length; i++) {
      out[4 + i] = data[i];
      sum += data[i];
    }
    out[0] = data.length & 0xFF;
    out[1] = (data.length >> 8) & 0xFF;
    out[2] = sum & 0xFF;
    out[3] = (sum >> 8) & 0xFF;
    return out;
  }

  static int dataVersion(List<int> payload) => crc32(frameWithHeader(payload));

  // ------------------------------------------------------ data info cmd ----

  static Uint8List dataInfoCommand({
    required int version,
    required int size,
    required int dataType,
  }) {
    final b = ByteData(17);
    b.setUint8(0, 0xFF); // checksum placeholder
    b.setUint32(1, version, Endian.little); // 64-bit LE version, high half = 0
    b.setUint32(5, 0, Endian.little);
    b.setUint32(9, size, Endian.little);
    b.setUint8(13, dataType);
    b.setUint8(14, 0); // data type argument
    b.setUint16(15, 0, Endian.little); // next check-in
    return command(cmdDataInfo, b.buffer.asUint8List());
  }

  // -------------------------------------------------------------- blocks ----

  static int blockCount(int payloadLength) =>
      (payloadLength + blockDataSize - 1) ~/ blockDataSize;

  /// Splits one 4 KiB block of [payload] into ready-to-send 0x0065 commands.
  static List<Uint8List> buildBlockParts(Uint8List payload, int blockId) {
    final start = blockId * blockDataSize;
    final end = min(start + blockDataSize, payload.length);
    final framed = frameWithHeader(payload.sublist(start, end));
    final count = (framed.length + blockPartDataSize - 1) ~/ blockPartDataSize;

    final parts = <Uint8List>[];
    for (var i = 0; i < count; i++) {
      final buf = Uint8List(3 + blockPartDataSize);
      buf[1] = blockId;
      buf[2] = i;
      final from = i * blockPartDataSize;
      final to = min(from + blockPartDataSize, framed.length);
      buf.setRange(3, 3 + (to - from), framed, from);

      var sum = 0;
      for (var k = 1; k < buf.length; k++) {
        sum += buf[k];
      }
      buf[0] = sum & 0xFF;
      parts.add(command(cmdBlockPart, buf));
    }
    return parts;
  }

  // --------------------------------------------------------------- image ----

  /// Packs [image] into the badge bit planes (MSB first, row-major, no row
  /// padding):
  ///   white  -> plane1 0, plane2 0
  ///   black  -> plane1 1, plane2 0
  ///   red    -> plane1 0, plane2 1
  ///   yellow -> plane1 1, plane2 1
  /// Plane 2 is only emitted when the panel has a red and/or yellow channel.
  static Uint8List encodePlanes(
    img.Image image, {
    required bool hasRed,
    required bool hasYellow,
  }) {
    final total = image.width * image.height;
    final planeLen = (total + 7) >> 3;
    final plane1 = Uint8List(planeLen);
    final plane2 = Uint8List(planeLen);

    var bit = 0;
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final p = image.getPixel(x, y);
        final r = p.r;
        final g = p.g;
        final b = p.b;

        var inPlane1 = false;
        var inPlane2 = false;
        if (r < 128 && g < 128 && b < 128) {
          inPlane1 = true;
        } else if (hasYellow && r > 128 && g > 128 && b < 128) {
          inPlane1 = true;
          inPlane2 = true;
        } else if (hasRed && r > 128 && g < 128 && b < 128) {
          inPlane2 = true;
        }

        final mask = 0x80 >> (bit & 7);
        if (inPlane1) plane1[bit >> 3] |= mask;
        if (inPlane2) plane2[bit >> 3] |= mask;
        bit++;
      }
    }

    // The web uploader inverts a zero-filled partial last byte, so the unused
    // trailing bits of plane 1 end up as 1.
    final rem = total & 7;
    if (rem != 0) plane1[planeLen - 1] |= 0xFF >> rem;

    if (!hasRed && !hasYellow) return plane1;
    return (BytesBuilder(copy: false)
          ..add(plane1)
          ..add(plane2))
        .takeBytes();
  }

  /// Builds what gets sent through the block protocol plus its data type.
  static ({Uint8List payload, int dataType}) buildPayload(
    img.Image image, {
    required bool hasRed,
    required bool hasYellow,
    bool compress = true,
  }) {
    final planes = encodePlanes(image, hasRed: hasRed, hasYellow: hasYellow);
    final colored = hasRed || hasYellow;

    if (!compress) {
      return (
        payload: planes,
        dataType: colored ? typeRawColor : typeRawBw,
      );
    }

    final w = image.width;
    final h = image.height;
    final header = Uint8List.fromList([
      0x06,
      w & 0xFF,
      (w >> 8) & 0xFF,
      h & 0xFF,
      (h >> 8) & 0xFF,
      colored ? 2 : 1, // number of planes
    ]);

    final raw = (BytesBuilder(copy: false)
          ..add(header)
          ..add(planes))
        .takeBytes();

    // 4 KiB window: the firmware inflates with a small dictionary.
    final deflated = ZLibEncoder(level: 9, windowBits: 12).convert(raw);

    // The size prefix is the size of the planes, NOT including the 6-byte
    // header (same as the web uploader).
    final out = Uint8List(4 + deflated.length);
    ByteData.view(out.buffer).setUint32(0, planes.length, Endian.little);
    out.setRange(4, out.length, deflated);

    return (payload: out, dataType: typeCompressed);
  }

  /// The badge reports its native canvas size, which is usually the portrait
  /// version of what the app edits (e.g. 128x296 vs 296x128). Rotates when the
  /// sizes are swapped and refuses anything else.
  static img.Image adaptToDisplay(
    img.Image image,
    int width,
    int height, {
    int quarterTurns = 1,
  }) {
    if (image.width == width && image.height == height) return image;
    if (image.width == height && image.height == width) {
      return img.copyRotate(image, angle: quarterTurns == 3 ? 270 : 90);
    }
    throw OeplException(
      'Size mismatch: the badge is ${width}x$height but the image is '
      '${image.width}x${image.height}. Pick the model that matches your badge.',
    );
  }
}
