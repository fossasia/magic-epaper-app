import 'package:flutter_test/flutter_test.dart';
import 'package:magicepaperapp/card_templates/bulk/dynamic_columns.dart';

void main() {
  group('detectColumnRoles', () {
    test('first text column becomes the title', () {
      final cols = detectColumnRoles(
        ['Name', 'Role', 'Team'],
        [
          ['Rahul Sharma', 'Engineer', 'Platform'],
        ],
      );
      expect(cols[0].role, ColumnRole.title);
      expect(cols[1].role, ColumnRole.detail);
      expect(cols[2].role, ColumnRole.detail);
    });

    test('image-looking values and photo headers map to photo', () {
      final cols = detectColumnRoles(
        ['Name', 'Avatar'],
        [
          ['Priya', 'https://cdn.example.com/p/priya.jpg'],
        ],
      );
      expect(cols[1].role, ColumnRole.photo);
    });

    test('url values map to qr', () {
      final cols = detectColumnRoles(
        ['Name', 'Profile'],
        [
          ['Arjun', 'https://example.com/arjun'],
        ],
      );
      expect(cols[1].role, ColumnRole.qr);
    });

    test('only one column of each special role is assigned', () {
      final cols = detectColumnRoles(
        ['Name', 'Photo', 'Headshot', 'Link', 'Site'],
        [
          [
            'Meera',
            'a.jpg',
            'b.png',
            'https://x.com/1',
            'https://x.com/2',
          ],
        ],
      );
      expect(cols.where((c) => c.role == ColumnRole.photo).length, 1);
      expect(cols.where((c) => c.role == ColumnRole.qr).length, 1);
    });

    test('column keys are slugified and unique-ish', () {
      final cols = detectColumnRoles(['Full Name', 'Ticket #'], [
        ['A', 'T-1'],
      ]);
      expect(cols[0].key, 'full_name');
      expect(cols[1].key, 'ticket');
    });
  });

  group('dynamicBulkTemplate', () {
    test('derives fields from headers and marks title required', () {
      final t = dynamicBulkTemplate(
        ['Name', 'Role', 'Photo'],
        [
          ['Rahul', 'Speaker', 'r.jpg'],
        ],
      );
      expect(t.fields.length, 3);
      expect(t.hasPhoto, isTrue);
      expect(t.nameField.label, 'Name');
      final layers = t.buildLayers({'name': 'Rahul', 'role': 'Speaker'}, null,
          296, 128);
      expect(layers, isNotEmpty);
    });
  });
}
