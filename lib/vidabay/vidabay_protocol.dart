// Refresh protocol for VidaBay NFC e-paper displays (battery-less, powered
// by the phone's NFC field; Fudan ISO 14443-4 tag).
//
// Every command payload is sent over IsoDep as the APDU
//   00 4A 00 00 <Lc> <payload>
// and the first 2 bytes of every response are dropped ("resp" below).
// Sequence (payloads built in VidabayCodec):
//   probe                -> resp[2..3] == 26 52 means another tag variant
//   GET_TOKEN            -> device info; TOKEN = its last 4 bytes
//                           resp[6..19] firmware string, resp[20] screen mode,
//                           resp[21..22] width, resp[23..24] height (BE16)
//   HW_INFO + TOKEN      -> response ignored
//   START_SESSION + TOKEN
//   START_TRANSFER(N)    -> resp[6..7] = next chunk index wanted (1-based)
//   CHUNK(idx) ...       -> resp[6..7] = next index; N+1 = all received
//   [END_MARKER]         -> only if the firmware version number is > 500
//   100 ms pause, then POLL + TOKEN: one blocking call, the tag answers
//   resp[2..3] == 09 03 once the panel has finished (~18-20 s). The phone
//   must stay on the tag: the panel is powered by the NFC field.
// Android notes: keep the default presence-check delay (125 ms).

import 'dart:typed_data';

import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

import 'vidabay_codec.dart';

AppLocalizations get _l => getIt.get<AppLocalizations>();

typedef VidabayProgressCallback = void Function(double progress, String status);

class VidabayException implements Exception {
  final String message;
  VidabayException(this.message);
  @override
  String toString() => message;
}

class VidabayDeviceInfo {
  final String firmware;
  final int screenMode; // 2 = black/white/yellow/red
  final int width;
  final int height;
  final List<int> token;

  VidabayDeviceInfo(
      this.firmware, this.screenMode, this.width, this.height, this.token);

  /// Number after the last '-' of the firmware string ("SN3G-31-V103" -> 103).
  int get versionNumber {
    final last = firmware.trim().split('-').last;
    return int.tryParse(last.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  }
}

class VidabayProtocol {
  static const Duration _shortTimeout = Duration(seconds: 3);
  // Longest refresh seen: 20.4 s. While the blocking poll waits, Android does
  // not notice a removed tag, so a lifted phone only shows up as a timeout.
  static const Duration _refreshTimeout = Duration(seconds: 25);
  static const int maxAttempts = 3;

  /// Set once all image data has been sent and the panel is refreshing.
  bool _refreshing = false;

  Future<Uint8List> _send(Uint8List payload,
      {Duration timeout = _shortTimeout}) async {
    final raw = await FlutterNfcKit.transceive<Uint8List>(
        VidabayCodec.apdu(payload),
        timeout: timeout);
    if (raw.length < 2) return Uint8List(0);
    return raw.sublist(2);
  }

  static int _be16(Uint8List r, int i) => (r[i] << 8) | r[i + 1];

  Future<VidabayDeviceInfo> _readInfo() async {
    final probe = await _send(VidabayCodec.probe());
    if (probe.length > 3 && probe[2] == 0x26 && probe[3] == 0x52) {
      throw VidabayException(_l.errorReadingTag('tag variant 26 52'));
    }
    final r = await _send(VidabayCodec.getToken());
    if (r.length < 33) {
      throw VidabayException(
          _l.errorWritingToTag('short device info (${r.length} bytes)'));
    }
    final firmware = String.fromCharCodes(r.sublist(6, 20));
    return VidabayDeviceInfo(
        firmware, r[20], _be16(r, 21), _be16(r, 23), r.sublist(r.length - 4));
  }

