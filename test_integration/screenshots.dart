import 'dart:io';
import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magicepaperapp/main.dart' as app;

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
      await binding.takeScreenshot('1_display_selection');

      final sideBar = find.byIcon(Icons.menu);
      if (sideBar.evaluate().isNotEmpty) {
        await tester.tap(sideBar);
        await tester.pumpAndSettle();
      }
      await binding.takeScreenshot('2_sidebar');

      final selectNdef = find.byIcon(Icons.nfc);
      if (sideBar.evaluate().isNotEmpty) {
        await tester.tap(selectNdef);
        await tester.pumpAndSettle();
      }

      await binding.takeScreenshot('3_ndef_screen');
      if (sideBar.evaluate().isNotEmpty) {
        await tester.tap(sideBar);
        await tester.pumpAndSettle();
      }
      final selectDisplay = find.byIcon(Icons.edit);
      if (sideBar.evaluate().isNotEmpty) {
        await tester.tap(selectDisplay);
        await tester.pumpAndSettle();
      }

      final waveshare = find.text('Waveshare NFC');
      if (waveshare.evaluate().isNotEmpty) {
        await tester.tap(waveshare);
        await tester.pumpAndSettle();
      }
      final continueButton = find.text('Continue');
      if (continueButton.evaluate().isNotEmpty) {
        await tester.tap(continueButton);
        await tester.pumpAndSettle();
      }
      await tester.pump(const Duration(seconds: 1));

      final imageEditorButton = find.text('Select a Filter');
      if (imageEditorButton.evaluate().isNotEmpty) {
        await tester.tap(imageEditorButton);
        await tester.pumpAndSettle();
      }
      await tester.pump(const Duration(seconds: 1));
      await binding.takeScreenshot('4_filter_selection');

      final openEditorButton = find.byKey(const Key('openEditorButton'));
      await tester.tap(openEditorButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));
      await binding.takeScreenshot('5_open_editor');

      final NavigatorState navigator = tester.state(find.byType(Navigator));
      navigator.pop();
      await tester.pumpAndSettle();

      final adjustButton = find.byKey(const Key('adjustButton'));
      await tester.tap(adjustButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));
      await binding.takeScreenshot('6_adjust_image');

      navigator.pop();
      await tester.pumpAndSettle();

      final barcodeButton = find.byKey(const Key('barcodeButton'));
      await tester.tap(barcodeButton);
      await tester.pumpAndSettle();

      final inputField = find.byType(TextField);
      await tester.tap(inputField);
      await tester.pumpAndSettle();
      await tester.enterText(inputField, 'fossasia');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await binding.takeScreenshot('7_barcode_screen');
      await tester.pumpAndSettle();
      final generateImage = find.text('Generate Image');
      await tester.tap(generateImage);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await binding.takeScreenshot('8_generated_Barcode');
    });
  });
}
