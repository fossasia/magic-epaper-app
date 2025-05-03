// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:pro_image_editor/pro_image_editor.dart';

// Project imports:
import '../core/constants/example_constants.dart';
import '../core/mixin/example_helper.dart';
import '../shared/widgets/prepare_image_widget.dart';

/// A widget that demonstrates zoom and move functionality within an editor.
///
/// The [ZoomExample] widget is a stateful widget that provides an
/// example of how to implement zooming and moving features, likely within an
/// image editor or a similar application that requires user interaction for
/// manipulating content.
///
/// This widget holds the state, and the state class
/// [_ZoomExampleState]
/// will contain the logic to handle zoom and move gestures.
///
/// Example usage:
/// ```dart
/// ZoomExample();
/// ```
class ZoomExample extends StatefulWidget {
  /// Creates a new [ZoomExample] widget.
  const ZoomExample({super.key});

  @override
  State<ZoomExample> createState() => _ZoomExampleState();
}

class _ZoomExampleState extends State<ZoomExample>
    with ExampleHelperState<ZoomExample> {
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
            enableZoom: true,
            editorMinScale: 0.8,
            editorMaxScale: 5,
            boundaryMargin: const EdgeInsets.all(100),
            enableCloseButton: !isDesktopMode(context),
            widgets: MainEditorWidgets(
              bodyItems: (editor, rebuildStream) {
                return [
                  ReactiveWidget(
                    stream: rebuildStream,
                    builder: (_) =>
                        editor.selectedLayerIndex >= 0 || editor.isSubEditorOpen
                            ? const SizedBox.shrink()
                            : Positioned(
                                bottom: 20,
                                left: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade700,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(100),
                                      bottomRight: Radius.circular(100),
                                    ),
                                  ),
                                  child: IconButton(
                                    onPressed: editor.resetZoom,
                                    icon: const Icon(
                                      Icons.zoom_out_map_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                  ),
                ];
              },
            )),
        paintEditor: const PaintEditorConfigs(
          enableZoom: true,
          editorMinScale: 0.8,
          editorMaxScale: 5,
          boundaryMargin: EdgeInsets.all(100),
          icons: PaintEditorIcons(
            moveAndZoom: Icons.pinch_outlined,
          ),
        ),
        i18n: const I18n(
          paintEditor: I18nPaintEditor(
            moveAndZoom: 'Zoom',
          ),
        ),
      ),
    );
  }
}
