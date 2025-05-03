// Dart imports:
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

import '../core/constants/example_constants.dart';
import '../core/mixin/example_helper.dart';

/// A widget that provides a default example of a stateful widget.
///
/// The [DefaultExample] widget is a simple stateful widget that serves as
/// a basic example or template for creating a new widget with state management.
/// It can be used as a starting point when building more complex widgets.
///
/// The state for this widget is managed by the [_DefaultExampleState] class.
///
/// Example usage:
/// ```dart
/// DefaultExample();
/// ```
class DefaultExample extends StatefulWidget {
  /// Creates a new [DefaultExample] widget.
  const DefaultExample({super.key});

  @override
  State<DefaultExample> createState() => _DefaultExampleState();
}

/// The state for the [DefaultExample] widget.
///
/// This class manages the behavior and state of the [DefaultExample] widget.
class _DefaultExampleState extends State<DefaultExample>
    with ExampleHelperState<DefaultExample> {
  late final _configs = ProImageEditorConfigs(
    designMode: platformDesignMode,
  );
  late final _callbacks = ProImageEditorCallbacks(
    onImageEditingStarted: onImageEditingStarted,
    onImageEditingComplete: onImageEditingComplete,
    onCloseEditor: (editorMode) => onCloseEditor(editorMode: editorMode),
    mainEditorCallbacks: MainEditorCallbacks(
      helperLines: HelperLinesCallbacks(onLineHit: vibrateLineHit),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Default Example'),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text('The editor support to directly open your type of data '
                'without converting it first.'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.memory_outlined),
            title: const Text('Editor from memory'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              LoadingDialog.instance.show(
                context,
                configs: const ProImageEditorConfigs(),
                theme: Theme.of(context),
              );

              var url = 'https://picsum.photos/2000';
              var bytes = await fetchImageAsUint8List(url);

              if (!context.mounted) return;
              await precacheImage(MemoryImage(bytes), context);

              LoadingDialog.instance.hide();

              if (!context.mounted) return;
              await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => _buildMemoryEditor(bytes)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.folder_outlined),
            title: const Text('Editor from asset'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await precacheImage(
                  AssetImage(kImageEditorExampleAssetPath), context);
              if (!context.mounted) return;
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => _buildAssetEditor()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.public_outlined),
            title: const Text('Editor from network'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              LoadingDialog.instance.show(
                context,
                configs: const ProImageEditorConfigs(),
                theme: Theme.of(context),
              );

              await precacheImage(
                  NetworkImage(kImageEditorExampleNetworkUrl), context);

              LoadingDialog.instance.hide();
              if (!context.mounted) return;
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => _buildNetworkEditor()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.sd_card_outlined),
            title: const Text('Editor from file'),
            trailing: const Icon(Icons.chevron_right),
            subtitle: kIsWeb
                ? const Text(
                    'The file editor does not work in a web application '
                    'because Flutter does not support files in web '
                    'environments.')
                : null,
            enabled: !kIsWeb,
            onTap: kIsWeb
                ? null
                : () async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(type: FileType.image);

                    if (result != null && context.mounted) {
                      File file = File(result.files.single.path!);
                      await precacheImage(FileImage(file), context);
                      if (!context.mounted) return;
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => _buildFileEditor(file)),
                      );
                    }
                  },
          ),
        ],
      ),
    );
  }

  Widget _buildAssetEditor() {
    return ProImageEditor.asset(
      kImageEditorExampleAssetPath,
      callbacks: _callbacks,
      configs: _configs,
    );
  }

  Widget _buildMemoryEditor(Uint8List bytes) {
    return ProImageEditor.memory(
      bytes,
      callbacks: _callbacks,
      configs: _configs,
    );
  }

  Widget _buildNetworkEditor() {
    return ProImageEditor.network(
      kImageEditorExampleNetworkUrl,
      callbacks: _callbacks,
      configs: _configs,
    );
  }

  Widget _buildFileEditor(File file) {
    return ProImageEditor.file(
      file,
      callbacks: _callbacks,
      configs: _configs,
    );
  }
}
