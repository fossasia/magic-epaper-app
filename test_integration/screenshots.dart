import 'dart:io';
import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magicepaperapp/main.dart' as app;

import 'utils.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    WidgetsApp.debugAllowBannerOverride = false;
    if (Platform.isAndroid) {
      await binding.convertFlutterSurfaceToImage();
    }
  });

   group('Magic ePaper App - Screenshots', () {
    testWidgets('Capture Screenshots', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));
      await binding.takeScreenshot('1_display_selection');

      await tester.pump(const Duration(seconds: 5));

      final waveshare = find.text('Waveshare NFC');
      if (waveshare.evaluate().isNotEmpty) {
        print('Tapping on Waveshare NFC');
        await tester.tap(waveshare);
        await tester.pumpAndSettle();
      }
      await tester.pump(const Duration(seconds: 2));
       await binding.takeScreenshot('2_test_select');

      final Continue = find.text('Continue');
      if (waveshare.evaluate().isNotEmpty) {
        await tester.tap(Continue);
        await tester.pumpAndSettle();
      }
      await tester.pump(const Duration(seconds: 2));

      final imageEditorButton = find.text('Select a Filter');
      if (imageEditorButton.evaluate().isNotEmpty) {
        await tester.tap(imageEditorButton);
        await tester.pumpAndSettle();
      }
      await tester.pump(const Duration(seconds: 2));
      await binding.takeScreenshot('2_image_editor');

      

      final openEditorButton = find.text('Open Editor');
      await tester.tap(openEditorButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));
      await binding.takeScreenshot('3_open_editor');

      final prefixIcon = find.byIcon(Icons.close); 
      await tester.tap(prefixIcon);
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      final findOk = find.text('OK');
      await tester.pump(const Duration(seconds: 2));
      await tester.tap(findOk);
      await tester.pump(const Duration(seconds: 5));

      final adjustButton = find.text('Adjust');
      await tester.tap(adjustButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));
      await binding.takeScreenshot('4_adjust_image');

      await tester.pageBack();
      await tester.pumpAndSettle();

      final barcodeButton = find.text('Barcode');
      await tester.tap(barcodeButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));

      final inputField = find.byType(TextField);
      await tester.tap(inputField);
      await tester.pumpAndSettle();
      await tester.enterText(inputField, 'fossasia');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));

      await binding.takeScreenshot('5_barcode_screen');
    });
  });
}