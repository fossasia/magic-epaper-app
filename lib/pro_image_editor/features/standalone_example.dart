// Flutter imports:
import '../core/constants/example_constants.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:pro_image_editor/pro_image_editor.dart';

// Project imports:
import '../core/mixin/example_helper.dart';

/// A widget that demonstrates a standalone feature or functionality.
///
/// The [StandaloneExample] widget is a stateful widget intended to showcase
/// a feature or functionality that works independently, without relying on
/// external factors. It can be used as an isolated example within a project.
///
/// The state for this widget is managed by the [_StandaloneExampleState] class.
///
/// Example usage:
/// ```dart
/// StandaloneExample();
/// ```
class StandaloneExample extends StatefulWidget {
  /// Creates a new [StandaloneExample] widget.
  const StandaloneExample({super.key});

  @override
  State<StandaloneExample> createState() => _StandaloneExampleState();
}

/// The state for the [StandaloneExample] widget.
///
/// This class manages the behavior and state related to the standalone feature
/// within the [StandaloneExample] widget.
class _StandaloneExampleState extends State<StandaloneExample>
    with ExampleHelperState<StandaloneExample> {
  final _cropRotateEditorKey = GlobalKey<CropRotateEditorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Standalone-Editors'),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text('Paint-Editor'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await precacheImage(
                  AssetImage(kImageEditorExampleAssetPath), context);
              if (!context.mounted) return;
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => _buildPaintEditor()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.crop_rotate_rounded),
            title: const Text('Crop-Rotate-Editor'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await precacheImage(
                  AssetImage(kImageEditorExampleAssetPath), context);
              if (!context.mounted) return;

              bool initialized = false;

              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  if (!initialized) {
                    initialized = true;
                    Future.delayed(const Duration(milliseconds: 1), () {
                      _cropRotateEditorKey.currentState!.enableFakeHero = true;
                      setState(() {});
                    });
                  }
                  return _buildCropRotateEditor();
                }),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.filter),
            title: const Text('Filter-Editor'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await precacheImage(
                  AssetImage(kImageEditorExampleAssetPath), context);
              if (!context.mounted) return;
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => _buildFilterEditor()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.tune_rounded),
            title: const Text('Tune-Adjustment-Editor'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await precacheImage(
                  AssetImage(kImageEditorExampleAssetPath), context);
              if (!context.mounted) return;
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => _buildTuneEditor()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.blur_on),
            title: const Text('Blur-Editor'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await precacheImage(
                  AssetImage(kImageEditorExampleAssetPath), context);
              if (!context.mounted) return;
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => _buildBlurEditor()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaintEditor() {
    return PaintEditor.asset(
      kImageEditorExampleAssetPath,
      initConfigs: PaintEditorInitConfigs(
        theme: Theme.of(context),
        enableFakeHero: true,
        convertToUint8List: true,
        configs: ProImageEditorConfigs(
          designMode: platformDesignMode,
          imageGeneration: const ImageGenerationConfigs(

              /// If your users paint a lot in a short time, you should disable
              /// this flag because it will overload the isolated thread which
              /// delay the final result enableBackgroundGeneration: true,
              ),
        ),
        callbacks: ProImageEditorCallbacks(
          onImageEditingStarted: onImageEditingStarted,
          onImageEditingComplete: onImageEditingComplete,
          onCloseEditor: (editorMode) => onCloseEditor(editorMode: editorMode),
        ),
      ),
    );
  }

  Widget _buildCropRotateEditor() {
    return CropRotateEditor.asset(
      kImageEditorExampleAssetPath,
      key: _cropRotateEditorKey,
      initConfigs: CropRotateEditorInitConfigs(
        theme: Theme.of(context),
        convertToUint8List: true,
        configs: ProImageEditorConfigs(
          designMode: platformDesignMode,
          imageGeneration: const ImageGenerationConfigs(

              /// If your users change a lot stuff in a short time, you should
              /// disable this flag because it will overload the isolated
              /// thread which delay the final result.
              /// enableBackgroundGeneration: true,
              ),
        ),
        callbacks: ProImageEditorCallbacks(
          onImageEditingStarted: onImageEditingStarted,
          onImageEditingComplete: onImageEditingComplete,
          onCloseEditor: (editorMode) => onCloseEditor(editorMode: editorMode),
        ),
      ),
    );
  }

  Widget _buildFilterEditor() {
    return FilterEditor.asset(
      kImageEditorExampleAssetPath,
      initConfigs: FilterEditorInitConfigs(
        theme: Theme.of(context),
        convertToUint8List: true,
        callbacks: ProImageEditorCallbacks(
          onImageEditingStarted: onImageEditingStarted,
          onImageEditingComplete: onImageEditingComplete,
          onCloseEditor: (editorMode) => onCloseEditor(editorMode: editorMode),
        ),
        configs: ProImageEditorConfigs(
          designMode: platformDesignMode,
        ),
      ),
    );
  }

  Widget _buildTuneEditor() {
    return TuneEditor.asset(
      kImageEditorExampleAssetPath,
      initConfigs: TuneEditorInitConfigs(
        theme: Theme.of(context),
        convertToUint8List: true,
        callbacks: ProImageEditorCallbacks(
          onImageEditingStarted: onImageEditingStarted,
          onImageEditingComplete: onImageEditingComplete,
          onCloseEditor: (editorMode) => onCloseEditor(editorMode: editorMode),
        ),
        configs: ProImageEditorConfigs(
          designMode: platformDesignMode,
        ),
      ),
    );
  }

  Widget _buildBlurEditor() {
    return BlurEditor.asset(
      kImageEditorExampleAssetPath,
      initConfigs: BlurEditorInitConfigs(
        theme: Theme.of(context),
        convertToUint8List: true,
        callbacks: ProImageEditorCallbacks(
          onImageEditingStarted: onImageEditingStarted,
          onImageEditingComplete: onImageEditingComplete,
          onCloseEditor: (editorMode) => onCloseEditor(editorMode: editorMode),
        ),
        configs: ProImageEditorConfigs(
          designMode: platformDesignMode,
        ),
      ),
    );
  }
}
