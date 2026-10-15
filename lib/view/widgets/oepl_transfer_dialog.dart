import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/theme/colors.dart';
import 'package:magicepaperapp/utils/epd/oepl_ble_displays.dart';
import 'package:universal_ble/universal_ble.dart';

import '../../utils/epd/oepl_ble_client.dart';
import '../../utils/epd/oepl_protocol.dart';

// TODO: move these strings to the ARB files like the rest of the app.
class _Texts {
  static const scanning = 'Looking for badges named ATC_…';
  static const noneFound = 'No badge found yet. Make sure it is powered on and close to the phone.';
  static const pickBadge = 'Select your badge';
  static const rescan = 'Scan again';
  static const cancel = 'Cancel';
  static const close = 'Close';
  static const retry = 'Try again';
  static const bluetoothOff = 'Bluetooth is off, unsupported or not authorized.';
  static const uploaded =
      'Image sent. The badge refreshes its screen now, this can take a few seconds.';
  static const alreadyPresent =
      'The badge already shows this exact image, so it was not refreshed.';
}

enum _Phase { scanning, transferring, done, failed }

class OeplTransferDialog extends StatefulWidget {
  const OeplTransferDialog({
    super.key,
    required this.image,
    required this.display,
  });

  final img.Image image;
  final OeplBleDisplay display;

  static Future<void> show(
    BuildContext context, {
    required img.Image image,
    required OeplBleDisplay display,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => OeplTransferDialog(image: image, display: display),
    );
  }

  @override
  State<OeplTransferDialog> createState() => _OeplTransferDialogState();
}

class _OeplTransferDialogState extends State<OeplTransferDialog> {
  final OeplBleClient _client =
      OeplBleClient(onLog: (m) => debugPrint('[OEPL] $m'));
  final Map<String, BleDevice> _devices = {};

  StreamSubscription<BleDevice>? _scanSub;
  _Phase _phase = _Phase.scanning;
  bool _scanActive = false;
  String _status = '';
  double? _progress;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  @override
  void dispose() {
    _scanSub?.cancel();
    _client.disconnect();
    super.dispose();
  }

  Future<void> _startScan() async {
    await _scanSub?.cancel();
    if (!mounted) return;
    setState(() {
      _phase = _Phase.scanning;
      _devices.clear();
      _scanActive = true;
    });

    try {
      final state = await UniversalBle.getBluetoothAvailabilityState();
      if (state == AvailabilityState.poweredOff ||
          state == AvailabilityState.unauthorized ||
          state == AvailabilityState.unsupported) {
        throw OeplException(_Texts.bluetoothOff);
      }
      if (!mounted) return;

      _scanSub = OeplBleClient.scan().listen(
        (device) {
          if (mounted) setState(() => _devices[device.deviceId] = device);
        },
        onError: (Object e) => _fail(e),
        onDone: () {
          if (mounted) setState(() => _scanActive = false);
        },
      );
    } catch (e) {
      _fail(e);
    }
  }

  void _fail(Object error) {
    if (!mounted) return;
    setState(() {
      _phase = _Phase.failed;
      _scanActive = false;
      _message = error is OeplException ? error.message : '$error';
    });
  }

  void _setProgress(double? progress, String status) {
    if (!mounted) return;
    setState(() {
      _progress = progress;
      _status = status;
    });
  }

  Future<void> _transfer(BleDevice device) async {
    await _scanSub?.cancel();
    _scanSub = null;
    if (!mounted) return;

    setState(() {
      _phase = _Phase.transferring;
      _scanActive = false;
      _progress = null;
      _status = 'Connecting to ${device.name ?? device.deviceId}…';
    });

    try {
      await _client.connect(device.deviceId);

      _setProgress(null, 'Reading display info…');
      final info = await _client.readDisplayInfo();

      var image = widget.image;
      // Fallback when the badge doesn't answer: trust the selected model.
      var hasRed = widget.display.colors.length >= 3;
      var hasYellow = widget.display.colors.length >= 4;
      if (info != null) {
        image = OeplProtocol.adaptToDisplay(
          image,
          info.width,
          info.height,
          quarterTurns: widget.display.quarterTurns,
        );
        hasRed = info.hasRed;
        hasYellow = info.hasYellow;
      }

      final result = await _client.uploadImage(
        image: image,
        hasRed: hasRed,
        hasYellow: hasYellow,
        onProgress: _setProgress,
      );

      if (!mounted) return;
      setState(() {
        _phase = _Phase.done;
        _message = result == OeplUploadResult.uploaded
            ? _Texts.uploaded
            : _Texts.alreadyPresent;
      });
    } catch (e) {
      _fail(e);
    } finally {
      await _client.disconnect();
    }
  }

  void _cancelTransfer() {
    _client.abort();
    _client.disconnect();
    if (mounted) Navigator.of(context).pop();
  }

  // ------------------------------------------------------------------ UI ----

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.display.name),
      content: SizedBox(width: double.maxFinite, child: _buildContent()),
      actions: _buildActions(),
    );
  }

  Widget _buildContent() {
    switch (_phase) {
      case _Phase.scanning:
        return _buildScanContent();
      case _Phase.transferring:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(value: _progress, color: colorAccent),
            const SizedBox(height: 12),
            Text(_status),
          ],
        );
      case _Phase.done:
        return Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 12),
            Expanded(child: Text(_message)),
          ],
        );
      case _Phase.failed:
        return Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(child: Text(_message)),
          ],
        );
    }
  }

  Widget _buildScanContent() {
    if (_devices.isEmpty) {
      return Row(
        children: [
          if (_scanActive)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          if (_scanActive) const SizedBox(width: 12),
          Expanded(
            child: Text(_scanActive ? _Texts.scanning : _Texts.noneFound),
          ),
        ],
      );
    }

    final devices = _devices.values.toList()
      ..sort((a, b) => (b.rssi ?? -999).compareTo(a.rssi ?? -999));

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 280),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_Texts.pickBadge),
          const SizedBox(height: 8),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final d in devices)
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.bluetooth),
                    title: Text(d.name ?? d.deviceId),
                    subtitle: Text(d.rssi == null ? d.deviceId : '${d.rssi} dBm'),
                    onTap: () => _transfer(d),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActions() {
    switch (_phase) {
      case _Phase.scanning:
        return [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(_Texts.cancel),
          ),
          if (!_scanActive)
            TextButton(
              onPressed: _startScan,
              child: const Text(_Texts.rescan),
            ),
        ];
      case _Phase.transferring:
        return [
          TextButton(
            onPressed: _cancelTransfer,
            child: const Text(_Texts.cancel),
          ),
        ];
      case _Phase.done:
        return [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(_Texts.close),
          ),
        ];
      case _Phase.failed:
        return [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(_Texts.close),
          ),
          TextButton(
            onPressed: _startScan,
            child: const Text(_Texts.retry),
          ),
        ];
    }
  }
}
