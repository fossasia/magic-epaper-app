// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:pro_image_editor/pro_image_editor.dart';

// Project imports:
import '../core/constants/example_constants.dart';
import '../core/mixin/example_helper.dart';
import '../shared/widgets/prepare_image_widget.dart';


/// A widget that demonstrates a selectable layer functionality.
///
/// The [SelectableLayerExample] widget is a stateful widget that allows users
/// to interact with and select different layers within an editor or a similar
/// application. This feature is commonly used in image or graphic editors
/// where users can manipulate individual layers.
///
/// The state for this widget is managed by the [_SelectableLayerExampleState]
/// class.
///
/// Example usage:
/// ```dart
/// SelectableLayerExample();
/// ```
class SelectableLayerExample extends StatefulWidget {
  /// Creates a new [SelectableLayerExample] widget.
  const SelectableLayerExample({super.key});

  @override
  State<SelectableLayerExample> createState() => _SelectableLayerExampleState();
}

/// The state for the [SelectableLayerExample] widget.
///
/// This class manages the behavior and state related to the selectable layers
/// within the [SelectableLayerExample] widget.
class _SelectableLayerExampleState extends State<SelectableLayerExample>
    with ExampleHelperState<SelectableLayerExample> {
  @override
  void initState() {
    super.initState();
    preCacheImage(assetPath: kImageEditorExampleAssetPath);
  }

  @override
  Widget build(BuildContext context) {
    if (!isPreCached) return const PrepareImageWidget();

    return ProImageEditor.asset(
      kImageEditorExampleAssetPath,
      key: editorKey,
      callbacks: ProImageEditorCallbacks(
        onImageEditingStarted: onImageEditingStarted,
        onImageEditingComplete: onImageEditingComplete,
        onCloseEditor: (editorMode) => onCloseEditor(
          editorMode: editorMode,
          enablePop: !isDesktopMode(context),
        ),
        mainEditorCallbacks: MainEditorCallbacks(
          helperLines: HelperLinesCallbacks(onLineHit: vibrateLineHit),
        ),
      ),
      configs: ProImageEditorConfigs(
        designMode: platformDesignMode,
        mainEditor: MainEditorConfigs(
          enableCloseButton: !isDesktopMode(context),
        ),
        imageGeneration: const ImageGenerationConfigs(
          processorConfigs: ProcessorConfigs(
            processorMode: ProcessorMode.auto,
          ),
        ),
        layerInteraction: const LayerInteractionConfigs(
          /// Choose between `auto`, `enabled` and `disabled`.
          ///
          /// Mode `auto`:
          /// Automatically determines if the layer is selectable based on the
          /// device type.
          /// If the device is a desktop-device, the layer is selectable;
          /// otherwise, the layer is not selectable.
          selectable: LayerInteractionSelectable.enabled,
          initialSelected: true,
          icons: LayerInteractionIcons(
            remove: Icons.clear,
            edit: Icons.edit_outlined,
            rotateScale: Icons.sync,
          ),
          style: LayerInteractionStyle(
            buttonRadius: 10,
            strokeWidth: 1.2,
            borderElementWidth: 7,
            borderElementSpace: 5,
            borderColor: Colors.blue,
            removeCursor: SystemMouseCursors.click,
            rotateScaleCursor: SystemMouseCursors.click,
            editCursor: SystemMouseCursors.click,
            hoverCursor: SystemMouseCursors.move,
            borderStyle: LayerInteractionBorderStyle.solid,
            showTooltips: false,
          ),
        ),
        i18n: const I18n(
          layerInteraction: I18nLayerInteraction(
            remove: 'Remove',
            edit: 'Edit',
            rotateScale: 'Rotate and Scale',
          ),
        ),
      ),
    );
  }
}
