// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

// Project imports:
import '../core/mixin/example_helper.dart';
import '../shared/widgets/prepare_image_widget.dart';

/// A widget that demonstrates a custom app bar and bottom bar layout.
///
/// The [CustomWidgetsExample] widget is a stateful widget that provides
/// an example of how to implement a custom app bar at the top and a custom
/// bottom bar at the bottom of the screen. This is useful in applications
/// where a unique layout or custom controls are needed in both the app bar
/// and the bottom bar.
///
/// The state for this widget is managed by the
/// [_CustomWidgetsExampleState] class.
///
/// Example usage:
/// ```dart
/// CustomAppbarBottombarExample();
/// ```
class CustomWidgetsExample extends StatefulWidget {
  /// Creates a new [CustomWidgetsExample] widget.
  const CustomWidgetsExample({super.key});

  @override
  State<CustomWidgetsExample> createState() => _CustomWidgetsExampleState();
}

/// The state for the [CustomWidgetsExample] widget.
///
/// This class manages the layout and behavior of the custom app bar and
/// bottom bar within the [CustomWidgetsExample] widget.
class _CustomWidgetsExampleState extends State<CustomWidgetsExample>
    with ExampleHelperState<CustomWidgetsExample> {
  late ScrollController _bottomBarScrollCtrl;
  late ScrollController _paintBottomBarScrollCtrl;
  late ScrollController _cropBottomBarScrollCtrl;

  final List<TextStyle> _customTextStyles = [
    GoogleFonts.roboto(),
    GoogleFonts.averiaLibre(),
    GoogleFonts.lato(),
    GoogleFonts.comicNeue(),
    GoogleFonts.actor(),
    GoogleFonts.odorMeanChey(),
    GoogleFonts.nabla(),
  ];

  final _bottomTextStyle = const TextStyle(fontSize: 10.0, color: Colors.white);
  final List<PaintModeBottomBarItem> paintModes = [
    const PaintModeBottomBarItem(
      mode: PaintMode.freeStyle,
      icon: Icons.edit,
      label: 'Freestyle',
    ),
    const PaintModeBottomBarItem(
      mode: PaintMode.arrow,
      icon: Icons.arrow_right_alt_outlined,
      label: 'Arrow',
    ),
    const PaintModeBottomBarItem(
      mode: PaintMode.line,
      icon: Icons.horizontal_rule,
      label: 'Line',
    ),
    const PaintModeBottomBarItem(
      mode: PaintMode.rect,
      icon: Icons.crop_free,
      label: 'Rectangle',
    ),
    const PaintModeBottomBarItem(
      mode: PaintMode.circle,
      icon: Icons.lens_outlined,
      label: 'Circle',
    ),
    const PaintModeBottomBarItem(
      mode: PaintMode.dashLine,
      icon: Icons.power_input,
      label: 'Dash line',
    ),
  ];

  final String _url = 'https://picsum.photos/id/237/2000';

  final _layerInteractionButtonRadius = 10.0;

  @override
  void initState() {
    super.initState();
    preCacheImage(networkUrl: _url);
    _bottomBarScrollCtrl = ScrollController();
    _paintBottomBarScrollCtrl = ScrollController();
    _cropBottomBarScrollCtrl = ScrollController();
  }

  @override
  void dispose() {
    _bottomBarScrollCtrl.dispose();
    _paintBottomBarScrollCtrl.dispose();
    _cropBottomBarScrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isPreCached) return const PrepareImageWidget();

    return LayoutBuilder(builder: (context, constraints) {
      return ProImageEditor.network(
        _url,
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
            widgets: MainEditorWidgets(
              appBar: (editor, rebuildStream) => ReactiveAppbar(
                  stream: rebuildStream, builder: (_) => _buildAppBar(editor)),
              bottomBar: (editor, rebuildStream, key) => ReactiveWidget(
                  stream: rebuildStream,
                  builder: (_) =>
                      _bottomNavigationBar(editor, key, constraints)),
            ),
          ),
          paintEditor: PaintEditorConfigs(
            widgets: PaintEditorWidgets(
              appBar: (paintEditor, rebuildStream) => ReactiveAppbar(
                stream: rebuildStream,
                builder: (_) => _appBarPaintEditor(paintEditor),
              ),
              bottomBar: (paintEditor, rebuildStream) => ReactiveWidget(
                stream: rebuildStream,
                builder: (_) => _bottomBarPaintEditor(paintEditor, constraints),
              ),
            ),
          ),
          textEditor: TextEditorConfigs(
              showSelectFontStyleBottomBar: true,
              customTextStyles: _customTextStyles,
              widgets: TextEditorWidgets(
                appBar: (textEditor, rebuildStream) => ReactiveAppbar(
                  stream: rebuildStream,
                  builder: (_) => _appBarTextEditor(textEditor),
                ),
                bottomBar: (textEditor, rebuildStream) => null,
                bodyItems: (textEditor, rebuildStream) {
                  return [
                    ReactiveWidget(
                      stream: rebuildStream,
                      builder: (_) =>
                          _bottomBarTextEditor(textEditor, constraints),
                    ),
                  ];
                },
              )),
          cropRotateEditor: CropRotateEditorConfigs(
            widgets: CropRotateEditorWidgets(
              appBar: (cropRotateEditor, rebuildStream) => ReactiveAppbar(
                stream: rebuildStream,
                builder: (_) => _appBarCropRotateEditor(cropRotateEditor),
              ),
              bottomBar: (cropRotateEditor, rebuildStream) => ReactiveWidget(
                stream: rebuildStream,
                builder: (_) =>
                    _bottomBarCropEditor(cropRotateEditor, constraints),
              ),
            ),
          ),
          filterEditor: FilterEditorConfigs(
            widgets: FilterEditorWidgets(
              appBar: (filterEditor, rebuildStream) => ReactiveAppbar(
                stream: rebuildStream,
                builder: (_) => _appBarFilterEditor(filterEditor),
              ),
            ),
          ),
          blurEditor: BlurEditorConfigs(
            widgets: BlurEditorWidgets(
              appBar: (blurEditor, rebuildStream) => ReactiveAppbar(
                stream: rebuildStream,
                builder: (_) => _appBarBlurEditor(blurEditor),
              ),
            ),
          ),
          layerInteraction: LayerInteractionConfigs(
            widgets: LayerInteractionWidgets(
              editButton: (rebuildStream, onTap, rotation) => ReactiveWidget(
                builder: (_) {
                  return Positioned(
                    top: 0,
                    right: 0,
                    child: Transform.rotate(
                      angle: rotation,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: onTap,
                          child: Tooltip(
                            message: 'Edit',
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    _layerInteractionButtonRadius * 2),
                                color: Colors.white,
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Colors.black,
                                size: _layerInteractionButtonRadius * 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                stream: rebuildStream,
              ),
              removeButton: (rebuildStream, onTap, rotation) => ReactiveWidget(
                builder: (_) {
                  return Positioned(
                    top: 0,
                    left: 0,
                    child: Transform.rotate(
                      angle: rotation,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: onTap,
                          child: Tooltip(
                            message: 'Remove',
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    _layerInteractionButtonRadius * 2),
                                color: Colors.white,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.black,
                                size: _layerInteractionButtonRadius * 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                stream: rebuildStream,
              ),
              rotateScaleButton: (rebuildStream, onScaleRotateDown,
                      onScaleRotateUp, rotation) =>
                  ReactiveWidget(
                builder: (_) {
                  return Positioned(
                    /// IMPORTANT: The editor currently only supports this
                    /// position for rotation to function correctly
                    bottom: 0,
                    right: 0,
                    child: Transform.rotate(
                      angle: rotation,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Listener(
                          onPointerDown: onScaleRotateDown,
                          onPointerUp: onScaleRotateUp,
                          child: Tooltip(
                            message: 'Rotate',
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    _layerInteractionButtonRadius * 2),
                                color: Colors.white,
                              ),
                              child: Icon(
                                Icons.rotate_90_degrees_ccw,
                                color: Colors.black,
                                size: _layerInteractionButtonRadius * 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                stream: rebuildStream,
              ),
            ),
          ),
        ),
      );
    });
  }

  AppBar _buildAppBar(ProImageEditorState editor) {
    return AppBar(
      automaticallyImplyLeading: false,
      foregroundColor: Colors.white,
      backgroundColor: Colors.black,
      actions: [
        if (!isDesktopMode(context))
          IconButton(
            tooltip: 'Cancel',
            padding: const EdgeInsets.symmetric(horizontal: 8),
            icon: const Icon(Icons.close),
            onPressed: editor.closeEditor,
          ),
        const Spacer(),
        IconButton(
          tooltip: 'My Button',
          color: Colors.amber,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(
            Icons.bug_report,
            color: Colors.amber,
          ),
          onPressed: () {},
        ),
        IconButton(
          tooltip: 'Undo',
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: Icon(
            Icons.undo,
            color: editor.canUndo == true
                ? Colors.white
                : Colors.white.withAlpha(80),
          ),
          onPressed: editor.undoAction,
        ),
        IconButton(
          tooltip: 'Redo',
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: Icon(
            Icons.redo,
            color: editor.canRedo == true
                ? Colors.white
                : Colors.white.withAlpha(80),
          ),
          onPressed: editor.redoAction,
        ),
        IconButton(
          tooltip: 'Done',
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(Icons.done),
          iconSize: 28,
          onPressed: editor.doneEditing,
        ),
      ],
    );
  }

  AppBar _appBarPaintEditor(PaintEditorState paintEditor) {
    return AppBar(
      automaticallyImplyLeading: false,
      foregroundColor: Colors.white,
      backgroundColor: Colors.black,
      actions: [
        IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(Icons.arrow_back),
          onPressed: paintEditor.close,
        ),
        const SizedBox(width: 80),
        const Spacer(),
        IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(
            Icons.line_weight_rounded,
            color: Colors.white,
          ),
          onPressed: paintEditor.openLinWidthBottomSheet,
        ),
        IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            icon: Icon(
              paintEditor.fillBackground == true
                  ? Icons.format_color_reset
                  : Icons.format_color_fill,
              color: Colors.white,
            ),
            onPressed: paintEditor.toggleFill),
        const Spacer(),
        IconButton(
          tooltip: 'My Button',
          color: Colors.amber,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(
            Icons.bug_report,
            color: Colors.amber,
          ),
          onPressed: () {},
        ),
        IconButton(
          tooltip: 'Undo',
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: Icon(
            Icons.undo,
            color: paintEditor.canUndo == true
                ? Colors.white
                : Colors.white.withAlpha(80),
          ),
          onPressed: paintEditor.undoAction,
        ),
        IconButton(
          tooltip: 'Redo',
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: Icon(
            Icons.redo,
            color: paintEditor.canRedo == true
                ? Colors.white
                : Colors.white.withAlpha(80),
          ),
          onPressed: paintEditor.redoAction,
        ),
        IconButton(
          tooltip: 'Done',
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(Icons.done),
          iconSize: 28,
          onPressed: paintEditor.done,
        ),
      ],
    );
  }

  AppBar _appBarTextEditor(TextEditorState textEditor) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(Icons.arrow_back),
          onPressed: textEditor.close,
        ),
        const Spacer(),
        IconButton(
          tooltip: 'My Button',
          color: Colors.amber,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(
            Icons.bug_report,
            color: Colors.amber,
          ),
          onPressed: () {},
        ),
        IconButton(
          onPressed: textEditor.toggleTextAlign,
          icon: Icon(
            textEditor.align == TextAlign.left
                ? Icons.align_horizontal_left_rounded
                : textEditor.align == TextAlign.right
                    ? Icons.align_horizontal_right_rounded
                    : Icons.align_horizontal_center_rounded,
          ),
        ),
        IconButton(
          onPressed: textEditor.toggleBackgroundMode,
          icon: const Icon(Icons.layers_rounded),
        ),
        const Spacer(),
        IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(Icons.done),
          iconSize: 28,
          onPressed: textEditor.done,
        ),
      ],
    );
  }

  AppBar _appBarCropRotateEditor(CropRotateEditorState cropRotateEditor) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(Icons.arrow_back),
          onPressed: cropRotateEditor.close,
        ),
        const Spacer(),
        IconButton(
          tooltip: 'My Button',
          color: Colors.amber,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(
            Icons.bug_report,
            color: Colors.amber,
          ),
          onPressed: () {},
        ),
        IconButton(
          tooltip: 'Undo',
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: Icon(
            Icons.undo,
            color: cropRotateEditor.canUndo
                ? Colors.white
                : Colors.white.withAlpha(80),
          ),
          onPressed: cropRotateEditor.undoAction,
        ),
        IconButton(
          tooltip: 'Redo',
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: Icon(
            Icons.redo,
            color: cropRotateEditor.canRedo
                ? Colors.white
                : Colors.white.withAlpha(80),
          ),
          onPressed: cropRotateEditor.redoAction,
        ),
        IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(Icons.done),
          iconSize: 28,
          onPressed: cropRotateEditor.done,
        ),
      ],
    );
  }

  AppBar _appBarFilterEditor(FilterEditorState filterEditor) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(Icons.arrow_back),
          onPressed: filterEditor.close,
        ),
        const Spacer(),
        IconButton(
          tooltip: 'My Button',
          color: Colors.amber,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(
            Icons.bug_report,
            color: Colors.amber,
          ),
          onPressed: () {},
        ),
        IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(Icons.done),
          iconSize: 28,
          onPressed: filterEditor.done,
        ),
      ],
    );
  }

  AppBar _appBarBlurEditor(BlurEditorState blurEditor) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(Icons.arrow_back),
          onPressed: blurEditor.close,
        ),
        const Spacer(),
        IconButton(
          tooltip: 'My Button',
          color: Colors.amber,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(
            Icons.bug_report,
            color: Colors.amber,
          ),
          onPressed: () {},
        ),
        IconButton(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          icon: const Icon(Icons.done),
          iconSize: 28,
          onPressed: blurEditor.done,
        ),
      ],
    );
  }

  Widget _bottomNavigationBar(
      ProImageEditorState editor, Key key, BoxConstraints constraints) {
    return Scrollbar(
      /// Key is important for correct layer calculations
      key: key,
      controller: _bottomBarScrollCtrl,
      scrollbarOrientation: ScrollbarOrientation.top,
      thickness: isDesktop ? null : 0,
      child: BottomAppBar(
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
                      label: Text('My Button',
                          style:
                              _bottomTextStyle.copyWith(color: Colors.amber)),
                      icon: const Icon(
                        Icons.new_releases_outlined,
                        size: 22.0,
                        color: Colors.amber,
                      ),
                      onPressed: () {},
                    ),
                    FlatIconTextButton(
                      label: Text('Crop/ Rotate', style: _bottomTextStyle),
                      icon: const Icon(
                        Icons.crop_rotate_rounded,
                        size: 22.0,
                        color: Colors.white,
                      ),
                      onPressed: editor.openCropRotateEditor,
                    ),
                    FlatIconTextButton(
                      label: Text('Filter', style: _bottomTextStyle),
                      icon: const Icon(
                        Icons.filter,
                        size: 22.0,
                        color: Colors.white,
                      ),
                      onPressed: editor.openFilterEditor,
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
                    /* Be careful with the sticker editor. It's important you 
                    add your own logic how to load items in 
                    `stickerEditorConfigs`.
                      FlatIconTextButton(
                        key: const ValueKey('open-sticker-editor-btn'),
                        label: Text('Sticker', style: bottomTextStyle),
                        icon: const Icon(
                          Icons.layers_outlined,
                          size: 22.0,
                          color: Colors.white,
                        ),
                        onPressed: editor.openStickerEditor,
                      ), */
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomBarPaintEditor(
      PaintEditorState paintEditor, BoxConstraints constraints) {
    return Scrollbar(
      controller: _paintBottomBarScrollCtrl,
      scrollbarOrientation: ScrollbarOrientation.top,
      thickness: isDesktop ? null : 0,
      child: BottomAppBar(
        height: kBottomNavigationBarHeight,
        color: Colors.black,
        padding: EdgeInsets.zero,
        child: Center(
          child: SingleChildScrollView(
            controller: _paintBottomBarScrollCtrl,
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: min(constraints.maxWidth, 500),
                maxWidth: 500,
              ),
              child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceAround,
                children: <Widget>[
                  FlatIconTextButton(
                    label: Text('My Button',
                        style: _bottomTextStyle.copyWith(color: Colors.amber)),
                    icon: const Icon(
                      Icons.new_releases_outlined,
                      size: 22.0,
                      color: Colors.amber,
                    ),
                    onPressed: () {},
                  ),
                  ...List.generate(
                    paintModes.length,
                    (index) => Builder(
                      builder: (_) {
                        var item = paintModes[index];
                        var color = paintEditor.paintMode == item.mode
                            ? kImageEditorPrimaryColor
                            : const Color(0xFFEEEEEE);

                        return FlatIconTextButton(
                          label: Text(
                            item.label,
                            style: TextStyle(fontSize: 10.0, color: color),
                          ),
                          icon: Icon(item.icon, color: color),
                          onPressed: () {
                            paintEditor.setMode(item.mode);
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomBarTextEditor(
      TextEditorState textEditor, BoxConstraints constraints) {
    var items = _customTextStyles;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: kBottomNavigationBarHeight,
      child: Container(
        color: Colors.black,
        height: kBottomNavigationBarHeight,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minWidth: MediaQuery.sizeOf(context).width),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                items.length,
                (index) {
                  bool isSelected = textEditor.selectedTextStyle.hashCode ==
                      items[index].hashCode;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: IconButton(
                      onPressed: () {
                        textEditor.setTextStyle(items[index]);
                      },
                      icon: Text(
                        'Aa',
                        style: items[index].copyWith(
                          color: isSelected ? Colors.black : Colors.white,
                        ),
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor:
                            isSelected ? Colors.white : Colors.black38,
                        foregroundColor:
                            isSelected ? Colors.black : Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomBarCropEditor(
      CropRotateEditorState cropRotateEditor, BoxConstraints constraints) {
    return Scrollbar(
      controller: _cropBottomBarScrollCtrl,
      scrollbarOrientation: ScrollbarOrientation.top,
      thickness: isDesktop ? null : 0,
      child: BottomAppBar(
        height: kBottomNavigationBarHeight,
        color: Colors.black,
        padding: EdgeInsets.zero,
        child: Center(
          child: SingleChildScrollView(
            controller: _cropBottomBarScrollCtrl,
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: min(MediaQuery.sizeOf(context).width, 500),
                maxWidth: 500,
              ),
              child: Builder(builder: (context) {
                Color foregroundColor = Colors.white;
                return Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.spaceAround,
                  children: <Widget>[
                    FlatIconTextButton(
                      key: const ValueKey('crop-rotate-editor-rotate-btn'),
                      label: Text(
                        'Rotate',
                        style:
                            TextStyle(fontSize: 10.0, color: foregroundColor),
                      ),
                      icon: Icon(Icons.rotate_90_degrees_ccw_outlined,
                          color: foregroundColor),
                      onPressed: cropRotateEditor.rotate,
                    ),
                    FlatIconTextButton(
                      key: const ValueKey('crop-rotate-editor-flip-btn'),
                      label: Text(
                        'Flip',
                        style:
                            TextStyle(fontSize: 10.0, color: foregroundColor),
                      ),
                      icon: Icon(Icons.flip, color: foregroundColor),
                      onPressed: cropRotateEditor.flip,
                    ),
                    FlatIconTextButton(
                      key: const ValueKey('crop-rotate-editor-ratio-btn'),
                      label: Text(
                        'Ratio',
                        style:
                            TextStyle(fontSize: 10.0, color: foregroundColor),
                      ),
                      icon: Icon(Icons.crop, color: foregroundColor),
                      onPressed: cropRotateEditor.openAspectRatioOptions,
                    ),
                    FlatIconTextButton(
                      key: const ValueKey('crop-rotate-editor-reset-btn'),
                      label: Text(
                        'Reset',
                        style:
                            TextStyle(fontSize: 10.0, color: foregroundColor),
                      ),
                      icon: Icon(Icons.restore, color: foregroundColor),
                      onPressed: cropRotateEditor.reset,
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
