// Dart imports:
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_image_editor/designs/frosted_glass/frosted_glass.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

import '../../core/mixin/example_helper.dart';
import '../../shared/widgets/demo_build_stickers.dart';

/// The frosted glass design example
class FrostedGlassExample extends StatefulWidget {
  /// Creates a new [FrostedGlassExample] widget.
  const FrostedGlassExample({
    super.key,
    required this.url,
  });

  /// The URL of the image to display.
  final String url;

  @override
  State<FrostedGlassExample> createState() => _FrostedGlassExampleState();
}

class _FrostedGlassExampleState extends State<FrostedGlassExample>
    with ExampleHelperState<FrostedGlassExample> {
  final bool _useMaterialDesign =
      platformDesignMode == ImageEditorDesignMode.material;

  /// Opens the sticker/emoji editor.
  void _openStickerEditor(ProImageEditorState editor) async {
    Layer? layer = await editor.openPage(FrostedGlassStickerPage(
      configs: editor.configs,
      callbacks: editor.callbacks,
    ));

    if (layer == null || !mounted) return;

    if (layer.runtimeType != WidgetLayer) {
      layer.scale = editor.configs.emojiEditor.initScale;
    }

    editor.addLayer(layer);
  }

  /// Calculates the number of columns for the EmojiPicker.
  int _calculateEmojiColumns(BoxConstraints constraints) =>
      max(1, (_useMaterialDesign ? 6 : 10) / 400 * constraints.maxWidth - 1)
          .floor();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ProImageEditor.network(
        widget.url,
        key: editorKey,
        callbacks: ProImageEditorCallbacks(
            onImageEditingStarted: onImageEditingStarted,
            onImageEditingComplete: onImageEditingComplete,
            onCloseEditor: (editorMode) =>
                onCloseEditor(editorMode: editorMode),
            mainEditorCallbacks: MainEditorCallbacks(
              helperLines: HelperLinesCallbacks(onLineHit: vibrateLineHit),
            ),
            stickerEditorCallbacks: StickerEditorCallbacks(
              onSearchChanged: (value) {
                /// Filter your stickers
                debugPrint(value);
              },
            )),
        configs: ProImageEditorConfigs(
          designMode: platformDesignMode,
          theme: Theme.of(context).copyWith(
              iconTheme:
                  Theme.of(context).iconTheme.copyWith(color: Colors.white)),
          mainEditor: MainEditorConfigs(
            widgets: MainEditorWidgets(
              closeWarningDialog: (editor) async {
                if (!context.mounted) return false;
                return await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) =>
                          FrostedGlassCloseDialog(editor: editor),
                    ) ??
                    false;
              },
              appBar: (editor, rebuildStream) => null,
              bottomBar: (editor, rebuildStream, key) => null,
              bodyItems: _buildMainBodyWidgets,
            ),
          ),
          paintEditor: PaintEditorConfigs(
            icons: const PaintEditorIcons(
              bottomNavBar: Icons.edit,
            ),
            widgets: PaintEditorWidgets(
              appBar: (paintEditor, rebuildStream) => null,
              bottomBar: (paintEditor, rebuildStream) => null,
              colorPicker:
                  (paintEditor, rebuildStream, currentColor, setColor) => null,
              bodyItems: _buildPaintEditorBody,
            ),
            style: const PaintEditorStyle(
              initialStrokeWidth: 5,
            ),
          ),
          textEditor: TextEditorConfigs(
            customTextStyles: [
              GoogleFonts.roboto(),
              GoogleFonts.averiaLibre(),
              GoogleFonts.lato(),
              GoogleFonts.comicNeue(),
              GoogleFonts.actor(),
              GoogleFonts.odorMeanChey(),
              GoogleFonts.nabla(),
            ],
            style: TextEditorStyle(
              textFieldMargin: const EdgeInsets.only(top: kToolbarHeight),
              bottomBarBackground: Colors.transparent,
              bottomBarMainAxisAlignment: !_useMaterialDesign
                  ? MainAxisAlignment.spaceEvenly
                  : MainAxisAlignment.start,
            ),
            widgets: TextEditorWidgets(
              appBar: (textEditor, rebuildStream) => null,
              colorPicker:
                  (textEditor, rebuildStream, currentColor, setColor) => null,
              bottomBar: (textEditor, rebuildStream) => null,
              bodyItems: _buildTextEditorBody,
            ),
          ),
          cropRotateEditor: CropRotateEditorConfigs(
            widgets: CropRotateEditorWidgets(
              appBar: (cropRotateEditor, rebuildStream) => null,
              bottomBar: (cropRotateEditor, rebuildStream) => ReactiveWidget(
                stream: rebuildStream,
                builder: (_) => FrostedGlassCropRotateToolbar(
                  configs: cropRotateEditor.configs,
                  onCancel: cropRotateEditor.close,
                  onRotate: cropRotateEditor.rotate,
                  onDone: cropRotateEditor.done,
                  onReset: cropRotateEditor.reset,
                  openAspectRatios: cropRotateEditor.openAspectRatioOptions,
                ),
              ),
            ),
          ),
          filterEditor: FilterEditorConfigs(
            style: const FilterEditorStyle(
              filterListSpacing: 7,
              filterListMargin: EdgeInsets.fromLTRB(8, 15, 8, 10),
            ),
            widgets: FilterEditorWidgets(
              slider:
                  (editorState, rebuildStream, value, onChanged, onChangeEnd) =>
                      ReactiveWidget(
                stream: rebuildStream,
                builder: (_) => Slider(
                  onChanged: onChanged,
                  onChangeEnd: onChangeEnd,
                  value: value,
                  activeColor: Colors.blue.shade200,
                ),
              ),
              appBar: (filterEditor, rebuildStream) => null,
              bodyItems: (filterEditor, rebuildStream) => [
                ReactiveWidget(
                  stream: rebuildStream,
                  builder: (_) =>
                      FrostedGlassFilterAppbar(filterEditor: filterEditor),
                ),
              ],
            ),
          ),
          tuneEditor: TuneEditorConfigs(
            widgets: TuneEditorWidgets(
              appBar: (filterEditor, rebuildStream) => null,
              bottomBar: (filterEditor, rebuildStream) => null,
              bodyItems: _buildTuneEditorBody,
            ),
          ),
          blurEditor: BlurEditorConfigs(
            widgets: BlurEditorWidgets(
              slider:
                  (editorState, rebuildStream, value, onChanged, onChangeEnd) =>
                      ReactiveWidget(
                stream: rebuildStream,
                builder: (_) => Slider(
                  onChanged: onChanged,
                  onChangeEnd: onChangeEnd,
                  value: value,
                  max: editorState.configs.blurEditor.maxBlur,
                  activeColor: Colors.blue.shade200,
                ),
              ),
              appBar: (blurEditor, rebuildStream) => null,
              bodyItems: (blurEditor, rebuildStream) => [
                ReactiveWidget(
                  stream: rebuildStream,
                  builder: (_) =>
                      FrostedGlassBlurAppbar(blurEditor: blurEditor),
                ),
              ],
            ),
          ),
          emojiEditor: EmojiEditorConfigs(
            checkPlatformCompatibility: !kIsWeb,
            style: EmojiEditorStyle(
              backgroundColor: Colors.transparent,
              textStyle: DefaultEmojiTextStyle.copyWith(
                fontFamily:
                    !kIsWeb ? null : GoogleFonts.notoColorEmoji().fontFamily,
                fontSize: _useMaterialDesign ? 48 : 30,
              ),
              emojiViewConfig: EmojiViewConfig(
                gridPadding: EdgeInsets.zero,
                horizontalSpacing: 0,
                verticalSpacing: 0,
                recentsLimit: 40,
                backgroundColor: Colors.transparent,
                buttonMode: !_useMaterialDesign
                    ? ButtonMode.CUPERTINO
                    : ButtonMode.MATERIAL,
                loadingIndicator:
                    const Center(child: CircularProgressIndicator()),
                columns: _calculateEmojiColumns(constraints),
                emojiSizeMax: !_useMaterialDesign ? 32 : 64,
                replaceEmojiOnLimitExceed: false,
              ),
              bottomActionBarConfig:
                  const BottomActionBarConfig(enabled: false),
            ),
          ),
          stickerEditor: StickerEditorConfigs(
            enabled: true,
            buildStickers: (setLayer, scrollController) => DemoBuildStickers(
                setLayer: setLayer, scrollController: scrollController),
          ),
          layerInteraction: const LayerInteractionConfigs(
            style: LayerInteractionStyle(
              removeAreaBackgroundInactive: Colors.black12,
            ),
          ),
          dialogConfigs: DialogConfigs(
            widgets: DialogWidgets(
              loadingDialog: (message, configs) => FrostedGlassLoadingDialog(
                message: message,
                configs: configs,
              ),
            ),
          ),
        ),
      );
    });
  }

  List<ReactiveWidget> _buildMainBodyWidgets(
    ProImageEditorState editor,
    Stream<dynamic> rebuildStream,
  ) {
    return [
      if (editor.selectedLayerIndex < 0)
        ReactiveWidget(
          stream: rebuildStream,
          builder: (_) => FrostedGlassActionBar(
            editor: editor,
            openStickerEditor: () => _openStickerEditor(editor),
          ),
        ),
    ];
  }

  List<ReactiveWidget> _buildPaintEditorBody(
    PaintEditorState paintEditor,
    Stream<dynamic> rebuildStream,
  ) {
    return [
      /// Appbar
      ReactiveWidget(
        stream: rebuildStream,
        builder: (_) {
          return paintEditor.isActive
              ? const SizedBox.shrink()
              : FrostedGlassPaintAppbar(paintEditor: paintEditor);
        },
      ),

      /// Bottombar
      ReactiveWidget(
        stream: rebuildStream,
        builder: (_) => FrostedGlassPaintBottomBar(paintEditor: paintEditor),
      ),
    ];
  }

  List<ReactiveWidget> _buildTuneEditorBody(
    TuneEditorState tuneEditor,
    Stream<dynamic> rebuildStream,
  ) {
    return [
      /// Appbar
      ReactiveWidget(
        stream: rebuildStream,
        builder: (_) {
          return FrostedGlassTuneAppbar(tuneEditor: tuneEditor);
        },
      ),

      /// Bottombar
      ReactiveWidget(
        stream: rebuildStream,
        builder: (_) => FrostedGlassTuneBottombar(tuneEditor: tuneEditor),
      ),
    ];
  }

  List<ReactiveWidget> _buildTextEditorBody(
    TextEditorState textEditor,
    Stream<dynamic> rebuildStream,
  ) {
    return [
      /// Background
      ReactiveWidget(
        stream: rebuildStream,
        builder: (_) => const FrostedGlassEffect(
          radius: BorderRadius.zero,
          child: SizedBox.expand(),
        ),
      ),

      /// Slider Text size
      ReactiveWidget(
        stream: rebuildStream,
        builder: (_) => Padding(
          padding: const EdgeInsets.only(top: kToolbarHeight),
          child: FrostedGlassTextSizeSlider(textEditor: textEditor),
        ),
      ),

      /// Appbar
      ReactiveWidget(
        stream: rebuildStream,
        builder: (_) {
          return FrostedGlassTextAppbar(textEditor: textEditor);
        },
      ),

      /// Bottombar
      ReactiveWidget(
        stream: rebuildStream,
        builder: (_) => FrostedGlassTextBottomBar(
          configs: textEditor.configs,
          initColor: textEditor.primaryColor,
          onColorChanged: (color) {
            textEditor.primaryColor = color;
          },
          selectedStyle: textEditor.selectedTextStyle,
          onFontChange: textEditor.setTextStyle,
        ),
      ),
    ];
  }
}
