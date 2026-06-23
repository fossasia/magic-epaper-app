import 'package:flutter/material.dart';

/// The kind of content a [LayerSpec] represents.
///
/// This drives in-editor editability: the editor uses the kind (carried over
/// to the underlying editor layer via its `meta`) to decide what happens when
/// the user taps a layer to edit it (re-pick an image, re-open the barcode
/// editor, etc.). See `MovableBackgroundImageExample`.
enum LayerKind {
  /// Plain text. Already editable via the built-in text editor.
  text,

  /// A picked image (e.g. a profile photo or product photo).
  image,

  /// A barcode/QR code rendered from string data.
  barcode,

  /// Any other widget with no special edit behaviour.
  generic,
}

/// Metadata keys used on an editor layer's `meta` map so the editor can
/// recognise template elements and edit them in place.
class LayerMetaKeys {
  /// The [LayerKind] name (see [LayerKind.name]).
  static const String kind = 'mep_kind';

  /// A stable identifier for the template element (e.g. `profileImage`, `qr`).
  static const String elementId = 'mep_element_id';
}

/// Data class for specifying a layer and its properties for layer addition.
class LayerSpec {
  final Widget? widget;
  final String? text;
  final TextStyle? textStyle;
  final Color? textColor;
  final Color? backgroundColor;
  final TextAlign? textAlign;
  final Offset offset;
  final double scale;
  final double rotation;
  final bool followCanvasTheme;

  /// What this layer represents, used to drive in-editor editing.
  final LayerKind kind;

  /// Stable id of the template element this layer was generated from.
  final String? elementId;

  const LayerSpec({
    this.widget,
    this.text,
    this.textStyle,
    this.textColor,
    this.backgroundColor,
    this.textAlign,
    this.offset = Offset.zero,
    this.scale = 1.0,
    this.rotation = 0.0,
    this.followCanvasTheme = false,
    this.kind = LayerKind.generic,
    this.elementId,
  });

  /// Constructor for text layers
  const LayerSpec.text({
    required this.text,
    this.textStyle,
    this.textColor,
    this.backgroundColor,
    this.textAlign = TextAlign.left,
    this.offset = Offset.zero,
    this.scale = 1.0,
    this.rotation = 0.0,
    this.followCanvasTheme = true,
    this.elementId,
  })  : widget = null,
        kind = LayerKind.text;

  /// Constructor for widget layers
  const LayerSpec.widget({
    required this.widget,
    this.offset = Offset.zero,
    this.scale = 1.0,
    this.rotation = 0.0,
    this.kind = LayerKind.generic,
    this.elementId,
  })  : text = null,
        textStyle = null,
        textColor = null,
        backgroundColor = null,
        textAlign = null,
        followCanvasTheme = false;

  /// Builds the `meta` map attached to the editor layer so the editor can
  /// recognise and re-edit this element. Returns `null` when there is nothing
  /// useful to tag (a plain generic widget).
  Map<String, dynamic>? toLayerMeta() {
    if (kind == LayerKind.generic && elementId == null) {
      return null;
    }
    return {
      LayerMetaKeys.kind: kind.name,
      if (elementId != null) LayerMetaKeys.elementId: elementId,
    };
  }
}
