import 'package:flutter_test/flutter_test.dart';
import 'package:magicepaperapp/card_templates/json/template_definition.dart';
import 'package:magicepaperapp/card_templates/json/template_repository.dart';
import 'package:magicepaperapp/util/template_util.dart';

void main() {
  const repository = TemplateRepository();

  const sampleJson = '''
  {
    "version": 1,
    "id": "employee_id",
    "title": "Employee ID Card",
    "description": "Professional employee identification card",
    "icon": "badge_outlined",
    "color": "blue",
    "elements": [
      {
        "id": "profileImage",
        "type": "image",
        "label": "Profile Photo",
        "props": { "width": 200, "height": 200, "radius": 8.0 }
      },
      {
        "id": "companyName",
        "type": "text",
        "label": "Company Name",
        "props": { "bold": true, "align": "center" }
      },
      {
        "id": "qr",
        "type": "barcode",
        "label": "QR Code Data",
        "props": { "barcodeName": "QR-Code" }
      }
    ]
  }
  ''';

  group('TemplateDefinition parsing', () {
    test('parses a well-formed template', () {
      final template = repository.parse(sampleJson);

      expect(template.id, 'employee_id');
      expect(template.title, 'Employee ID Card');
      expect(template.version, 1);
      expect(template.elements, hasLength(3));
    });

    test('maps element types to layer kinds', () {
      final template = repository.parse(sampleJson);

      expect(template.elementById('profileImage')?.type,
          TemplateElementType.image);
      expect(template.elementById('profileImage')?.type.layerKind,
          LayerKind.image);
      expect(template.elementById('qr')?.type.layerKind, LayerKind.barcode);
      expect(
          template.elementById('companyName')?.type.layerKind, LayerKind.text);
    });

    test('exposes type-specific props', () {
      final template = repository.parse(sampleJson);

      expect(template.elementById('profileImage')?.props['width'], 200);
      expect(template.elementById('qr')?.props['barcodeName'], 'QR-Code');
    });

    test('elementById returns null for unknown ids', () {
      final template = repository.parse(sampleJson);
      expect(template.elementById('does_not_exist'), isNull);
    });

    test('round-trips through toJson/fromJson', () {
      final template = repository.parse(sampleJson);
      final restored = TemplateDefinition.fromJson(template.toJson());

      expect(restored.id, template.id);
      expect(restored.elements.length, template.elements.length);
      expect(restored.elementById('qr')?.props['barcodeName'], 'QR-Code');
    });
  });

  group('TemplateDefinition validation', () {
    test('throws when "elements" is missing', () {
      expect(
        () => repository.parse('{"id": "x", "title": "X"}'),
        throwsFormatException,
      );
    });

    test('throws on an unknown element type', () {
      const badJson = '''
      { "id": "x", "elements": [ { "id": "a", "type": "video" } ] }
      ''';
      expect(() => repository.parse(badJson), throwsFormatException);
    });

    test('throws when the top-level JSON is not an object', () {
      expect(() => repository.parse('[]'), throwsFormatException);
    });
  });
}
