import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:magic_epaper_app/draw_canvas/models/overlay_item.dart';

class DraggableResizableImage extends StatefulWidget {
  final Uint8List imageBytes;
  final OverlayItem overlayItem;
  final bool isCapturing;
  final VoidCallback onDelete;

  const DraggableResizableImage({
    super.key,
    required this.imageBytes,
    required this.overlayItem,
    required this.isCapturing,
    required this.onDelete,
  });

  @override
  State<DraggableResizableImage> createState() =>
      _DraggableResizableImageState();
}

class _DraggableResizableImageState extends State<DraggableResizableImage> {
  late Offset _position;
  late double _scale;
  late double _rotation;
  double _previousScale = 1.0;

  double _previousRotation = 0.0;

  Offset _initialFocalPoint = Offset.zero;
  Offset _dragOffset = Offset.zero;

  bool _locked = false;

  @override
  void initState() {
    super.initState();
    _position = widget.overlayItem.position;
    _scale = widget.overlayItem.scale;
    _rotation = widget.overlayItem.rotation;
  }

  void _updateStateFromGesture() {
    widget.overlayItem.position = _position;
    widget.overlayItem.scale = _scale;
    widget.overlayItem.rotation = _rotation;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          GestureDetector(
            onLongPress: () {
              if (!widget.isCapturing) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text("Delete?"),
                    content: Text("Do you want to delete this overlay?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onDelete();
                        },
                        child:
                            Text("Delete", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              }
            },
            onScaleStart: _locked
                ? null
                : (details) {
                    _previousScale = _scale;
                    _previousRotation = _rotation;
                    _initialFocalPoint = details.focalPoint;
                    _dragOffset = _position;
                  },
            onScaleUpdate: _locked
                ? null
                : (details) {
                    setState(() {
                      final delta = details.focalPoint - _initialFocalPoint;
                      _position = _dragOffset + delta;
                      _scale = _previousScale * details.scale;
                      _rotation = _previousRotation + details.rotation;
                      _updateStateFromGesture();
                    });
                  },
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateZ(_rotation),
              child: Container(
                color: Colors.red,
                height: 100 * _scale,
                child: Image.memory(
                  widget.imageBytes,
                  height: 100 * _scale,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          if (!widget.isCapturing)
            GestureDetector(
              onTap: () {
                setState(() {
                  _locked = !_locked;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _locked ? Icons.lock : Icons.lock_open,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
