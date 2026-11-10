import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:magicepaperapp/card_templates/utils/image_picker_util.dart';

void main() {
  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('mep_image_util_test_');
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  test('deleteTempImage removes an existing file', () async {
    final file = File('${tempDir.path}/mep_crop_1.png')..writeAsBytesSync([1]);

    await deleteTempImage(file);

    expect(file.existsSync(), isFalse);
  });

  test('deleteTempImage ignores a missing file', () async {
    final file = File('${tempDir.path}/missing.png');

    await expectLater(deleteTempImage(file), completes);
  });

  test('deleteTempImage ignores null', () async {
    await expectLater(deleteTempImage(null), completes);
  });
}
