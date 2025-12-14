import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:magicepaperapp/constants/asset_paths.dart';
import 'package:magicepaperapp/pro_image_editor/features/bottom_bar.dart';
import 'package:magicepaperapp/pro_image_editor/features/barcode_editor.dart';
import 'package:magicepaperapp/pro_image_editor/features/text_bottom_bar.dart';
import 'package:magicepaperapp/provider/color_palette_provider.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/util/orientation_util.dart';
import 'package:magicepaperapp/util/template_util.dart';
import 'package:pro_image_editor/core/models/layers/layer_interaction.dart';
import 'package:pro_image_editor/designs/whatsapp/whatsapp_paint_colorpicker.dart';
import 'package:pro_image_editor/designs/whatsapp/whatsapp_text_colorpicker.dart';
import 'package:pro_image_editor/designs/whatsapp/whatsapp_text_size_slider.dart';
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
  final int width;
  final int height;
  final List<LayerSpec>? initialLayers;

  const MovableBackgroundImageExample({
    super.key,
    required this.width,
    required this.height,
    this.initialLayers,
  });

  @override
  State<MovableBackgroundImageExample> createState() =>
      _MovableBackgroundImageExampleState();
}

class _MovableBackgroundImageExampleState
    extends State<MovableBackgroundImageExample>
    with ExampleHelperState<MovableBackgroundImageExample> {
  late final ScrollController _bottomBarScrollCtrl;
  String _currentCanvasColor = 'white';

  /// Better sense of scale when we start with a large number
  final double _initScale = 20;

  /// Calculated canvas dimensions based on screen constraints
  late double _canvasWidth;
  late double _canvasHeight;

  final _bottomTextStyle = const TextStyle(fontSize: 10.0, color: Colors.white);

  @override
  void initState() {
    super.initState();
    setPortraitOrientation();
    preCacheImage(assetPath: ImageAssets.whiteBoard);
    preCacheImage(assetPath: ImageAssets.redBoard);
    preCacheImage(assetPath: ImageAssets.blackBoard);
    preCacheImage(assetPath: ImageAssets.greenBoard);
    preCacheImage(assetPath: ImageAssets.blueBoard);
    preCacheImage(assetPath: ImageAssets.orangeBoard);
    preCacheImage(assetPath: ImageAssets.yellowBoard);
    _bottomBarScrollCtrl = ScrollController();
  }

  @override
  void dispose() {
    _bottomBarScrollCtrl.dispose();
    super.dispose();
  }

  /// Add multiple layers as separate layers after editor is ready, with custom offset, scale and rotation
  void addInitialLayers(List<LayerSpec> layers) {
    final editor = editorKey.currentState;
    if (editor == null) return;
    for (final layer in layers) {
      if (layer.text != null) {
        editor.addLayer(
          TextLayer(
            maxTextWidth: _canvasWidth - 70,
            textStyle: layer.textStyle,
            align: layer.textAlign ?? TextAlign.left,
            offset: layer.offset,
            scale: layer.scale,
            rotation: layer.rotation,
            color: layer.textColor ?? Colors.black,
            background: layer.backgroundColor ?? Colors.white,
            colorMode: LayerBackgroundMode.backgroundAndColor,
            text: layer.text!,
            interaction: LayerInteraction(
              enableEdit: true,
              enableMove: true,
              enableRotate: true,
              enableScale: true,
              enableSelection: true,
            ),
          ),
          blockSelectLayer: true,
        );
      } else if (layer.widget != null) {
        editor.addLayer(
          WidgetLayer(
            interaction: LayerInteraction(
              enableEdit: true,
              enableMove: true,
              enableRotate: true,
              enableScale: true,
              enableSelection: true,
            ),
            offset: layer.offset,
            scale: layer.scale,
            rotation: layer.rotation,
            widget: layer.widget!,
          ),
        );
      }
    }
  }

  void _calculateCanvasDimensions(Size screenSize) {
    final double targetAspectRatio = widget.width / widget.height;
    final double availableWidth = screenSize.width - 32;
    final double availableHeight =
        screenSize.height - kToolbarHeight - kBottomNavigationBarHeight - 100;

    double calculatedWidth = min(widget.width.toDouble(), availableWidth);
    double calculatedHeight = calculatedWidth / targetAspectRatio;

    if (calculatedHeight > availableHeight) {
      calculatedHeight = availableHeight;
      calculatedWidth = calculatedHeight * targetAspectRatio;
    }

    _canvasWidth = calculatedWidth;
    _canvasHeight = calculatedHeight;
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
            color: Colors.black,
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

  final List<Color> availableCanvasColors =
      getIt<ColorPaletteProvider>().colors;
  int currentCanvasColorIndex = 0;

  String _getCanvasColorName(Color color) {
    if (color == Colors.white) {
      return 'white';
    } else if (color == Colors.red) {
      return 'red';
    } else if (color == Colors.black) {
      return 'black';
    } else if (color == Colors.green) {
      return 'green';
    } else if (color == Colors.blue) {
      return 'blue';
    } else if (color == Colors.yellow) {
      return 'yellow';
    } else if (color == Colors.orange) {
      return 'orange';
    }

    return 'white';
  }

  void _changeCanvasColor() {
    setState(() {
      currentCanvasColorIndex =
          (currentCanvasColorIndex + 1) % availableCanvasColors.length;

      _currentCanvasColor =
          _getCanvasColorName(availableCanvasColors[currentCanvasColorIndex]);
    });

    // Update the canvas by replacing the first layer
    editorKey.currentState?.replaceLayer(
      index: 0, // Replace first layer (canvas)
      layer: WidgetLayer(
        interaction: LayerInteraction(
          enableEdit: false,
          enableMove: false,
          enableRotate: false,
          enableScale: false,
          enableSelection: false,
        ),
        offset: Offset.zero,
        scale: _initScale,
        widget: Image.asset(
          'assets/canvas/$_currentCanvasColor.png',
          width: _canvasWidth,
          height: _canvasHeight,
          fit: BoxFit.cover,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            return AnimatedSwitcher(
              layoutBuilder: (currentChild, previousChildren) {
                return SizedBox(
                  width: _canvasWidth,
                  height: _canvasHeight,
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

  void _openBarcodeSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return BarcodeEditor(
          onBarcodeCreated: (layer) {
            editorKey.currentState?.addLayer(layer);
            Navigator.pop(context);
          },
          initialScale: _initScale,
        );
      },
    );
  }

  Future<Uint8List> _loadAndResizeWhiteBoard() async {
    final ByteData data = await rootBundle.load(ImageAssets.whiteBoard);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: _canvasWidth.toInt(),
      targetHeight: _canvasHeight.toInt(),
    );
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image image = frameInfo.image;
    final ByteData? pngBytes =
        await image.toByteData(format: ui.ImageByteFormat.png);
    return pngBytes!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    _calculateCanvasDimensions(MediaQuery.sizeOf(context));
    return LayoutBuilder(builder: (context, constraints) {
      return CustomPaint(
        size: Size(constraints.maxWidth, constraints.maxHeight),
        painter: const PixelTransparentPainter(
          primary: Colors.white,
          secondary: Color(0xFFE2E2E2),
        ),
        child: FutureBuilder<Uint8List>(
          future: _loadAndResizeWhiteBoard(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return ProImageEditor.memory(
              snapshot.data!,
              key: editorKey,
              callbacks: ProImageEditorCallbacks(
                onImageEditingComplete: (Uint8List bytes) async {
                  Navigator.pop(context, bytes);
                },
                mainEditorCallbacks: MainEditorCallbacks(
                  helperLines: const HelperLinesCallbacks(),
                  onAfterViewInit: () {
                    editorKey.currentState!.addLayer(
                      WidgetLayer(
                        interaction: LayerInteraction(
                          enableEdit: false,
                          enableMove: false,
                          enableRotate: false,
                          enableScale: false,
                          enableSelection: false,
                        ),
                        offset: Offset.zero,
                        scale: _initScale,
                        widget: Image.asset(
                          ImageAssets.whiteBoard,
                          width: _canvasWidth,
                          height: _canvasHeight,
                          fit: BoxFit.cover,
                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) {
                            return AnimatedSwitcher(
                              layoutBuilder: (currentChild, previousChildren) {
                                return SizedBox(
                                  width: _canvasWidth,
                                  height: _canvasHeight,
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

                    // Add initial layers from widget parameter
                    if (widget.initialLayers != null) {
                      addInitialLayers(widget.initialLayers!);
                    }
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
                  enableZoom: true,
                  enableCloseButton: !isDesktopMode(context),
                  widgets: MainEditorWidgets(
                    bodyItems: (editor, rebuildStream) {
                      return [
                        ReactiveWidget(
                          stream: rebuildStream,
                          builder: (_) => editor.isSubEditorOpen
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
                                      onPressed: () =>
                                          _openReorderSheet(editor),
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
                    background: ui.Color.fromARGB(255, 155, 152, 152),
                  ),
                ),
                paintEditor: PaintEditorConfigs(
                  enableZoom: true,
                  widgets: PaintEditorWidgets(
                    colorPicker:
                        (editor, rebuildStream, currentColor, setColor) => null,
                    bodyItems: _buildPaintEditorBody,
                  ),
                  style: const PaintEditorStyle(
                    initialColor: Colors.black,
                    uiOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: Colors.black,
                    ),
                    background: Colors.black,
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
                    colorPicker:
                        (editor, rebuildStream, currentColor, setColor) => null,
                    bottomBar: (textEditor, rebuildStream) => null,
                    bodyItems: _buildTextEditorBody,
                  ),
                  style: TextEditorStyle(
                      textFieldMargin: EdgeInsets.zero,
                      bottomBarBackground: Colors.black,
                      bottomBarMainAxisAlignment: !_useMaterialDesign
                          ? MainAxisAlignment.spaceEvenly
                          : MainAxisAlignment.start),
                ),
                cropRotateEditor: const CropRotateEditorConfigs(enabled: false),
                filterEditor: const FilterEditorConfigs(enabled: false),
                blurEditor: const BlurEditorConfigs(enabled: false),
                stickerEditor: StickerEditorConfigs(
                  enabled: false,
                  initWidth:
                      (_editorSize.aspectRatio > (widget.width / widget.height)
                              ? _editorSize.height
                              : _editorSize.width) /
                          _initScale,
                  builder: (setLayer, scrollController) {
                    return const SizedBox();
                  },
                ),
              ),
            );
          },
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
                      icon: Container(
                        width: 22.0,
                        height: 22.0,
                        decoration: BoxDecoration(
                          color: availableCanvasColors[currentCanvasColorIndex],
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(4),
                        ),
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
                      onPressed: () => editorKey.currentState!.openTextEditor(),
                    ),
                    FlatIconTextButton(
                      label: Text('Barcode', style: _bottomTextStyle),
                      icon: const Icon(
                        Icons.qr_code,
                        size: 22.0,
                        color: Colors.white,
                      ),
                      onPressed: _openBarcodeSheet,
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
