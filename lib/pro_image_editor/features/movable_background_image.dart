// Dart imports:
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:magic_epaper_app/pro_image_editor/features/bottom_bar.dart';
import 'package:magic_epaper_app/pro_image_editor/features/text_bottom_bar.dart';
import 'package:pro_image_editor/designs/whatsapp/whatsapp_paint_colorpicker.dart';
import 'package:pro_image_editor/designs/whatsapp/whatsapp_text_colorpicker.dart';
import 'package:pro_image_editor/designs/whatsapp/whatsapp_text_size_slider.dart';
import 'package:pro_image_editor/designs/whatsapp/widgets/appbar/whatsapp_paint_appbar.dart';
import 'package:pro_image_editor/designs/whatsapp/widgets/appbar/whatsapp_text_appbar.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import '../core/mixin/example_helper.dart';
import '../shared/widgets/material_icon_button.dart';
import '../shared/widgets/pixel_transparent_painter.dart';
import 'reorder_layer_example.dart';

final bool _useMaterialDesign =
    platformDesignMode == ImageEditorDesignMode.material;

/// The example for movableBackground
class MovableBackgroundImageExample extends StatefulWidget {
  /// Creates a new [MovableBackgroundImageExample] widget.
  const MovableBackgroundImageExample({super.key});

  @override
  State<MovableBackgroundImageExample> createState() =>
      _MovableBackgroundImageExampleState();
}

