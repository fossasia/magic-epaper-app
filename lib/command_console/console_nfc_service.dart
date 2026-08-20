import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class ConsoleNfcService {
  static const _platform = MethodChannel('org.fossasia.magicepaperapp/nfc');
  static const _transceiveTimeout = Duration(seconds: 5);

  NFCTag? _tag;

  NFCTag? get tag => _tag;
  bool get isConnected => _tag != null;

  Future<NFCAvailability> availability() {
    return FlutterNfcKit.nfcAvailability;
  }

  Future<NFCTag> connect({
    Duration timeout = const Duration(seconds: 20),
  }) async {
    final tag = await FlutterNfcKit.poll(
      timeout: timeout,
      androidCheckNDEF: false,
    );
    _tag = tag;
    return tag;
  }

  Future<Uint8List> transceive(Uint8List bytes) {
    return FlutterNfcKit.transceive<Uint8List>(
      bytes,
      timeout: _transceiveTimeout,
    );
  }

  Future<Uint8List> readBlock(int block) {
    final tag = _tag;
    if (tag == null) {
      throw StateError('No tag connected.');
    }
    final uid = Uint8List.fromList(hex.decode(tag.id));
    final builder = BytesBuilder();
    builder.addByte(0x22);
    builder.addByte(0x20);
    builder.add(uid);
    builder.addByte(block);
    return transceive(builder.toBytes());
  }

  Future<void> disconnect() async {
    _tag = null;
    try {
      await FlutterNfcKit.finish();
    } catch (_) {}
    await _restoreReaderMode();
  }

  Future<void> _restoreReaderMode() async {
    try {
      await _platform.invokeMethod('disableNfcReaderMode');
    } on MissingPluginException {
      return;
    } on PlatformException {
      return;
    }
  }
}
