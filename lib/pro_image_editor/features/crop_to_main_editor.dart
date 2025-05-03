// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:pro_image_editor/pro_image_editor.dart';

// Project imports:
import '../core/constants/example_constants.dart';
import '../core/mixin/example_helper.dart';
import '../shared/widgets/prepare_image_widget.dart';

/// A widget that demonstrates cropping functionality in the main editor.
///
/// The [CropToMainEditorExample] widget is a stateful widget that provides an
/// example of how to implement cropping within a main editor interface, such as
/// an image editor. This can be used to allow users to select and crop a
/// portion of an image or other content.
///
/// The state for this widget is managed by the [_CropToMainEditorExampleState]
/// class.
///
/// Example usage:
/// ```dart
/// CropToMainEditorExample();
/// ```
class CropToMainEditorExample extends StatefulWidget {
  /// Creates a new [CropToMainEditorExample] widget.
  const CropToMainEditorExample({super.key});

  @override
  State<CropToMainEditorExample> createState() =>
      _CropToMainEditorExampleState();
}

/// The state for the [CropToMainEditorExample] widget.
///
/// This class manages the logic and state required for cropping functionality
/// within the [CropToMainEditorExample] widget.
class _CropToMainEditorExampleState extends State<CropToMainEditorExample>
    with ExampleHelperState<CropToMainEditorExample> {
  final ProImageEditorConfigs _editorConfigs = ProImageEditorConfigs(
    designMode: platformDesignMode,
    cropRotateEditor: const CropRotateEditorConfigs(
      initAspectRatio: 1,
      enableProvideImageInfos: true,
      showAspectRatioButton: false,
    ),
  );

  final _cropEditorKey = GlobalKey<CropRotateEditorState>();

  @override
  void initState() {
    super.initState();
    preCacheImage(
      assetPath: kImageEditorExampleAssetPath,
      onDone: () {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _cropEditorKey.currentState!.enableFakeHero = true;
          }
        });
      },
    );
  }

  void _openMainEditor(
    TransformConfigs transformations,
    ImageInfos imageInfos,
  ) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, secondaryAnimation) => ProImageEditor.asset(
          kImageEditorExampleAssetPath,
          key: editorKey,
          callbacks: ProImageEditorCallbacks(
            onImageEditingStarted: onImageEditingStarted,
            onCloseEditor: (editorMode) => onCloseEditor(
              editorMode: editorMode,
              enablePop: !isDesktopMode(context),
            ),
            onImageEditingComplete: onImageEditingComplete,
            mainEditorCallbacks: MainEditorCallbacks(
              helperLines: HelperLinesCallbacks(onLineHit: vibrateLineHit),
            ),
          ),
          configs: _editorConfigs.copyWith(
            mainEditor: MainEditorConfigs(
              transformSetup: MainEditorTransformSetup(
                transformConfigs: transformations,
                imageInfos: imageInfos,
              ),
            ),
            cropRotateEditor: const CropRotateEditorConfigs(
              enabled: false,
            ),
          ),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          if (animation.status != AnimationStatus.forward) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          }

          return child;
        },
      ),
    ).whenComplete(() {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isPreCached) return const PrepareImageWidget();

    return CropRotateEditor.asset(
      kImageEditorExampleAssetPath,
      key: _cropEditorKey,
      initConfigs: CropRotateEditorInitConfigs(
        theme: Theme.of(context),
        configs: _editorConfigs,
        enablePopWhenDone: false,
        enableCloseButton: !isDesktopMode(context),
        onDone: (transformations, fitToScreenFactor, imageInfos) {
          _openMainEditor(transformations, imageInfos!);
        },
      ),
    );
  }
}
