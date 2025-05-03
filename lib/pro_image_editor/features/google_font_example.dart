// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

// Project imports:
import '../core/constants/example_constants.dart';
import '../core/mixin/example_helper.dart';
import '../shared/widgets/prepare_image_widget.dart';


/// The google font example
class GoogleFontExample extends StatefulWidget {
  /// Creates a new [GoogleFontExample] widget.
  const GoogleFontExample({super.key});

  @override
  State<GoogleFontExample> createState() => _GoogleFontExampleState();
}

class _GoogleFontExampleState extends State<GoogleFontExample>
    with ExampleHelperState<GoogleFontExample> {
  bool _ignorePlatformIssue = false;

  @override
  void initState() {
    super.initState();
    preCacheImage(assetPath: kImageEditorExampleAssetPath);
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb && Platform.isWindows && !_ignorePlatformIssue) {
      return Scaffold(
        appBar: AppBar(),
        body: Column(
          spacing: 16,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _ignorePlatformIssue = true;
                });
              },
              child: const Text('Ignore Error'),
            ),
            Expanded(
              child: ErrorWidget(
                'Windows didn\'t support "GoogleFonts.notoColorEmoji"',
              ),
            ),
          ],
        ),
      );
    } else if (!isPreCached) {
      return const PrepareImageWidget();
    }

    return ProImageEditor.asset(
      kImageEditorExampleAssetPath,
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
        textEditor: TextEditorConfigs(
          showSelectFontStyleBottomBar: true,
          customTextStyles: [
            GoogleFonts.roboto(),
            GoogleFonts.averiaLibre(),
            GoogleFonts.lato(),
            GoogleFonts.comicNeue(),
            GoogleFonts.actor(),
            GoogleFonts.odorMeanChey(),
            GoogleFonts.nabla(),
          ],
        ),
        emojiEditor: EmojiEditorConfigs(
          checkPlatformCompatibility: false,
          style: EmojiEditorStyle(
            textStyle: DefaultEmojiTextStyle.copyWith(
              fontFamily: GoogleFonts.notoColorEmoji().fontFamily,
            ),
          ),
        ),
      ),
    );
  }
}
