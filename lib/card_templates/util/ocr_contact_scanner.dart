import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ocr_native/flutter_ocr_native.dart';
import 'package:image_picker/image_picker.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/util/app_logger.dart' show AppLogger;
import 'package:magicepaperapp/util/image_source_picker.dart';

Future<T> _showLoaderWhile<T>(
  BuildContext context,
  Future<T> Function() task,
) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: colorBlack54,
    builder: (_) => const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(colorAccent),
      ),
    ),
  );
  try {
    return await task();
  } finally {
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}

Future<String?> scanImageForRawText(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
  final source = await chooseImageSource(context);
  if (source == null) return null;
  if (!context.mounted) return null;

  try {
    final picked = await ImagePicker()
        .pickImage(source: source, maxWidth: 2200, imageQuality: 90);
    if (picked == null) return null;
    if (!context.mounted) return null;
    final text = await _showLoaderWhile(
      context,
      () async {
        final reader = OcrReader();
        final result = await reader.readFromFile(File(picked.path));
        return result.text.trim();
      },
    );
    return text.isEmpty ? null : text;
  } catch (e) {
    AppLogger.error('OCR raw scan failed', e);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.ocrCouldNotReadImage)),
      );
    }
    return null;
  }
}
