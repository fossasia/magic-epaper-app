import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:magicepaperapp/card_templates/bulk/bulk_template.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/util/template_util.dart';

enum ColumnRole { title, detail, photo, qr, ignore }

class DetectedColumn {
  const DetectedColumn({
    required this.header,
    required this.key,
    required this.role,
  });

  final String header;
  final String key;
  final ColumnRole role;
}

bool looksLikeImageRef(String value) {
  final v = value.trim().toLowerCase();
  if (v.startsWith('data:image')) return true;
  return RegExp(r'\.(png|jpe?g|webp|gif|bmp)(\?.*)?$').hasMatch(v);
}

bool looksLikeUrl(String value) {
  final v = value.trim().toLowerCase();
  return v.startsWith('http://') || v.startsWith('https://');
}

String columnKey(String header, int index) {
  final slug = header
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '');
  return slug.isEmpty ? 'col_$index' : slug;
}

List<DetectedColumn> detectColumnRoles(
  List<String> headers,
  List<List<String>> rows,
) {
  String sample(int c) {
    for (final r in rows) {
      if (c < r.length && r[c].trim().isNotEmpty) return r[c].trim();
    }
    return '';
  }

  final columns = <DetectedColumn>[];
  var titleAssigned = false;
  var photoAssigned = false;
  var qrAssigned = false;
  for (var i = 0; i < headers.length; i++) {
    final header = headers[i];
    final headerNorm = header.toLowerCase();
    final value = sample(i);
    ColumnRole role;
    if (!photoAssigned &&
        (looksLikeImageRef(value) ||
            headerNorm.contains('photo') ||
            headerNorm.contains('image') ||
            headerNorm.contains('avatar'))) {
      role = ColumnRole.photo;
      photoAssigned = true;
    } else if (!qrAssigned &&
        (looksLikeUrl(value) ||
            headerNorm.contains('qr') ||
            headerNorm.contains('link') ||
            headerNorm.contains('url'))) {
      role = ColumnRole.qr;
      qrAssigned = true;
    } else if (!titleAssigned && header.trim().isNotEmpty) {
      role = ColumnRole.title;
      titleAssigned = true;
    } else {
      role = ColumnRole.detail;
    }
    columns.add(DetectedColumn(
      header: header,
      key: columnKey(header, i),
      role: role,
    ));
  }
  return columns;
}

List<LayerSpec> buildDynamicLayers(
  Map<String, String> row,
  File? photo,
  int width,
  int height,
  List<DetectedColumn> columns,
) {
  final layers = <LayerSpec>[];

  if (photo != null) {
    layers.add(LayerSpec.widget(
      widget: ClipOval(
        child: Image.file(photo, width: 200, height: 200, fit: BoxFit.cover),
      ),
      offset: Offset.zero,
      scale: 5.0,
      kind: LayerKind.image,
      elementId: 'profileImage',
    ));
  }

  for (final c in columns) {
    final value = row[c.key]?.trim() ?? '';
    if (value.isEmpty) continue;
    switch (c.role) {
      case ColumnRole.title:
        layers.add(LayerSpec.text(
          text: value,
          textStyle:
              const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          offset: Offset.zero,
          scale: 1.0,
          followCanvasTheme: true,
          elementId: 'title',
        ));
        break;
      case ColumnRole.detail:
        layers.add(LayerSpec.text(
          text: '${c.header}: $value',
          textStyle: const TextStyle(fontSize: 16),
          textAlign: TextAlign.left,
          offset: Offset.zero,
          scale: 0.75,
          followCanvasTheme: true,
          elementId: c.key,
        ));
        break;
      case ColumnRole.qr:
        layers.add(LayerSpec.widget(
          widget: BarcodeWidget(
            padding: const EdgeInsets.all(Dimens.spacingXxs),
            backgroundColor: colorWhite,
            barcode: Barcode.qrCode(),
            data: value,
            width: 60,
            height: 60,
          ),
          offset: Offset.zero,
          scale: 6,
          kind: LayerKind.barcode,
          elementId: 'qr',
        ));
        break;
      case ColumnRole.photo:
      case ColumnRole.ignore:
        break;
    }
  }
  return layers;
}

BulkTemplate dynamicBulkTemplate(
  List<String> headers,
  List<List<String>> rows, {
  String title = 'Custom columns',
}) {
  final columns = detectColumnRoles(headers, rows);
  final fields = <BulkField>[
    for (final c in columns)
      if (c.role != ColumnRole.ignore)
        BulkField(
          key: c.key,
          label: c.header,
          aliases: [c.header],
          required: c.role == ColumnRole.title,
          isPhoto: c.role == ColumnRole.photo,
          namesOutput: c.role == ColumnRole.title,
        ),
  ];
  return BulkTemplate(
    id: 'dynamic',
    title: title,
    fields: fields,
    hasPhoto: columns.any((c) => c.role == ColumnRole.photo),
    buildLayers: (row, photo, width, height) =>
        buildDynamicLayers(row, photo, width, height, columns),
  );
}