  /// Connects to the tag, sends the image and waits for the panel refresh.
  ///
  /// Progress reaches 1.0 when all image data has been sent; the display
  /// then refreshes while this future keeps waiting for the tag to report
  /// that it has finished, which completes this future. If that
  /// confirmation does not arrive (phone lifted, badly placed, or the link
  /// dropped just as the panel finished), the link error is thrown.
  ///
  /// Reader mode must stay enabled throughout: FlutterNfcKit.finish()
  /// disables it, and a tag that is (re)discovered while it is off goes to
  /// Android's own tag dispatcher, whose popup pushes the app to the
  /// background, where reader mode no longer sees the tag. So this re-polls
  /// right after a link error (poll() re-arms reader mode before the tag is
  /// rediscovered, ~150 ms) and never calls finish().
  Future<void> send(
    img.Image image, {
    VidabayProgressCallback? onProgress,
    void Function()? onTagDetected,
  }) async {
    final ios = defaultTargetPlatform == TargetPlatform.iOS;
    var opened = false; // only the send that opened the session closes it
    try {
      for (int attempt = 1;; attempt++) {
        try {
          await FlutterNfcKit.poll(
            timeout: const Duration(seconds: 30),
            androidCheckNDEF: false, // no NDEF access: the tag expects none
            readIso14443B: false,
            readIso15693: false,
          );
          opened = true;
          onTagDetected?.call();
          await _session(image, onProgress);
          return;
        } on PlatformException catch (e) {
          // 408 = no tag found in time
          if (ios || e.code == '408' || _refreshing || attempt >= maxAttempts) {
            rethrow;
          }
          onProgress?.call(0.02,
              '${_l.connectionLostDuringTransfer} (${attempt + 1}/$maxAttempts)');
        }
      }
    } finally {
      if (ios && opened) await FlutterNfcKit.finish();
    }
  }

  Future<void> _session(
      img.Image image, VidabayProgressCallback? onProgress) async {
    onProgress?.call(0.02, _l.tagDetectedInitializing);
    await Future.delayed(const Duration(milliseconds: 100));
    final info = await _readInfo();
    if (info.screenMode != 2 || info.width != 400 || info.height != 400) {
      throw VidabayException(_l.errorReadingTag(
          '${info.firmware.trim()}, ${info.width}x${info.height}, mode ${info.screenMode}'));
    }
    final token = info.token;

    final data =
        VidabayCodec.encode(image, width: info.width, height: info.height);
    final chunks = VidabayCodec.chunks(data);
    final n = chunks.length;

    await _send(VidabayCodec.hwInfo(token));
    await _send(VidabayCodec.startSession(token));
    var r = await _send(VidabayCodec.startTransfer(n, token));
    if (r.length < 8) {
      throw VidabayException(_l.errorWritingToTag('start transfer rejected'));
    }
    var next = _be16(r, 6);

    // the tag drives the order: each answer names the next chunk it wants,
    // n + 1 when all are received; resends are allowed, but bounded
    for (var sent = 0; next != n + 1; sent++) {
      if (next < 1 || next > n || sent >= 2 * n) {
        throw VidabayException(
            _l.errorWritingToTag('unexpected chunk request $next'));
      }
      r = await _send(VidabayCodec.chunkFrame(next, chunks[next - 1]));
      if (r.length < 8) {
        throw VidabayException(_l.errorWritingToTag('chunk $next rejected'));
      }
      next = _be16(r, 6);
      final pct = (100 * (next - 1) / n).clamp(0, 99).round();
      onProgress?.call(0.02 + 0.97 * pct / 100, '${_l.writingToEpaper} $pct%');
    }
    if (info.versionNumber > 500) {
      await _send(VidabayCodec.endMarker(n));
    }

    // All image data sent: the panel refreshes now (~18-20 s).
    _refreshing = true;
    onProgress?.call(1.0, '${_l.writingToEpaper} 100%');
    await Future.delayed(const Duration(milliseconds: 100));
    // _refreshTimeout bounds the whole refresh, not each poll
    final deadline = DateTime.now().add(_refreshTimeout);
    for (var left = _refreshTimeout;
        left > Duration.zero;
        left = deadline.difference(DateTime.now())) {
      final p = await _send(VidabayCodec.pollRefresh(token), timeout: left);
      if (p.length > 4 && p[2] == 0x09 && p[3] == 0x03) return;
      await Future.delayed(const Duration(milliseconds: 150));
    }
    throw VidabayException(_l.errorWritingToTag('refresh did not finish'));
  }
}
