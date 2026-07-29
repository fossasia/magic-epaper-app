List<List<String>> parseCsv(String input) {
  if (input.startsWith('﻿')) {
    input = input.substring(1);
  }
  final rows = <List<String>>[];
  var field = StringBuffer();
  var row = <String>[];
  var inQuotes = false;
  var fieldStarted = false;

  void endField() {
    row.add(field.toString());
    field = StringBuffer();
    fieldStarted = false;
  }

  void endRow() {
    endField();
    rows.add(row);
    row = <String>[];
  }

  for (var i = 0; i < input.length; i++) {
    final char = input[i];
    if (inQuotes) {
      if (char == '"') {
        if (i + 1 < input.length && input[i + 1] == '"') {
          field.write('"');
          i++;
        } else {
          inQuotes = false;
        }
      } else {
        field.write(char);
      }
      continue;
    }

    switch (char) {
      case '"':
        inQuotes = true;
        fieldStarted = true;
        break;
      case ',':
        endField();
        break;
      case '\r':
        if (i + 1 < input.length && input[i + 1] == '\n') {
          i++;
        }
        endRow();
        break;
      case '\n':
        endRow();
        break;
      default:
        field.write(char);
        fieldStarted = true;
    }
  }

  if (fieldStarted || field.isNotEmpty || row.isNotEmpty) {
    endRow();
  }

  rows.removeWhere((r) => r.length == 1 && r.first.trim().isEmpty);
  return rows;
}
