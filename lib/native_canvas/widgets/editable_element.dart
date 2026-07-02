import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/canvas_controller.dart';
import '../model/canvas_element.dart';

class EditableElement extends StatefulWidget {
  const EditableElement({
    super.key,
    required this.element,
    required this.displayScale,
    required this.selected,
    required this.controller,
    required this.canvasKey,
    this.onRequestEdit,
    this.onCrop,
  });

  final CanvasElement element;
  final double displayScale;
  final bool selected;
  final CanvasController controller;
  final GlobalKey canvasKey;
  final VoidCallback? onRequestEdit;
  final VoidCallback? onCrop;

  @override
  State<EditableElement> createState() => _EditableElementState();
}

class _EditableElementState extends State<EditableElement> {
  Offset _gestureStartPos = Offset.zero;
  Offset _gestureStartFocalLocal = Offset.zero;
  double _gestureStartScale = 1.0;
  double _gestureStartRotation = 0.0;

  Offset _centerGlobal = Offset.zero;
  Offset _startVector = Offset.zero;
  double _startScale = 1.0;
  double _startRotation = 0.0;

  static const double _minScale = 0.15;
  static const double _maxScale = 25.0;
  static const double _pad = 28;
  static const double _hit = 44;

  RenderBox? get _canvasBox =>
      widget.canvasKey.currentContext?.findRenderObject() as RenderBox?;

  double get _ds => widget.displayScale;

  void _onScaleStart(ScaleStartDetails d) {
    widget.controller.select(widget.element.id);
    widget.controller.bringToFront(widget.element.id);
    widget.controller.beginChange();
    final el = widget.element;
    _gestureStartPos = el.position;
    _gestureStartScale = el.scale;
    _gestureStartRotation = el.rotation;
    final box = _canvasBox;
    if (box != null) {
      _gestureStartFocalLocal = box.globalToLocal(d.focalPoint);
    }
  }

  void _onScaleUpdate(ScaleUpdateDetails d) {
    final box = _canvasBox;
    if (box == null) return;
    final focalLocal = box.globalToLocal(d.focalPoint);
    final deltaLogical = (focalLocal - _gestureStartFocalLocal) / _ds;
    final newScale =
        (_gestureStartScale * d.scale).clamp(_minScale, _maxScale);
    final newRotation = _gestureStartRotation + d.rotation;
    widget.controller.updateElement(
      widget.element.copyWith(
        position: _gestureStartPos + deltaLogical,
        scale: newScale,
        rotation: newRotation,
      ),
    );
  }

  void _onTransformStart(DragStartDetails d) {
    widget.controller.beginChange();
    final el = widget.element;
    final box = _canvasBox;
    if (box == null) return;
    _centerGlobal = box.localToGlobal(
      Offset(el.position.dx * _ds, el.position.dy * _ds),
    );
    _startVector = d.globalPosition - _centerGlobal;
    _startScale = el.scale;
    _startRotation = el.rotation;
  }

  void _onTransformUpdate(DragUpdateDetails d) {
    if (_startVector.distance == 0) return;
    final vector = d.globalPosition - _centerGlobal;
    final newScale =
        (_startScale * vector.distance / _startVector.distance).clamp(_minScale, _maxScale);
    final newRotation =
        _startRotation + (vector.direction - _startVector.direction);
    widget.controller.updateElement(
      widget.element.copyWith(scale: newScale, rotation: newRotation),
    );
  }

  @override
  Widget build(BuildContext context) {
    final el = widget.element;
    final w = el.baseSize.width * _ds * el.scale;
    final h = el.baseSize.height * _ds * el.scale;
    final cx = el.position.dx * _ds;
    final cy = el.position.dy * _ds;
    final primary = Theme.of(context).colorScheme.primary;

    return Positioned(
      left: cx - w / 2 - _pad,
      top: cy - h / 2 - _pad,
      width: w + _pad * 2,
      height: h + _pad * 2,
      child: Transform.rotate(
        angle: el.rotation,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: _pad,
              top: _pad,
              width: w,
              height: h,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  widget.controller.select(el.id);
                  widget.onRequestEdit?.call();
                },
                onScaleStart: _onScaleStart,
                onScaleUpdate: _onScaleUpdate,
                child: Container(
                  decoration: widget.selected
                      ? BoxDecoration(
                          border: Border.all(color: primary, width: 1.5))
                      : null,
                  child: _ElementContent(element: el),
                ),
              ),
            ),
            if (widget.selected) ...[
              _buildHandle(
                centerX: _pad,
                centerY: _pad,
                icon: Icons.close,
                color: Colors.red,
                onTap: () => widget.controller.removeById(el.id),
              ),
              if (widget.onCrop != null)
                _buildHandle(
                  centerX: _pad + w,
                  centerY: _pad,
                  icon: Icons.crop,
                  color: primary,
                  onTap: widget.onCrop,
                ),
              _buildHandle(
                centerX: _pad + w,
                centerY: _pad + h,
                icon: Icons.open_in_full,
                color: primary,
                onPanStart: _onTransformStart,
                onPanUpdate: _onTransformUpdate,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHandle({
    required double centerX,
    required double centerY,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
    GestureDragStartCallback? onPanStart,
    GestureDragUpdateCallback? onPanUpdate,
  }) {
    return Positioned(
      left: centerX - _hit / 2,
      top: centerY - _hit / 2,
      width: _hit,
      height: _hit,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        onPanStart: onPanStart,
        onPanUpdate: onPanUpdate,
        child: Center(child: _Handle(icon: icon, background: color)),
      ),
    );
  }
}

class _ElementContent extends StatelessWidget {
  const _ElementContent({required this.element});

  final CanvasElement element;

  @override
  Widget build(BuildContext context) {
    switch (element.kind) {
      case CanvasElementKind.text:
        final baseStyle = TextStyle(
          fontSize: element.fontSize,
          fontWeight: element.fontWeight,
          color: element.color,
        );
        return FittedBox(
          fit: BoxFit.contain,
          child: Text(
            element.text ?? '',
            textAlign: element.textAlign,
            style: element.fontFamily == null
                ? baseStyle
                : GoogleFonts.getFont(element.fontFamily!, textStyle: baseStyle),
          ),
        );
      case CanvasElementKind.image:
        return element.imageBytes == null
            ? const SizedBox.shrink()
            : Image.memory(element.imageBytes!, fit: BoxFit.contain);
      case CanvasElementKind.barcode:
        return ColoredBox(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: BarcodeWidget(
              barcode: element.barcode ?? Barcode.qrCode(),
              data: element.barcodeData ?? '',
              color: Colors.black,
              backgroundColor: Colors.white,
              drawText: false,
              errorBuilder: (context, error) => const SizedBox.shrink(),
            ),
          ),
        );
      case CanvasElementKind.widget:
        return FittedBox(fit: BoxFit.contain, child: element.child ?? const SizedBox.shrink());
    }
  }
}

class _Handle extends StatelessWidget {
  const _Handle({required this.icon, required this.background});

  final IconData icon;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 2)],
      ),
      child: Icon(icon, size: 14, color: Colors.white),
    );
  }
}
