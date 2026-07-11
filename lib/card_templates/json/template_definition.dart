import 'package:magicepaperapp/util/template_util.dart';

/// The type of a template element. Mirrors [LayerKind] but is the
/// serialisable, JSON-facing representation of a card-template field.
enum TemplateElementType {
  text,
  image,
  barcode;

  static TemplateElementType fromName(String name) {
    return TemplateElementType.values.firstWhere(
      (e) => e.name == name,
      orElse: () => throw FormatException('Unknown element type: $name'),
    );
  }

  /// Maps the element type to the [LayerKind] used by the editor.
  LayerKind get layerKind {
    switch (this) {
      case TemplateElementType.text:
        return LayerKind.text;
      case TemplateElementType.image:
        return LayerKind.image;
      case TemplateElementType.barcode:
        return LayerKind.barcode;
    }
  }
}

/// A single editable field in a card template (a text line, a photo slot,
/// or a barcode/QR slot).
///
/// Layout (offset/scale per display size) is intentionally NOT stored here —
/// it is resolved at render time from `ResponsiveLayoutUtil` keyed by [id], so
/// a single JSON template renders correctly across every supported ePaper
/// display size. [props] holds the type-specific, layout-independent options
/// (font size, prefix, barcode format, image box size, …).
class TemplateElementDefinition {
  /// Stable identifier, also used as the layout key and the editor element id.
  final String id;

  /// What kind of content this element holds.
  final TemplateElementType type;

  /// Human-readable label, shown in forms / editor hints.
  final String label;

  /// Type-specific options. See the schema doc (`docs/card-templates-json.md`).
  final Map<String, dynamic> props;

  const TemplateElementDefinition({
    required this.id,
    required this.type,
    required this.label,
    this.props = const {},
  });

  factory TemplateElementDefinition.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final type = json['type'];
    if (id is! String || id.isEmpty) {
      throw const FormatException('Element is missing a non-empty "id"');
    }
    if (type is! String) {
      throw FormatException('Element "$id" is missing "type"');
    }
    return TemplateElementDefinition(
      id: id,
      type: TemplateElementType.fromName(type),
      label: (json['label'] as String?) ?? id,
      props: Map<String, dynamic>.from(
        (json['props'] as Map?)?.cast<String, dynamic>() ?? const {},
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'label': label,
        if (props.isNotEmpty) 'props': props,
      };
}

/// A complete card template described declaratively, decoupled from the Dart
/// widgets that render it. Loaded from JSON (bundled assets or a user's
/// documents directory) by `TemplateRepository`.
class TemplateDefinition {
  /// Stable identifier (e.g. `employee_id`). Matches the asset file name.
  final String id;

  /// Display title shown on the template selection grid.
  final String title;

  /// Short description shown under the title.
  final String description;

  /// Material icon name for the selection card (e.g. `badge_outlined`).
  final String icon;

  /// Accent colour name for the selection card (e.g. `blue`).
  final String color;

  /// Schema version, so the loader can migrate older files in the future.
  final int version;

  /// The ordered list of editable elements that make up the card.
  final List<TemplateElementDefinition> elements;

  const TemplateDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.elements,
    this.version = 1,
  });

  factory TemplateDefinition.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id is! String || id.isEmpty) {
      throw const FormatException('Template is missing a non-empty "id"');
    }
    final rawElements = json['elements'];
    if (rawElements is! List) {
      throw FormatException('Template "$id" is missing an "elements" list');
    }
    return TemplateDefinition(
      id: id,
      title: (json['title'] as String?) ?? id,
      description: (json['description'] as String?) ?? '',
      icon: (json['icon'] as String?) ?? 'description_outlined',
      color: (json['color'] as String?) ?? 'blue',
      version: (json['version'] as num?)?.toInt() ?? 1,
      elements: rawElements
          .map((e) => TemplateElementDefinition.fromJson(
                Map<String, dynamic>.from(e as Map),
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'version': version,
        'id': id,
        'title': title,
        'description': description,
        'icon': icon,
        'color': color,
        'elements': elements.map((e) => e.toJson()).toList(),
      };

  /// Returns the element with the given [id], or `null` if absent.
  TemplateElementDefinition? elementById(String id) {
    for (final element in elements) {
      if (element.id == id) return element;
    }
    return null;
  }
}
