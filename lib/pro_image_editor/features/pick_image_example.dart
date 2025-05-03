// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:image_picker/image_picker.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

// Project imports:
import '../core/mixin/example_helper.dart';

/// The example how to pick images from the gallery or with the camera.
class PickImageExample extends StatefulWidget {
  /// Creates a new [PickImageExample] widget.
  const PickImageExample({super.key});

  @override
  State<PickImageExample> createState() => _PickImageExampleState();
}

class _PickImageExampleState extends State<PickImageExample>
    with ExampleHelperState<PickImageExample> {
  final bool _cameraIsSupported =
      kIsWeb || (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS);

  late final _callbacks = ProImageEditorCallbacks(
    onImageEditingStarted: onImageEditingStarted,
    onImageEditingComplete: onImageEditingComplete,
    onCloseEditor: (editorMode) => onCloseEditor(editorMode: editorMode),
    mainEditorCallbacks: MainEditorCallbacks(
      helperLines: HelperLinesCallbacks(onLineHit: vibrateLineHit),
    ),
  );
  final _configs = ProImageEditorConfigs(
    designMode: platformDesignMode,
  );

  void _openPicker(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image == null) return;

    String? path;
    Uint8List? bytes;

    if (kIsWeb) {
      bytes = await image.readAsBytes();

      if (!mounted) return;
      await precacheImage(MemoryImage(bytes), context);
    } else {
      path = image.path;
      if (!mounted) return;
      await precacheImage(FileImage(File(path)), context);
    }

    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _buildEditor(path: path, bytes: bytes),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick from gallery or camera'),
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: _cameraIsSupported
                ? () => _openPicker(ImageSource.camera)
                : null,
            leading: const Icon(Icons.photo_camera_outlined),
            title: const Text('Open with camera'),
            subtitle: _cameraIsSupported
                ? null
                : const Text('The camera is not supported on this platform.'),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () => _openPicker(ImageSource.gallery),
            leading: const Icon(Icons.image_outlined),
            title: const Text('Open from gallery'),
            trailing: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildEditor({String? path, Uint8List? bytes}) {
    if (path != null) {
      return ProImageEditor.file(
        File(path),
        callbacks: _callbacks,
        configs: _configs,
      );
    } else {
      return ProImageEditor.memory(
        bytes!,
        callbacks: _callbacks,
        configs: _configs,
      );
    }
  }
}
