import 'dart:async';
import 'dart:math' show min;
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:universal_ble/universal_ble.dart';

import 'oepl_protocol.dart';


typedef OeplProgressCallback = void Function(double? progress, String status);

enum OeplUploadResult {
  uploaded,
  alreadyPresent,
}

class _UploadSession {
  _UploadSession(this.payload, this.onProgress);

  final Uint8List payload;
  final OeplProgressCallback? onProgress;
  final Completer<OeplUploadResult> completer = Completer<OeplUploadResult>();

  List<Uint8List> parts = const [];
  int partIndex = 0;
  int blockId = 0;
  int partErrors = 0;

  void fail(Object error) {
    if (!completer.isCompleted) completer.completeError(error);
  }
}


class OeplBleClient {
  OeplBleClient({this.onLog});

  static const String defaultNamePrefix = 'ATC_';
  static const int _maxPartRetries = 10;

  final void Function(String message)? onLog;

  String? _deviceId;
  bool _disconnected = false;
  StreamSubscription<bool>? _connectionSub;
  StreamSubscription<Uint8List>? _valueSub;

  Future<void> _handlerChain = Future<void>.value();

  Completer<OeplDisplayInfo?>? _infoCompleter;
  _UploadSession? _session;
  Timer? _watchdog;
  Duration _inactivityTimeout = const Duration(seconds: 30);

  bool get isConnected => _deviceId != null && !_disconnected;

  void _log(String message) => onLog?.call(message);


  static Stream<BleDevice> scan({
    List<String> namePrefixes = const [defaultNamePrefix],
    Duration timeout = const Duration(seconds: 20),
  }) {
    final prefixes = namePrefixes.map((p) => p.toLowerCase()).toList();
    final seen = <String>{};

    late final StreamController<BleDevice> controller;
    StreamSubscription<BleDevice>? sub;
    Timer? timer;

    Future<void> shutdown() async {
      timer?.cancel();
      await sub?.cancel();
      sub = null;
      try {
        await UniversalBle.stopScan();
      } catch (_) {}
    }

    controller = StreamController<BleDevice>(
      onListen: () async {
        sub = UniversalBle.scanStream.listen((device) {
          final name = (device.name ?? '').toLowerCase();
          final matches = prefixes.any((p) => name.startsWith(p));
          if (matches && seen.add(device.deviceId)) {
            controller.add(device);
          }
        });
        try {
          await UniversalBle.startScan();
          timer = Timer(timeout, () async {
            await shutdown();
            await controller.close();
          });
        } catch (e, st) {
          controller.addError(e, st);
          await shutdown();
          await controller.close();
        }
      },
      onCancel: shutdown,
    );
    return controller.stream;
  }


  static bool _isOeplUuid(String uuid) {
    final u = uuid.toLowerCase();
    return u == '1337' || u.startsWith('00001337-');
  }

  Future<void> connect(String deviceId) async {
    _deviceId = deviceId;
    _disconnected = false;

    await UniversalBle.connect(deviceId, timeout: const Duration(seconds: 20));

    _connectionSub =
        UniversalBle.connectionStream(deviceId).listen((connected) {
      if (!connected) _handleDisconnect();
    });

    try {
      final mtu = await UniversalBle.requestMtu(deviceId, 247);
      _log('MTU: $mtu');
      if (mtu < OeplProtocol.minMtu) {
        _log('Warning: MTU $mtu < ${OeplProtocol.minMtu}, writes may fail.');
      }
    } catch (e) {
      _log('MTU request failed: $e');
    }

    final services = await UniversalBle.discoverServices(deviceId);
    if (!services.any((s) => _isOeplUuid(s.uuid))) {
      throw OeplException(
        'This device does not expose the OEPL service (0x1337). '
        'Is it running ATC_BLE_OEPL?',
      );
    }

    _valueSub = UniversalBle.characteristicValueStream(
      deviceId,
      OeplProtocol.characteristicUuid,
    ).listen(_onNotification);
    await UniversalBle.subscribeNotifications(
      deviceId,
      OeplProtocol.serviceUuid,
      OeplProtocol.characteristicUuid,
    );
    _log('Connected to $deviceId');
  }

  void _handleDisconnect() {
    _disconnected = true;
    _session?.fail(OeplException('The badge disconnected.'));
    _infoCompleter?.complete(null);
    _infoCompleter = null;
  }

  Future<void> disconnect() async {
    final id = _deviceId;
    _deviceId = null;
    _watchdog?.cancel();
    await _valueSub?.cancel();
    await _connectionSub?.cancel();
    _valueSub = null;
    _connectionSub = null;
    if (id != null) {
      try {
        await UniversalBle.disconnect(id);
      } catch (_) {}
    }
  }

  /// Makes a running [uploadImage] fail with "cancelled".
  void abort() => _session?.fail(OeplException('Transfer cancelled.'));

  // ------------------------------------------------------------- commands ----

  void _requireConnected() {
    if (!isConnected) throw OeplException('Not connected to a badge.');
  }

  Future<void> _send(Uint8List data) async {
    final id = _deviceId;
    if (id == null || _disconnected) {
      throw OeplException('Not connected to a badge.');
    }
    await UniversalBle.write(
      id,
      OeplProtocol.serviceUuid,
      OeplProtocol.characteristicUuid,
      data,
      withoutResponse: true,
    );
  }

