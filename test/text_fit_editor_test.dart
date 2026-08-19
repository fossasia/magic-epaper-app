import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/color_palette_provider.dart';
import 'package:magicepaperapp/view/text_fit_editor.dart';

void main() {
  setUp(() {
    final getIt = GetIt.instance;
    if (getIt.isRegistered<ColorPaletteProvider>()) {
      getIt.unregister<ColorPaletteProvider>();
    }
    final palette = ColorPaletteProvider()
      ..updateColors(const [Colors.white, Colors.black]);
    getIt.registerSingleton<ColorPaletteProvider>(palette);
  });

  tearDown(() async {
    await GetIt.instance.reset();
  });

  Widget wrap(Locale locale) => MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const TextFitEditor(width: 200, height: 100),
      );

  testWidgets('AppBar title uses the English localization', (tester) async {
    await tester.pumpWidget(wrap(const Locale('en')));
    await tester.pumpAndSettle();

    expect(find.text('Text Editor'), findsOneWidget);
  });

  testWidgets('AppBar title uses the Hindi localization', (tester) async {
    await tester.pumpWidget(wrap(const Locale('hi')));
    await tester.pumpAndSettle();

    expect(find.text('टेक्स्ट एडिटर'), findsOneWidget);
    expect(find.text('Text Editor'), findsNothing);
  });

  testWidgets('confirming with empty text shows validation errors',
      (tester) async {
    await tester.pumpWidget(wrap(const Locale('en')));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();

    expect(find.text('Text cannot be empty'), findsOneWidget);
    expect(find.text('Please enter some text before saving'), findsOneWidget);
    expect(find.byType(TextFitEditor), findsOneWidget);
  });

  testWidgets('confirming with whitespace-only text is rejected',
      (tester) async {
    await tester.pumpWidget(wrap(const Locale('en')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '   ');
    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();

    expect(find.text('Text cannot be empty'), findsOneWidget);
  });

  testWidgets('typing valid text clears the validation error', (tester) async {
    await tester.pumpWidget(wrap(const Locale('en')));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.check));
    await tester.pumpAndSettle();
    expect(find.text('Text cannot be empty'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Hello');
    await tester.pumpAndSettle();
    expect(find.text('Text cannot be empty'), findsNothing);
  });
}
