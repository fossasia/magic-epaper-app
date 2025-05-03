// Flutter imports:
import '../core/constants/example_constants.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:pro_image_editor/pro_image_editor.dart';

// Project imports:
import '../core/mixin/example_helper.dart';
import '../shared/widgets/prepare_image_widget.dart';

/// The example how to use the round cropper
class RoundCropperExample extends StatefulWidget {
  /// Creates a new [RoundCropperExample] widget.
  const RoundCropperExample({super.key});

  @override
  State<RoundCropperExample> createState() => _RoundCropperExampleState();
}

class _RoundCropperExampleState extends State<RoundCropperExample>
    with ExampleHelperState<RoundCropperExample> {
  final _cropRotateEditorKey = GlobalKey<CropRotateEditorState>();

  @override
  void initState() {
    super.initState();
    preCacheImage(assetPath: kImageEditorExampleAssetPath);
  }

  @override
  Widget build(BuildContext context) {
    if (!isPreCached) return const PrepareImageWidget();

    return CropRotateEditor.asset(
      kImageEditorExampleAssetPath,
      key: _cropRotateEditorKey,
      initConfigs: CropRotateEditorInitConfigs(
        theme: Theme.of(context),
        convertToUint8List: true,
        enableCloseButton: !isDesktopMode(context),
        callbacks: ProImageEditorCallbacks(
          onImageEditingStarted: onImageEditingStarted,
          onImageEditingComplete: onImageEditingComplete,
          onCloseEditor: (editorMode) => onCloseEditor(editorMode: editorMode),
        ),
        configs: ProImageEditorConfigs(
          designMode: platformDesignMode,
          imageGeneration: const ImageGenerationConfigs(
            outputFormat: OutputFormat.png,
            pngFilter: PngFilter.average,
          ),
          cropRotateEditor: const CropRotateEditorConfigs(
            enableRoundCropper: true,
            showAspectRatioButton: false,
            initAspectRatio: 1,
          ),
        ),
      ),
    );
  }
}