  Future<OeplDisplayInfo?> readDisplayInfo({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    _requireConnected();
    final completer = Completer<OeplDisplayInfo?>();
    _infoCompleter = completer;
    await _send(OeplProtocol.command(OeplProtocol.cmdReadDisplayInfo));
    return completer.future.timeout(timeout, onTimeout: () {
      _infoCompleter = null;
      return null;
    });
  }

  Future<OeplUploadResult> uploadImage({
    required img.Image image,
    required bool hasRed,
    required bool hasYellow,
    bool compress = true,
    OeplProgressCallback? onProgress,
    Duration inactivityTimeout = const Duration(seconds: 30),
  }) async {
    _requireConnected();
    onProgress?.call(null, 'Encoding image…');

    final built = OeplProtocol.buildPayload(
      image,
      hasRed: hasRed,
      hasYellow: hasYellow,
      compress: compress,
    );
    _log('Payload: ${built.payload.length} bytes, type 0x'
        '${built.dataType.toRadixString(16)}');

    final session = _UploadSession(built.payload, onProgress);
    _session = session;
    _inactivityTimeout = inactivityTimeout;
    _armWatchdog();

    try {
      await _send(OeplProtocol.dataInfoCommand(
        version: OeplProtocol.dataVersion(built.payload),
        size: built.payload.length,
        dataType: built.dataType,
      ));
      onProgress?.call(0, 'Waiting for the badge…');
      return await session.completer.future;
    } finally {
      _watchdog?.cancel();
      _session = null;
    }
  }

  void _armWatchdog() {
    _watchdog?.cancel();
    final session = _session;
    if (session == null) return;
    _watchdog = Timer(_inactivityTimeout, () {
      session.fail(OeplException('The badge stopped responding.'));
    });
  }

  void _reportProgress(_UploadSession s, String status) {
    final total = s.payload.length;
    final sent = min(
      s.blockId * OeplProtocol.blockDataSize +
          s.partIndex * OeplProtocol.blockPartDataSize,
      total,
    );
    s.onProgress?.call(total == 0 ? 1.0 : sent / total, status);
  }

  void _onNotification(Uint8List data) {
    if (data.length < 2) return;
    if (_session != null) _armWatchdog();
    _handlerChain = _handlerChain.then((_) => _process(data)).catchError(
      (Object e) {
        _log('Handler error: $e');
        _session?.fail(e);
      },
    );
  }

  Future<void> _process(Uint8List data) async {
    final cmd = (data[0] << 8) | data[1];
    final payload = Uint8List.sublistView(data, 2);

    switch (cmd) {
      case OeplProtocol.cmdReadDisplayInfo:
        _infoCompleter?.complete(OeplDisplayInfo.tryParse(payload));
        _infoCompleter = null;
      case OeplProtocol.evtBlockRequest:
        await _onBlockRequest(payload);
      case OeplProtocol.evtPartAck:
        await _onPartAck();
      case OeplProtocol.evtPartError:
        await _onPartError();
      case OeplProtocol.evtUploadOk:
        await _finish(OeplUploadResult.uploaded);
      case OeplProtocol.evtAlreadyPresent:
        await _finish(OeplUploadResult.alreadyPresent);
      case OeplProtocol.evtError:
        _session?.fail(OeplException('The badge rejected the command.'));
      default:
        _log('Unhandled notification 0x${cmd.toRadixString(16)}');
    }
  }

  Future<void> _onBlockRequest(Uint8List payload) async {
    final s = _session;
    if (s == null) return;
    if (payload.length < 11) {
      s.fail(OeplException('Malformed block request from the badge.'));
      return;
    }

    final blockId = payload[9];
    final blocks = OeplProtocol.blockCount(s.payload.length);
    if (blockId >= blocks) {
      s.fail(OeplException('The badge asked for block $blockId of $blocks.'));
      return;
    }

    s.blockId = blockId;
    s.partErrors = 0;
    s.partIndex = 0;
    s.parts = OeplProtocol.buildBlockParts(s.payload, blockId);
    _reportProgress(s, 'Sending block ${blockId + 1}/$blocks…');

    await _send(OeplProtocol.command(OeplProtocol.cmdTransferStart));
    await Future<void>.delayed(const Duration(milliseconds: 50));
    await _send(s.parts[0]);
  }

  Future<void> _onPartAck() async {
    final s = _session;
    if (s == null || s.parts.isEmpty) return;

    s.partIndex++;
    s.partErrors = 0;
    final blocks = OeplProtocol.blockCount(s.payload.length);
    _reportProgress(s, 'Sending block ${s.blockId + 1}/$blocks…');

    if (s.partIndex < s.parts.length) {
      await _send(s.parts[s.partIndex]);
    }
  }

  Future<void> _onPartError() async {
    final s = _session;
    if (s == null || s.partIndex >= s.parts.length) return;

    s.partErrors++;
    if (s.partErrors > _maxPartRetries) {
      s.fail(OeplException('Too many transmission errors.'));
      return;
    }
    _log('Part ${s.partIndex} of block ${s.blockId} failed, retrying '
        '(${s.partErrors}/$_maxPartRetries)');
    await Future<void>.delayed(const Duration(milliseconds: 100));
    await _send(s.parts[s.partIndex]);
  }

  Future<void> _finish(OeplUploadResult result) async {
    final s = _session;
    if (s == null) return;
    try {
      await _send(OeplProtocol.command(OeplProtocol.cmdTransferDone));
      await Future<void>.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      _log('Could not send transfer-done: $e');
    }
    if (!s.completer.isCompleted) s.completer.complete(result);
  }
}
