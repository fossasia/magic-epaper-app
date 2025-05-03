// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:pro_image_editor/pro_image_editor.dart';

// Project imports:
import '../core/mixin/example_helper.dart';

/// A widget that provides an example of a signature drawing feature.
///
/// The [SignatureDrawingExample] widget is a stateful widget that allows users
/// to draw a signature or freeform drawing. It can be used in applications
/// that require capturing user input as drawings or signatures.
///
/// The state for this widget is managed by the [_SignatureDrawingExampleState]
/// class.
///
/// Example usage:
/// ```dart
/// SignatureDrawingExample();
/// ```
class SignatureDrawingExample extends StatefulWidget {
  /// Creates a new [SignatureDrawingExample] widget.
  const SignatureDrawingExample({super.key});

  @override
  State<SignatureDrawingExample> createState() =>
      _SignatureDrawingExampleState();
}

/// The state for the [SignatureDrawingExample] widget.
///
/// This class manages the drawing logic and state related to the signature
/// or freeform drawing within the [SignatureDrawingExample] widget.
class _SignatureDrawingExampleState extends State<SignatureDrawingExample>
    with ExampleHelperState<SignatureDrawingExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signature and Drawing'),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.draw_outlined),
            title: const Text('Signature'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaintEditor.drawing(
                    initConfigs: PaintEditorInitConfigs(
                      theme: Theme.of(context),
                      convertToUint8List: true,
                      callbacks: ProImageEditorCallbacks(
                        onImageEditingStarted: onImageEditingStarted,
                        onImageEditingComplete: onImageEditingComplete,
                        onCloseEditor: (editorMode) =>
                            onCloseEditor(editorMode: editorMode),
                      ),
                      configs: ProImageEditorConfigs(
                        designMode: platformDesignMode,
                        paintEditor: PaintEditorConfigs(
                          enableModeFreeStyle: false,
                          enableModeArrow: false,
                          enableModeLine: false,
                          enableModeRect: false,
                          enableModeCircle: false,
                          enableModeDashLine: false,
                          enableModeEraser: false,
                          enableModeBlur: false,
                          enableModePixelate: false,
                          showToggleFillButton: false,

                          /// Optional true
                          showLineWidthAdjustmentButton: true,
                          widgets: PaintEditorWidgets(
                            colorPicker: (paintEditor, rebuildStream,
                                    currentColor, setColor) =>
                                null,
                          ),
                          style: const PaintEditorStyle(
                            background: Colors.white,
                            initialColor: Colors.black,
                          ),
                        ),
                        imageGeneration: ImageGenerationConfigs(
                          outputFormat: OutputFormat.png,
                          cropToImageBounds: false,
                          customPixelRatio:
                              MediaQuery.devicePixelRatioOf(context),
                          maxOutputSize: const Size(2000, 2000),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.brush_outlined),
            title: const Text('Drawing'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaintEditor.drawing(
                    initConfigs: PaintEditorInitConfigs(
                      theme: Theme.of(context),
                      convertToUint8List: true,
                      callbacks: ProImageEditorCallbacks(
                        onImageEditingStarted: onImageEditingStarted,
                        onImageEditingComplete: onImageEditingComplete,
                        onCloseEditor: (editorMode) =>
                            onCloseEditor(editorMode: editorMode),
                      ),
                      configs: ProImageEditorConfigs(
                        designMode: platformDesignMode,
                        paintEditor: const PaintEditorConfigs(
                          style: PaintEditorStyle(
                            background: Colors.white,
                            initialColor: Colors.black,
                          ),
                        ),
                        imageGeneration: ImageGenerationConfigs(
                          outputFormat: OutputFormat.jpg,
                          cropToImageBounds: false,
                          customPixelRatio:
                              MediaQuery.devicePixelRatioOf(context),
                          maxOutputSize: const Size(2000, 2000),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
