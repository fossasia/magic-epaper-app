import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class IconifyService {
  IconifyService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

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
    final icons = (decoded['icons'] as List?)?.cast<String>() ?? const [];
    return icons;
  }

  String previewUrl(String iconName, {required Color color, int height = 80}) {
    final (prefix, name) = _split(iconName);
    return '$_base/$prefix/$name.svg'
        '?height=$height&color=${Uri.encodeQueryComponent(_hex(color))}';
  }

  Future<String> fetchSvg(
    String iconName, {
    required Color color,
    int height = 240,
  }) async {
    final (prefix, name) = _split(iconName);
    final uri = Uri.parse(
      '$_base/$prefix/$name.svg'
      '?height=$height&color=${Uri.encodeQueryComponent(_hex(color))}',
    );
    final resp = await _client.get(uri).timeout(const Duration(seconds: 12));
    if (resp.statusCode != 200 || resp.body.contains('<svg') == false) {
      throw IconifyException('Could not load this sticker.');
    }
    return resp.body;
  }

  Future<Uint8List> fetchPng(
    String iconName, {
    required Color color,
    double targetWidth = 400,
  }) async {
    final svg = await fetchSvg(iconName, color: color);
    return rasterizeSvg(svg, targetWidth: targetWidth);
  }

  static (String, String) _split(String iconName) {
    final idx = iconName.indexOf(':');
    if (idx <= 0) return ('mdi', iconName);
    return (iconName.substring(0, idx), iconName.substring(idx + 1));
  }

  static String _hex(Color color) {
    final argb = color.toARGB32();
    final rgb = (argb & 0xFFFFFF).toRadixString(16).padLeft(6, '0');
    return '#$rgb';
  }

  void dispose() => _client.close();
}

Future<Uint8List> rasterizeSvg(String svg, {double targetWidth = 400}) async {
  final PictureInfo info = await vg.loadPicture(SvgStringLoader(svg), null);
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
