import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

final ImagePicker _picker = ImagePicker();

Future<File?> pickAndEditImage(
  BuildContext context, {
  ImageSource source = ImageSource.gallery,
}) async {
  final picked = await _picker.pickImage(source: source);
  if (picked == null) return null;

  final Uint8List original = await picked.readAsBytes();
  if (!context.mounted) return null;

  final Uint8List? edited = await Navigator.of(context).push<Uint8List>(
    MaterialPageRoute(
      builder: (editorContext) => ProImageEditor.memory(
        original,
        callbacks: ProImageEditorCallbacks(
          onImageEditingComplete: (Uint8List bytes) async {
            Navigator.of(editorContext).pop(bytes);
          },
        ),
      ),
    ),
  );

  if (edited == null) return null;

  final dir = await getTemporaryDirectory();
  final file = File(
    '${dir.path}/template_photo_${DateTime.now().millisecondsSinceEpoch}.png',
  );
  await file.writeAsBytes(edited);
  return file;
}
