import 'package:flutter/material.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

import '../core/constants/example_constants.dart';
import '../core/mixin/example_helper.dart';
import '../shared/widgets/prepare_image_widget.dart';

/// The example for translations from emoji search texts
class EmojiTranslateExample extends StatefulWidget {
  /// Creates a new [EmojiTranslateExample] widget.
  const EmojiTranslateExample({super.key});

  @override
  State<EmojiTranslateExample> createState() => _EmojiTranslateExampleState();
}

class _EmojiTranslateExampleState extends State<EmojiTranslateExample>
    with ExampleHelperState<EmojiTranslateExample> {
  late final _callbacks = ProImageEditorCallbacks(
    onImageEditingStarted: onImageEditingStarted,
    onImageEditingComplete: onImageEditingComplete,
    onCloseEditor: (editorMode) => onCloseEditor(
      editorMode: editorMode,
      enablePop: !isDesktopMode(context),
    ),
    mainEditorCallbacks: MainEditorCallbacks(
      helperLines: HelperLinesCallbacks(onLineHit: vibrateLineHit),
    ),
  );

  final bool _enableSpecificExample = true;

  @override
  void initState() {
    super.initState();
    preCacheImage(assetPath: kImageEditorExampleAssetPath);
  }

  @override
  Widget build(BuildContext context) {
    if (!isPreCached) return const PrepareImageWidget();

    if (_enableSpecificExample) {
      return _buildWithSpecificLocale();
    } else {
      return _buildWithAutoLocale();
    }
  }

  Widget _buildWithSpecificLocale() {
    return ProImageEditor.asset(
      kImageEditorExampleAssetPath,
      key: editorKey,
      callbacks: _callbacks,
      configs: ProImageEditorConfigs(
        designMode: platformDesignMode,
        emojiEditor: EmojiEditorConfigs(
          /// Set your required locale below
          /// - `emojiSetGerman`
          /// - `emojiSetEnglish`
          /// - `emojiSetSpanish`
          /// - `emojiSetFrench`
          /// - `emojiSetHindi`
          /// - `emojiSetItalian`
          /// - `emojiSetJapanese`
          /// - `emojiSetPortuguese`
          /// - `emojiSetRussian`
          /// - `emojiSetChinese`
          emojiSet: (locale) => emojiSetGerman,
        ),
      ),
    );
  }

  Widget _buildWithAutoLocale() {
    return ProImageEditor.asset(
      kImageEditorExampleAssetPath,
      key: editorKey,
      callbacks: _callbacks,
      configs: ProImageEditorConfigs(
        designMode: platformDesignMode,
        i18n: const I18n(
          emojiEditor: I18nEmojiEditor(
            enableSearchAutoI18n: true,

            /// Optional you can set a specific locale. By default it use
            /// Localizations.localeOf(context)
            ///
            /// locale: Locale('en'),
          ),
        ),
      ),
    );
  }
}
