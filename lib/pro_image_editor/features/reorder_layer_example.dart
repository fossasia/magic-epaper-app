import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

/// A widget that provides a sheet for reordering layers.
///
/// The [ReorderLayerSheet] widget allows users to view and reorder a list of
/// layers within an application. It is typically used in scenarios where the
/// user needs to manage the stacking order of different layers, such as in
/// an image or graphic editor.
///
/// This widget requires a list of [Layer] objects and a [ReorderCallback]
/// function to handle the reorder logic.
///
/// The state for this widget is managed by the [_ReorderLayerSheetState] class.
///
/// Example usage:
/// ```dart
/// ReorderLayerSheet(
///   layers: myLayers,
///   onReorder: (oldIndex, newIndex) { /* reorder logic */ },
/// );
/// ```
class ReorderLayerSheet extends StatefulWidget {
  /// Creates a new [ReorderLayerSheet] widget.
  ///
  /// The [layers] parameter is required and represents the list of layers
  /// that can be reordered. The [onReorder] callback is required to handle
  /// the logic when layers are reordered.
  const ReorderLayerSheet({
    super.key,
    required this.layers,
    required this.onReorder,
  });

  /// A list of [Layer] objects that can be reordered by the user.
  final List<Layer> layers;

  /// A callback that is triggered when the user reorders the layers.
  /// This function receives the [oldIndex] and [newIndex] to indicate
  /// how the layers were reordered.
  final ReorderCallback onReorder;

  @override
  State<ReorderLayerSheet> createState() => _ReorderLayerSheetState();
}

/// The state for the [ReorderLayerSheet] widget.
///
/// This class manages the logic and state required for displaying and
/// interacting with the reorderable list of layers.
class _ReorderLayerSheetState extends State<ReorderLayerSheet> {
  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      header: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          'Reorder',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
      footer: const SizedBox(height: 30),
      dragStartBehavior: DragStartBehavior.down,
      itemBuilder: (context, index) {
        Layer layer = widget.layers[index];
        return ListTile(
          key: ValueKey(layer),
          tileColor: Theme.of(context).cardColor,
          title: layer.runtimeType == TextLayer
              ? Text(
                  (layer as TextLayer).text,
                  style: const TextStyle(fontSize: 20),
                )
              : layer.runtimeType == EmojiLayer
                  ? Text(
                      (layer as EmojiLayer).emoji,
                      style: const TextStyle(fontSize: 24),
                    )
                  : layer.runtimeType == PaintLayer
                      ? Builder(builder: (context) {
                          var paintLayer = layer as PaintLayer;
                          bool isCensorLayer =
                              paintLayer.item.mode == PaintMode.pixelate ||
                                  paintLayer.item.mode == PaintMode.blur;
                          return SizedBox(
                            height: 40,
                            child: FittedBox(
                              alignment: Alignment.centerLeft,
                              child: isCensorLayer
                                  ? const Icon(Icons.blur_circular)
                                  : CustomPaint(
                                      size: paintLayer.size,
                                      willChange: true,
                                      isComplex: layer.item.mode ==
                                          PaintMode.freeStyle,
                                      painter: DrawPaintItem(
                                        item: layer.item,
                                        scale: layer.scale,
                                        enabledHitDetection: false,
                                        freeStyleHighPerformance: false,
                                      ),
                                    ),
                            ),
                          );
                        })
                      : layer.runtimeType == WidgetLayer
                          ? SizedBox(
                              height: 40,
                              child: FittedBox(
                                alignment: Alignment.centerLeft,
                                child: (layer as WidgetLayer).widget,
                              ),
                            )
                          : Text(
                              layer.id.toString(),
                            ),
        );
      },
      itemCount: widget.layers.length,
      onReorder: widget.onReorder,
    );
  }
}
