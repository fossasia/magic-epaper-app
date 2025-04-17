import 'dart:typed_data';
import 'package:flutter/material.dart';

Widget buildImagePreviewDialog({
  required BuildContext context,
  required Uint8List image,
  required VoidCallback onSubmit,
}) {
  return AlertDialog(
    title: const Text("Preview Captured Image"),
    content: SingleChildScrollView(child: Image.memory(image)),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text("Close"),
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(context);
          onSubmit();
        },
        child: const Text("Submit"),
      ),
    ],
  );
}
