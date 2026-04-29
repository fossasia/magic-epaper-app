import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magicepaperapp/view/text_fit_editor.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/color_palette_provider.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';

void main() {
  setUp(() {
    if (!getIt.isRegistered<ColorPaletteProvider>()) {
      final provider = ColorPaletteProvider();
      // Ensure the provider has a default palette so .first doesn't fail
      provider.colors.addAll([Colors.black, Colors.white, Colors.red]);
      getIt.registerSingleton<ColorPaletteProvider>(provider);
    }
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('TextFitEditor AppBar title should be localized', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en')],
        home: TextFitEditor(width: 400, height: 300),
      ),
    );

    // Wait for the UI to settle
    await tester.pumpAndSettle();

    final BuildContext context = tester.element(find.byType(TextFitEditor));
    final AppLocalizations localizations = AppLocalizations.of(context)!;

    // Verify that the AppBar title matches the localized value
    expect(find.text(localizations.textEditorTitle), findsOneWidget);
    
    // Verify it is inside an AppBar
    expect(find.byType(AppBar), findsOneWidget);
  });
}
