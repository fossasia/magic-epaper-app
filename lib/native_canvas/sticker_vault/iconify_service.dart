import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class IconifyService {
  IconifyService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  final Map<String, String> _svgCache = {};
  final Map<String, Future<String>> _inFlight = {};

  Directory? _cacheDir;

  static const String _base = 'https://api.iconify.design';

  Future<List<String>> search(String query, {int limit = 60}) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];
    final uri = Uri.parse(
      '$_base/search'
      '?query=${Uri.encodeQueryComponent(trimmed)}'
      '&limit=$limit'
      '&palette=false',
    );
    final resp = await _client.get(uri).timeout(const Duration(seconds: 12));
    if (resp.statusCode != 200) {
      throw IconifyException('Search failed (${resp.statusCode}).');
    }
    final decoded = jsonDecode(resp.body) as Map<String, dynamic>;
    return (decoded['icons'] as List?)?.cast<String>() ?? const [];
  }

  Future<String> loadSvg(String iconName) {
    final cached = _svgCache[iconName];
    if (cached != null) return Future.value(cached);
    return _inFlight.putIfAbsent(iconName, () => _load(iconName));
  }

  Future<String> _load(String iconName) async {
    try {
      final fromDisk = await _readDisk(iconName);
      if (fromDisk != null) {
        _svgCache[iconName] = fromDisk;
        return fromDisk;
      }
      final svg = await _fetch(iconName);
      _svgCache[iconName] = svg;
      unawaited(_writeDisk(iconName, svg));
      return svg;
    } finally {
      _inFlight.remove(iconName);
    }
  }

  Future<String> _fetch(String iconName) async {
    final (prefix, name) = _split(iconName);
    final uri = Uri.parse('$_base/$prefix/$name.svg');
    final resp = await _client.get(uri).timeout(const Duration(seconds: 12));
    if (resp.statusCode != 200 || !resp.body.contains('<svg')) {
      throw IconifyException('Could not load this sticker.');
    }
    return resp.body;
  }

  Future<Directory> _dir() async {
    if (_cacheDir != null) return _cacheDir!;
    final base = await getApplicationSupportDirectory();
    final dir = Directory('${base.path}/sticker_cache');
    if (!await dir.exists()) await dir.create(recursive: true);
    return _cacheDir = dir;
  }

  String _fileName(String iconName) => '${iconName.replaceAll(':', '__')}.svg';

  Future<String?> _readDisk(String iconName) async {
    try {
      final file = File('${(await _dir()).path}/${_fileName(iconName)}');
      if (await file.exists()) return await file.readAsString();
    } catch (_) {}
    return null;
  }

  Future<void> _writeDisk(String iconName, String svg) async {
    try {
      final file = File('${(await _dir()).path}/${_fileName(iconName)}');
      await file.writeAsString(svg);
    } catch (_) {}
  }

  Future<Uint8List> renderPng(
    String iconName, {
    required Color color,
    double targetWidth = 400,
  }) async {
    final svg = await loadSvg(iconName);
    return rasterizeSvg(svg, color: color, targetWidth: targetWidth);
  }

  static (String, String) _split(String iconName) {
    final idx = iconName.indexOf(':');
    if (idx <= 0) return ('mdi', iconName);
    return (iconName.substring(0, idx), iconName.substring(idx + 1));
  }

  void dispose() => _client.close();
}

Future<Uint8List> rasterizeSvg(
  String svg, {
  required Color color,
  double targetWidth = 400,
}) async {
  final loader = SvgStringLoader(svg, theme: SvgTheme(currentColor: color));
  final PictureInfo info = await vg.loadPicture(loader, null);
  try {
    final srcW = info.size.width <= 0 ? targetWidth : info.size.width;
    final srcH = info.size.height <= 0 ? targetWidth : info.size.height;
    final scale = targetWidth / srcW;
    final outW = (srcW * scale).round().clamp(1, 4096);
    final outH = (srcH * scale).round().clamp(1, 4096);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.scale(scale);
    canvas.drawPicture(info.picture);
    final picture = recorder.endRecording();
    final image = await picture.toImage(outW, outH);
    try {
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      if (data == null) {
        throw IconifyException('Could not render this sticker.');
      }
      return data.buffer.asUint8List();
    } finally {
      picture.dispose();
      image.dispose();
    }
  } finally {
    info.picture.dispose();
  }
}

class IconifyException implements Exception {
  IconifyException(this.message);
  final String message;
  @override
  String toString() => message;
}
