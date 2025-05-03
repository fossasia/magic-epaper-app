// Dart imports:
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:pro_image_editor/designs/grounded/grounded_design.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

import '../../core/mixin/example_helper.dart';
import '../../shared/widgets/demo_build_stickers.dart';

/// The grounded design example
class GroundedDesignExample extends StatefulWidget {
  /// Creates a new [GroundedDesignExample] widget.
  const GroundedDesignExample({
    super.key,
    required this.url,
  });

  /// The URL of the image to display.
  final String url;

  @override
  State<GroundedDesignExample> createState() => _GroundedDesignExampleState();
}

class _GroundedDesignExampleState extends State<GroundedDesignExample>
    with ExampleHelperState<GroundedDesignExample> {
  final _mainEditorBarKey = GlobalKey<GroundedMainBarState>();
  final bool _useMaterialDesign =
      platformDesignMode == ImageEditorDesignMode.material;

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
          onCloseEditor: (editorMode) => onCloseEditor(editorMode: editorMode),
          mainEditorCallbacks: MainEditorCallbacks(
            helperLines: HelperLinesCallbacks(onLineHit: vibrateLineHit),
            onStartCloseSubEditor: (value) {
              /// Start the reversed animation for the bottombar
              _mainEditorBarKey.currentState?.setState(() {});
            },
          ),
          stickerEditorCallbacks: StickerEditorCallbacks(
            onSearchChanged: (value) {
              /// Filter your stickers
              debugPrint(value);
            },
          ),
        ),
        configs: ProImageEditorConfigs(
          designMode: platformDesignMode,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue.shade800,
              brightness: Brightness.dark,
            ),
          ),
          layerInteraction: const LayerInteractionConfigs(
            hideToolbarOnInteraction: false,
          ),
          mainEditor: MainEditorConfigs(
            widgets: MainEditorWidgets(
              appBar: (editor, rebuildStream) => null,
              bottomBar: (editor, rebuildStream, key) => ReactiveWidget(
                key: key,
                builder: (context) {
                  return GroundedMainBar(
                    key: _mainEditorBarKey,
                    editor: editor,
                    configs: editor.configs,
                    callbacks: editor.callbacks,
                  );
                },
                stream: rebuildStream,
              ),
            ),
            style: const MainEditorStyle(
              background: Color(0xFF000000),
              bottomBarBackground: Color(0xFF161616),
            ),
          ),
          paintEditor: PaintEditorConfigs(
            style: const PaintEditorStyle(
              background: Color(0xFF000000),
              bottomBarBackground: Color(0xFF161616),
              initialStrokeWidth: 5,
            ),
            widgets: PaintEditorWidgets(
              appBar: (paintEditor, rebuildStream) => null,
              colorPicker:
                  (paintEditor, rebuildStream, currentColor, setColor) => null,
              bottomBar: (editorState, rebuildStream) {
                return ReactiveWidget(
                  builder: (context) {
                    return GroundedPaintBar(
                        configs: editorState.configs,
                        callbacks: editorState.callbacks,
                        editor: editorState,
                        i18nColor: 'Color',
                        showColorPicker: (currentColor) {
                          Color? newColor;
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: currentColor,
                                  onColorChanged: (color) {
                                    newColor = color;
                                  },
                                ),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text('Got it'),
                                  onPressed: () {
                                    if (newColor != null) {
                                      setState(() =>
                                          editorState.colorChanged(newColor!));
                                    }
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  stream: rebuildStream,
                );
              },
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
              bottomBarBackground: const Color(0xFF161616),
              bottomBarMainAxisAlignment: !_useMaterialDesign
                  ? MainAxisAlignment.spaceEvenly
                  : MainAxisAlignment.start,
            ),
            widgets: TextEditorWidgets(
              appBar: (textEditor, rebuildStream) => null,
              colorPicker:
                  (textEditor, rebuildStream, currentColor, setColor) => null,
              bottomBar: (editorState, rebuildStream) {
                return ReactiveWidget(
                  builder: (context) {
                    return GroundedTextBar(
                        configs: editorState.configs,
                        callbacks: editorState.callbacks,
                        editor: editorState,
                        i18nColor: 'Color',
                        showColorPicker: (currentColor) {
                          Color? newColor;
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: currentColor,
                                  onColorChanged: (color) {
                                    newColor = color;
                                  },
                                ),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text('Got it'),
                                  onPressed: () {
                                    if (newColor != null) {
                                      setState(() =>
                                          editorState.primaryColor = newColor!);
                                    }
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  stream: rebuildStream,
                );
              },
              bodyItems: (editorState, rebuildStream) => [
                ReactiveWidget(
                  stream: rebuildStream,
                  builder: (_) => Padding(
                    padding: const EdgeInsets.only(top: kToolbarHeight),
                    child: GroundedTextSizeSlider(textEditor: editorState),
                  ),
                ),
              ],
            ),
          ),
          cropRotateEditor: CropRotateEditorConfigs(
            style: const CropRotateEditorStyle(
              cropCornerColor: Color(0xFFFFFFFF),
              cropCornerLength: 36,
              cropCornerThickness: 4,
              background: Color(0xFF000000),
              bottomBarBackground: Color(0xFF161616),
              helperLineColor: Color(0x25FFFFFF),
            ),
            widgets: CropRotateEditorWidgets(
              appBar: (cropRotateEditor, rebuildStream) => null,
              bottomBar: (cropRotateEditor, rebuildStream) => ReactiveWidget(
                stream: rebuildStream,
                builder: (_) => GroundedCropRotateBar(
                  configs: cropRotateEditor.configs,
                  callbacks: cropRotateEditor.callbacks,
                  editor: cropRotateEditor,
                  selectedRatioColor: kImageEditorPrimaryColor,
                ),
              ),
            ),
          ),
          filterEditor: FilterEditorConfigs(
            fadeInUpDuration: kGroundedFadeInDuration,
            fadeInUpStaggerDelayDuration: kGroundedFadeInStaggerDelay,
            style: const FilterEditorStyle(
              filterListSpacing: 7,
              filterListMargin: EdgeInsets.fromLTRB(8, 0, 8, 8),
              background: Color(0xFF000000),
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
              appBar: (editorState, rebuildStream) => null,
              bottomBar: (editorState, rebuildStream) {
                return ReactiveWidget(
                  builder: (context) {
                    return GroundedFilterBar(
                      configs: editorState.configs,
                      callbacks: editorState.callbacks,
                      editor: editorState,
                    );
                  },
                  stream: rebuildStream,
                );
              },
            ),
          ),
          tuneEditor: TuneEditorConfigs(
            style: const TuneEditorStyle(
              background: Color(0xFF000000),
              bottomBarBackground: Color(0xFF161616),
            ),
            widgets: TuneEditorWidgets(
              appBar: (editor, rebuildStream) => null,
              bottomBar: (editorState, rebuildStream) {
                return ReactiveWidget(
                  builder: (context) {
                    return GroundedTuneBar(
                      configs: editorState.configs,
                      callbacks: editorState.callbacks,
                      editor: editorState,
                    );
                  },
                  stream: rebuildStream,
                );
              },
            ),
          ),
          blurEditor: BlurEditorConfigs(
            style: const BlurEditorStyle(
              background: Color(0xFF000000),
            ),
            widgets: BlurEditorWidgets(
              appBar: (blurEditor, rebuildStream) => null,
              bottomBar: (editorState, rebuildStream) {
                return ReactiveWidget(
                  builder: (context) {
                    return GroundedBlurBar(
                      configs: editorState.configs,
                      callbacks: editorState.callbacks,
                      editor: editorState,
                    );
                  },
                  stream: rebuildStream,
                );
              },
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
          i18n: const I18n(
            paintEditor: I18nPaintEditor(
              changeOpacity: 'Opacity',
              lineWidth: 'Thickness',
            ),
            textEditor: I18nTextEditor(
              backgroundMode: 'Mode',
              textAlign: 'Align',
            ),
          ),
          stickerEditor: StickerEditorConfigs(
            enabled: true,
            buildStickers: (setLayer, scrollController) => DemoBuildStickers(
                categoryColor: const Color(0xFF161616),
                setLayer: setLayer,
                scrollController: scrollController),
          ),
          dialogConfigs: DialogConfigs(
            widgets: DialogWidgets(
              loadingDialog: (message, configs) => GroundedLoadingDialog(
                message: message,
                configs: configs,
              ),
            ),
          ),
        ),
      );
    });
  }
}
