import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:magicepaperapp/card_templates/employee_id_form.dart';
import 'package:magicepaperapp/card_templates/price_tag_form.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/color_palette_provider.dart';

class _RouteRecorder extends NavigatorObserver {
  final List<Route<dynamic>> pushed = <Route<dynamic>>[];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushed.add(route);
  }
}

Future<void> _expectNoCrashWhenDisposedDuringEdit(
  WidgetTester tester, {
  required Widget form,
  required String generateLabel,
}) async {
  tester.view.physicalSize = const Size(1080, 3200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final recorder = _RouteRecorder();

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorObservers: <NavigatorObserver>[recorder],
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => form),
              ),
              child: const Text('open form'),
            ),
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.text('open form'));
  await tester.pumpAndSettle();

  final formRoute = recorder.pushed.last;

  final generateButton = find.text(generateLabel);
  await tester.ensureVisible(generateButton);
  await tester.pumpAndSettle();
  await tester.tap(generateButton);
  await tester.pumpAndSettle();

  final editorRoute = recorder.pushed.last;
  expect(editorRoute, isNot(same(formRoute)));

  final navigator = tester.state<NavigatorState>(find.byType(Navigator));
  navigator.removeRoute(formRoute);
  await tester.pumpAndSettle();

  navigator.pop();
  await tester.pumpAndSettle();

  expect(tester.takeException(), isNull);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppLocalizations l10n;

  setUp(() async {
    l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final getIt = GetIt.instance;
    if (getIt.isRegistered<AppLocalizations>()) {
      getIt.unregister<AppLocalizations>();
    }
    getIt.registerSingleton<AppLocalizations>(l10n);
    if (!getIt.isRegistered<ColorPaletteProvider>()) {
      getIt.registerLazySingleton<ColorPaletteProvider>(
          () => ColorPaletteProvider());
    }
  });

  tearDown(() async {
    await GetIt.instance.reset();
  });

  group('card template forms survive disposal while the editor is open', () {
    testWidgets('EmployeeIdForm', (tester) async {
      await _expectNoCrashWhenDisposedDuringEdit(
        tester,
        form: const EmployeeIdForm(width: 296, height: 128),
        generateLabel: l10n.generateIdCard,
      );
    });

    testWidgets('PriceTagForm', (tester) async {
      await _expectNoCrashWhenDisposedDuringEdit(
        tester,
        form: const PriceTagForm(width: 296, height: 128),
        generateLabel: l10n.generatePriceTag,
      );
    });
  });
}
