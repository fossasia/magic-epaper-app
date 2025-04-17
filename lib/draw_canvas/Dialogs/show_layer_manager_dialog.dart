import 'package:flutter/material.dart';
import 'package:magic_epaper_app/draw_canvas/models/overlay_item.dart';

Widget buildLayerManagerDialog({
  required List<OverlayItem> items,
  required void Function(int oldIndex, int newIndex) onReorder,
  required void Function(void Function()) setModalState,
}) {
  return ReorderableListView(
    onReorder: (oldIndex, newIndex) {
      onReorder(oldIndex, newIndex);
      setModalState(() {});
    },
    children: [
      for (int i = 0; i < items.length; i++)
        ListTile(
          key: ValueKey(items[i].id),
          title: Text(
            items[i].type == 'text'
                ? items[i].text ?? 'Text Layer'
                : items[i].label ?? 'Image Layer',
          ),
          leading: Icon(
            items[i].type == 'text' ? Icons.text_fields : Icons.image,
          ),
          trailing: const Icon(Icons.drag_handle),
        ),
    ],
  );
}
