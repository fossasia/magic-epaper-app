// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:pro_image_editor/pro_image_editor.dart';

// Project imports:
import '../core/constants/example_constants.dart';
import '../core/mixin/example_helper.dart';
import '../shared/widgets/prepare_image_widget.dart';


/// The image-format-convert example
class ImageFormatConvertExample extends StatefulWidget {
  /// Creates a new [ImageFormatConvertExample] widget.
  const ImageFormatConvertExample({super.key});

  @override
  State<ImageFormatConvertExample> createState() =>
      _ImageFormatConvertExampleState();
}

class _ImageFormatConvertExampleState extends State<ImageFormatConvertExample>
    with ExampleHelperState<ImageFormatConvertExample> {
  // ignore: unused_element
  Future<void> _convertImage(Uint8List bytes) async {
    try {
      /// Install first `flutter_image_compress: any` and import it
      /// import 'package:flutter_image_compress/flutter_image_compress.dart';
      ///
      /// FlutterImageCompress is not supported for windows and linux
      if (!kIsWeb && (Platform.isLinux || Platform.isWindows)) {
        throw ArgumentError(
            'This platform didn\'t support the package "FlutterImageCompress"');
      } else {
        /// Supports only Android, iOS, Web, MacOS
        /// final result = await FlutterImageCompress.compressWithList(
        ///   bytes,
        ///   format: CompressFormat
        ///       .webp, // For web follow this url => https://pub.dev/packages/flutter_image_compress#web
        ///   // format: CompressFormat.heic,
        /// );
        /// editedBytes = result;
        /// debugPrint('Converted image size: ${result.length}');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

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
      callbacks: ProImageEditorCallbacks(
        onImageEditingStarted: onImageEditingStarted,
        onImageEditingComplete: (bytes) async {
          editedBytes = bytes;

          /// For special formats like webp, you can uncomment the line below,
          /// and follow the instructions there.
          /// await _convertImage(bytes);

          setGenerationTime();
        },
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
          /// Choose the output format below
          outputFormat: kIsWeb ? OutputFormat.png : OutputFormat.tiff,
          pngFilter: PngFilter.none,
          pngLevel: 6,
          jpegChroma: JpegChroma.yuv444,
          jpegQuality: 100,
        ),
      ),
    );
  }
}