class _MovableBackgroundImageExampleState
    extends State<MovableBackgroundImageExample>
    with ExampleHelperState<MovableBackgroundImageExample> {
  late final ScrollController _bottomBarScrollCtrl;
  //Uint8List? _transparentBytes;
  //double _transparentAspectRatio = -1;
  String _currentCanvasColor = 'white';

  /// Better sense of scale when we start with a large number
  final double _initScale = 20;

  /// set the aspect ratio from your image.
  final double _imgRatio = 1;

  final _bottomTextStyle = const TextStyle(fontSize: 10.0, color: Colors.white);

  @override
  void initState() {
    super.initState();
    preCacheImage(assetPath: 'assets/canvas/white.png');
    preCacheImage(assetPath: 'assets/canvas/red.png');
    preCacheImage(assetPath: 'assets/canvas/black.png');
    //_createTransparentImage(_imgRatio);
    _bottomBarScrollCtrl = ScrollController();
  }

  @override
  void dispose() {
    _bottomBarScrollCtrl.dispose();
    super.dispose();
  }

  void _openPicker(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image == null) return;

    Uint8List? bytes;

    bytes = await image.readAsBytes();

    if (!mounted) return;
    await precacheImage(MemoryImage(bytes), context);
    var decodedImage = await decodeImageFromList(bytes);

    if (!mounted) return;
    if (kIsWeb ||
        (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS)) {
      Navigator.pop(context);
    }

    editorKey.currentState!.addLayer(
      WidgetLayer(
        offset: Offset.zero,
        scale: _initScale * 0.5,
        widget: Image.memory(
          bytes,
          width: decodedImage.width.toDouble(),
          height: decodedImage.height.toDouble(),
          fit: BoxFit.cover,
        ),
      ),
    );
    setState(() {});
  }

  void _chooseCameraOrGallery() async {
    /// Open directly the gallery if the camera is not supported
    if (!kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      _openPicker(ImageSource.gallery);
      return;
    }

    if (!kIsWeb && Platform.isIOS) {
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoTheme(
          data: const CupertinoThemeData(),
          child: CupertinoActionSheet(
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                onPressed: () => _openPicker(ImageSource.camera),
                child: const Wrap(
                  spacing: 7,
                  runAlignment: WrapAlignment.center,
                  children: [
                    Icon(CupertinoIcons.photo_camera),
                    Text('Camera'),
                  ],
                ),
              ),
              CupertinoActionSheetAction(
                onPressed: () => _openPicker(ImageSource.gallery),
                child: const Wrap(
                  spacing: 7,
                  runAlignment: WrapAlignment.center,
                  children: [
                    Icon(CupertinoIcons.photo),
                    Text('Gallery'),
                  ],
                ),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ),
        ),
      );
    } else {
      await showModalBottomSheet(
        context: context,
        showDragHandle: true,
        constraints: BoxConstraints(
          minWidth: min(MediaQuery.sizeOf(context).width, 360),
        ),
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
                child: Wrap(
                  spacing: 45,
                  runSpacing: 30,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  alignment: WrapAlignment.spaceAround,
                  children: [
                    MaterialIconActionButton(
                      primaryColor: const Color(0xFFEC407A),
                      secondaryColor: const Color(0xFFD3396D),
                      icon: Icons.photo_camera,
                      text: 'Camera',
                      onTap: () => _openPicker(ImageSource.camera),
                    ),
                    MaterialIconActionButton(
                      primaryColor: const Color(0xFFBF59CF),
                      secondaryColor: const Color(0xFFAC44CF),
                      icon: Icons.image,
                      text: 'Gallery',
                      onTap: () => _openPicker(ImageSource.gallery),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  // Future<void> _createTransparentImage(double aspectRatio) async {
  //   //double minSize = 1;

  //   double width = 240;
  //   double height = 416;

  //   final recorder = ui.PictureRecorder();
  //   final canvas = Canvas(
  //       recorder, Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));
  //   final paint = Paint()..color = Colors.white;
  //   canvas.drawRect(
  //       Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()), paint);

  //   final picture = recorder.endRecording();
  //   final img = await picture.toImage(width.toInt(), height.toInt());
  //   final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);

  //   _transparentAspectRatio = aspectRatio;
  //   _transparentBytes = pngBytes!.buffer.asUint8List();
  // }

// Add this method to handle canvas color changes
  void _changeCanvasColor() {
    setState(() {
      // Cycle through colors: white -> red -> black
      switch (_currentCanvasColor) {
        case 'white':
          _currentCanvasColor = 'red';
          break;
        case 'red':
          _currentCanvasColor = 'black';
          break;
        case 'black':
          _currentCanvasColor = 'white';
          break;
      }
    });

    // Update the canvas by replacing the first layer
    editorKey.currentState?.replaceLayer(
      index: 0, // Replace first layer (canvas)
      layer: WidgetLayer(
        offset: Offset.zero,
        scale: _initScale,
        widget: Image.asset(
          'assets/canvas/${_currentCanvasColor}.png',
          width: _editorSize.width,
          height: _editorSize.height,
          fit: BoxFit.cover,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            return AnimatedSwitcher(
              layoutBuilder: (currentChild, previousChildren) {
                return SizedBox(
                  width: 240,
                  height: 416,
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: <Widget>[
                      ...previousChildren,
                      if (currentChild != null) currentChild,
                    ],
                  ),
                );
              },
              duration: const Duration(milliseconds: 100),
              child: frame != null
                  ? child
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            );
          },
        ),
      ),
    );
  }

  Size get _editorSize => Size(
        MediaQuery.sizeOf(context).width -
            MediaQuery.paddingOf(context).horizontal,
        MediaQuery.sizeOf(context).height -
            kToolbarHeight -
            kBottomNavigationBarHeight -
            MediaQuery.paddingOf(context).vertical,
      );

  void _openReorderSheet(ProImageEditorState editor) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ReorderLayerSheet(
          layers: editor.activeLayers,
          onReorder: (oldIndex, newIndex) {
            editor.moveLayerListPosition(
              oldIndex: oldIndex,
              newIndex: newIndex,
            );
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /*if (_transparentBytes == null || !isPreCached) {
      return const PrepareImageWidget();
    }
    print('_transparentBytes: ${_transparentBytes!}');
    var i;
    for (i in _transparentBytes!) {
      print(i);
    }*/

    return LayoutBuilder(builder: (context, constraints) {
      return CustomPaint(
        size: Size(constraints.maxWidth, constraints.maxHeight),
        painter: const PixelTransparentPainter(
          primary: Colors.white,
          secondary: Color(0xFFE2E2E2),
        ),
        child: ProImageEditor.asset(
          'assets/canvas/white.png',
          key: editorKey,
          callbacks: ProImageEditorCallbacks(
            onImageEditingStarted: onImageEditingStarted,
            onImageEditingComplete: (Uint8List bytes) async {
              Navigator.pop(context, bytes);
            },
            onCloseEditor: (editorMode) {
              // Handle normal close without editing completion
              Navigator.of(context).pop();
            },
            mainEditorCallbacks: MainEditorCallbacks(
              helperLines: HelperLinesCallbacks(onLineHit: vibrateLineHit),
              onAfterViewInit: () {
                editorKey.currentState!.addLayer(
                  WidgetLayer(
                    offset: Offset.zero,
                    scale: _initScale,
                    widget: Image.asset(
                      'assets/canvas/white.png',
                      width: 240,
                      height: 416,
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                        return AnimatedSwitcher(
                          layoutBuilder: (currentChild, previousChildren) {
                            return SizedBox(
                              width: 240,
                              height: 416,
                              child: Stack(
                                fit: StackFit.expand,
                                alignment: Alignment.center,
                                children: <Widget>[
                                  ...previousChildren,
                                  if (currentChild != null) currentChild,
                                ],
                              ),
                            );
                          },
                          duration: const Duration(milliseconds: 1),
                          child: frame != null
                              ? child
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          configs: ProImageEditorConfigs(
            designMode: platformDesignMode,
            imageGeneration: ImageGenerationConfigs(
              cropToDrawingBounds: true,
              allowEmptyEditingCompletion: false,
              outputFormat: OutputFormat.png,

              /// Set the pixel ratio manually. You can also set this
              /// value higher than the device pixel ratio for higher
              /// quality.
              customPixelRatio: max(2000 / MediaQuery.sizeOf(context).width,
                  MediaQuery.devicePixelRatioOf(context)),
            ),
            mainEditor: MainEditorConfigs(
              enableCloseButton: !isDesktopMode(context),
              widgets: MainEditorWidgets(
                bodyItems: (editor, rebuildStream) {
                  return [
                    ReactiveWidget(
                      stream: rebuildStream,
                      builder: (_) => editor.selectedLayerIndex >= 0 ||
                              editor.isSubEditorOpen
                          ? const SizedBox.shrink()
                          : Positioned(
                              bottom: 20,
                              left: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue.shade200,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(100),
                                    bottomRight: Radius.circular(100),
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () => _openReorderSheet(editor),
                                  icon: const Icon(
                                    Icons.reorder,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ];
                },
                bottomBar: (editor, rebuildStream, key) => ReactiveWidget(
                  stream: rebuildStream,
                  key: key,
                  builder: (_) => _bottomNavigationBar(
                    editor,
                    constraints,
                  ),
                ),
              ),
              style: const MainEditorStyle(
                uiOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.black,
                ),
                background: Colors.transparent,
              ),
            ),
            paintEditor: PaintEditorConfigs(
              widgets: PaintEditorWidgets(
                colorPicker: (editor, rebuildStream, currentColor, setColor) =>
                    null,
                bodyItems: _buildPaintEditorBody,
              ),
              style: const PaintEditorStyle(
                initialColor: Colors.black,
                uiOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.black,
                ),
                background: Colors.transparent,
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
              widgets: TextEditorWidgets(
                appBar: (textEditor, rebuildStream) => null,
                colorPicker: (editor, rebuildStream, currentColor, setColor) =>
                    null,
                bottomBar: (textEditor, rebuildStream) => null,
                bodyItems: _buildTextEditorBody,
              ),
              style: TextEditorStyle(
                  textFieldMargin: EdgeInsets.zero,
                  bottomBarBackground: Colors.transparent,
                  bottomBarMainAxisAlignment: !_useMaterialDesign
                      ? MainAxisAlignment.spaceEvenly
                      : MainAxisAlignment.start),
            ),

            /// Crop-Rotate, Filter and Blur editors are not supported
            cropRotateEditor: const CropRotateEditorConfigs(enabled: false),
            filterEditor: const FilterEditorConfigs(enabled: false),
            blurEditor: const BlurEditorConfigs(enabled: false),

            stickerEditor: StickerEditorConfigs(
              enabled: false,
              initWidth: (_editorSize.aspectRatio > _imgRatio
                      ? _editorSize.height
                      : _editorSize.width) /
                  _initScale,
              buildStickers: (setLayer, scrollController) {
                // Optionally your code to pick layers
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });
  }

  Widget _bottomNavigationBar(
    ProImageEditorState editor,
    BoxConstraints constraints,
  ) {
    return Scrollbar(
      controller: _bottomBarScrollCtrl,
      scrollbarOrientation: ScrollbarOrientation.top,
      thickness: isDesktop ? null : 0,
      child: BottomAppBar(
        /// kBottomNavigationBarHeight is important that helper-lines will work
        height: kBottomNavigationBarHeight,
        color: Colors.black,
        padding: EdgeInsets.zero,
        child: Center(
          child: SingleChildScrollView(
            controller: _bottomBarScrollCtrl,
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: min(constraints.maxWidth, 500),
                maxWidth: 500,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FlatIconTextButton(
                      label: Text('Canvas Color', style: _bottomTextStyle),
                      icon: const Icon(
                        Icons.check_box_outline_blank,
                        size: 22.0,
                        color: Colors.white,
                      ),
                      onPressed: _changeCanvasColor,
                    ),
                    FlatIconTextButton(
                      label: Text('Add Image', style: _bottomTextStyle),
                      icon: const Icon(
                        Icons.image_outlined,
                        size: 22.0,
                        color: Colors.white,
                      ),
                      onPressed: _chooseCameraOrGallery,
                    ),
                    FlatIconTextButton(
                      label: Text('Paint', style: _bottomTextStyle),
                      icon: const Icon(
                        Icons.edit_rounded,
                        size: 22.0,
                        color: Colors.white,
                      ),
                      onPressed: editor.openPaintEditor,
                    ),
                    FlatIconTextButton(
                      label: Text('Text', style: _bottomTextStyle),
                      icon: const Icon(
                        Icons.text_fields,
                        size: 22.0,
                        color: Colors.white,
                      ),
                      onPressed: editor.openTextEditor,
                    ),
                    FlatIconTextButton(
                      label: Text('Emoji', style: _bottomTextStyle),
                      icon: const Icon(
                        Icons.sentiment_satisfied_alt_rounded,
                        size: 22.0,
                        color: Colors.white,
                      ),
                      onPressed: editor.openEmojiEditor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

List<ReactiveWidget> _buildPaintEditorBody(
  PaintEditorState paintEditor,
  Stream<dynamic> rebuildStream,
) {
  return [
    ReactiveWidget(
      stream: rebuildStream,
      builder: (_) => BottomBarCustom(
        configs: paintEditor.configs,
        strokeWidth: paintEditor.paintCtrl.strokeWidth,
        onColorChanged: (color) {
          paintEditor.paintCtrl.setColor(color);
          paintEditor.uiPickerStream.add(null);
        },
        onSetLineWidth: paintEditor.setStrokeWidth,
      ),
    ),
    if (!_useMaterialDesign)
      ReactiveWidget(
        stream: rebuildStream,
        builder: (_) => WhatsappPaintColorpicker(paintEditor: paintEditor),
      ),
    ReactiveWidget(
      stream: rebuildStream,
      builder: (_) => WhatsAppPaintAppBar(
        configs: paintEditor.configs,
        canUndo: paintEditor.canUndo,
        onDone: paintEditor.done,
        onTapUndo: paintEditor.undoAction,
        onClose: paintEditor.close,
        activeColor: paintEditor.activeColor,
      ),
    ),
  ];
}

List<ReactiveWidget> _buildTextEditorBody(
  TextEditorState textEditor,
  Stream<dynamic> rebuildStream,
) {
  return [
    /// Color-Picker
    if (_useMaterialDesign)
      ReactiveWidget(
        stream: rebuildStream,
        builder: (_) => Padding(
          padding: const EdgeInsets.only(top: kToolbarHeight),
          child: WhatsappTextSizeSlider(textEditor: textEditor),
        ),
      )
    else
      ReactiveWidget(
        stream: rebuildStream,
        builder: (_) => Padding(
          padding: const EdgeInsets.only(top: kToolbarHeight),
          child: WhatsappTextColorpicker(textEditor: textEditor),
        ),
      ),

    /// Appbar
    ReactiveWidget(
      stream: rebuildStream,
      builder: (_) => WhatsAppTextAppBar(
        configs: textEditor.configs,
        align: textEditor.align,
        onDone: textEditor.done,
        onAlignChange: textEditor.toggleTextAlign,
        onBackgroundModeChange: textEditor.toggleBackgroundMode,
      ),
    ),

    /// Bottombar
    ReactiveWidget(
      stream: rebuildStream,
      builder: (_) => TextBottomBar(
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
