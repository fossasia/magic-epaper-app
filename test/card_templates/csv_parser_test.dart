import 'package:flutter_test/flutter_test.dart';
import 'package:magicepaperapp/card_templates/bulk/csv_parser.dart';

void main() {
  group('parseCsv', () {
    test('parses a simple header + rows', () {
      final rows = parseCsv('name,role\nAlice,Speaker\nBob,Guest');
      expect(rows, [
        ['name', 'role'],
        ['Alice', 'Speaker'],
        ['Bob', 'Guest'],
      ]);
    });

    test('handles quoted fields with commas', () {
      final rows = parseCsv('name,note\n"Doe, Jane","Hello, world"');
      expect(rows[1], ['Doe, Jane', 'Hello, world']);
    });

    test('handles escaped double quotes', () {
      final rows = parseCsv('value\n"She said ""hi"""');
      expect(rows[1], ['She said "hi"']);
    });

    test('handles newlines inside quoted fields', () {
      final rows = parseCsv('a,b\n"line1\nline2",x');
      expect(rows[1], ['line1\nline2', 'x']);
    });

    test('handles CRLF line endings', () {
      final rows = parseCsv('a,b\r\n1,2\r\n');
      expect(rows, [
        ['a', 'b'],
        ['1', '2'],
      ]);
    });

    test('drops trailing empty line', () {
      final rows = parseCsv('a,b\n1,2\n');
      expect(rows.length, 2);
    });

    test('keeps empty fields', () {
      final rows = parseCsv('a,b,c\n1,,3');
      expect(rows[1], ['1', '', '3']);
    });
  });
}
