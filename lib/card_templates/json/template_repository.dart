import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:magicepaperapp/card_templates/json/template_definition.dart';

/// Loads [TemplateDefinition]s from JSON.
///
/// Built-in templates ship as read-only assets under `assets/card_templates/`.
/// User-created or user-edited templates are intended to live as JSON files in
/// the app documents directory (see `docs/card-templates-json.md`); that path
/// is a planned follow-up and is intentionally not wired up yet.
class TemplateRepository {
  /// Directory (under `assets/`) that holds the bundled template JSON files.
  static const String assetDir = 'assets/card_templates';

  /// The built-in templates shipped with the app, in display order.
  static const List<String> bundledTemplateIds = [
    'employee_id',
    'price_tag',
    'event_badge',
    'entry_pass_tag',
  ];

  const TemplateRepository();

  /// Parses a [TemplateDefinition] from a raw JSON string.
  ///
  /// Throws [FormatException] if the JSON is malformed or fails validation.
  TemplateDefinition parse(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Template JSON must be a JSON object');
    }
    return TemplateDefinition.fromJson(decoded);
  }

  /// Loads a template from a bundled asset path.
  Future<TemplateDefinition> loadFromAsset(String assetPath) async {
    final source = await rootBundle.loadString(assetPath);
    return parse(source);
  }

  /// Loads a built-in template by its [id] (e.g. `employee_id`).
  Future<TemplateDefinition> loadBundledById(String id) {
    return loadFromAsset('$assetDir/$id.json');
  }

  /// Loads every built-in template, preserving [bundledTemplateIds] order.
  Future<List<TemplateDefinition>> loadBundled() async {
    final results = <TemplateDefinition>[];
    for (final id in bundledTemplateIds) {
      results.add(await loadBundledById(id));
    }
    return results;
  }
}
