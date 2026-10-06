import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:image/image.dart' as img;
import 'package:magicepaperapp/card_templates/contact_card_form.dart';
import 'package:magicepaperapp/card_templates/employee_id_form.dart';
import 'package:magicepaperapp/card_templates/entry_pass_tag_form.dart';
import 'package:magicepaperapp/card_templates/event_badge_form.dart';
import 'package:magicepaperapp/card_templates/price_tag_form.dart';
import 'package:magicepaperapp/card_templates/utils/image_picker_util.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/native_canvas/native_canvas_editor.dart';
import 'package:magicepaperapp/provider/color_palette_provider.dart';
import 'package:magicepaperapp/view/image_crop_screen.dart';

class _RouteRecorder extends NavigatorObserver {
  final List<Route<dynamic>> pushed = <Route<dynamic>>[];
  Completer<Route<dynamic>>? _nextPush;

  Future<Route<dynamic>> watchNextPush() {
    _nextPush = Completer<Route<dynamic>>();
    return _nextPush!.future;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushed.add(route);
    _nextPush?.complete(route);
    _nextPush = null;
  }
}

class _PartialWriteFile extends Fake implements File {
  final File backingFile;
  final Object failure;

  _PartialWriteFile(this.backingFile, this.failure);

  @override
  String get path => backingFile.path;

  @override
  Future<File> writeAsBytes(
    List<int> bytes, {
    FileMode mode = FileMode.write,
    bool flush = false,
  }) async {
    await backingFile.writeAsBytes(bytes.take(1).toList());
    throw failure;
  }

  @override
  Future<bool> exists() => backingFile.exists();

  @override
  Future<FileSystemEntity> delete({bool recursive = false}) =>
      backingFile.delete(recursive: recursive);
}

Future<void> _expectLateCropDeleted(
  WidgetTester tester, {
  required Widget form,
  required String photoLabel,
  required String generateLabel,
  required AppLocalizations l10n,
  required Uint8List croppedBytes,
  required Directory temporaryDirectory,
  required Completer<void> temporaryDirectoryRequested,
  required Completer<String> temporaryDirectoryResult,
}) async {
  tester.view.physicalSize = const Size(1080, 3200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final recorder = _RouteRecorder();

  await tester.pumpWidget(MaterialApp(
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
  ));
  await tester.tap(find.text('open form'));
  await tester.pumpAndSettle();
  final formRoute = recorder.pushed.last;
  final navigator = tester.state<NavigatorState>(find.byType(Navigator));

  // The first two fields satisfy Event Badge and Entry Pass validation.
  await tester.enterText(find.byType(TextFormField).at(0), 'Example');
  if (form is! ContactCardForm) {
    await tester.enterText(find.byType(TextFormField).at(1), 'Person');
  }
  await tester.pump();

  final photoLabelFinder = find.text(photoLabel);
  await tester.ensureVisible(photoLabelFinder);
  await tester.pumpAndSettle();
  final selector = tester.widget<InkWell>(find
      .ancestor(
        of: photoLabelFinder,
        matching: find.byType(InkWell),
      )
      .first);
  late Future<void> pendingSelection;
  await tester.runAsync(() async {
    // Retain the callback's future so file creation and cleanup can be awaited.
    pendingSelection =
        Function.apply(selector.onTap!, const <Object>[]) as Future<void>;
  });
  await tester.pumpAndSettle();

  await tester.runAsync(() async {
    final cropRoutePushed = recorder.watchNextPush();
    await tester.tap(find.text(l10n.gallery));
    await cropRoutePushed;
  });
  await tester.pumpAndSettle();
  expect(find.byType(ImageCropScreen), findsOneWidget);

  await tester.runAsync(() async {
    navigator.pop(croppedBytes);
    await temporaryDirectoryRequested.future;
  });
  await tester.pumpAndSettle();

  // The crop route has closed, but the form is still awaiting its crop file.
  final generateButton = find.text(generateLabel);
  await tester.ensureVisible(generateButton);
  await tester.pumpAndSettle();
  await tester.tap(generateButton);
  await tester.pumpAndSettle();
  expect(find.byType(NativeCanvasEditor), findsOneWidget);

  await tester.runAsync(() async {
    temporaryDirectoryResult.complete(temporaryDirectory.path);
    await pendingSelection;
  });

  // Removing the form while its editor is open must not orphan a late crop.
  navigator.removeRoute(formRoute);
  await tester.pumpAndSettle();
  navigator.pop();
  await tester.pumpAndSettle();
  final remainingFiles = await tester.runAsync(
    () => temporaryDirectory.list().toList(),
  );
  expect(remainingFiles, isEmpty);
  expect(tester.takeException(), isNull);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const imagePickerChannel = MethodChannel('plugins.flutter.io/image_picker');
  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  final imageBytes =
      Uint8List.fromList(img.encodePng(img.Image(width: 8, height: 8)));
  late Directory root;
  late Directory temporaryDirectory;
  late Completer<void> temporaryDirectoryRequested;
  late Completer<String> temporaryDirectoryResult;
  late AppLocalizations l10n;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('temp_image_lifecycle_');
    temporaryDirectory = await Directory('${root.path}/temporary').create();
    final sourceImage = File('${root.path}/source.png');
    await sourceImage.writeAsBytes(imageBytes);
    temporaryDirectoryRequested = Completer<void>();
    temporaryDirectoryResult = Completer<String>();
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(imagePickerChannel, (call) async {
      if (call.method == 'pickImage') return sourceImage.path;
      throw MissingPluginException();
    });
    messenger.setMockMethodCallHandler(pathProviderChannel, (call) async {
      if (call.method == 'getTemporaryDirectory') {
        temporaryDirectoryRequested.complete();
        return temporaryDirectoryResult.future;
      }
      throw MissingPluginException();
    });

    l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final getIt = GetIt.instance;
    getIt.registerSingleton<AppLocalizations>(l10n);
    getIt.registerLazySingleton<ColorPaletteProvider>(
        () => ColorPaletteProvider());
  });

  tearDown(() async {
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(imagePickerChannel, null);
    messenger.setMockMethodCallHandler(pathProviderChannel, null);
    await GetIt.instance.reset();
    await root.delete(recursive: true);
  });

  final forms = <String, Widget>{
    'Employee ID': const EmployeeIdForm(width: 296, height: 128),
    'Price Tag': const PriceTagForm(width: 296, height: 128),
    'Contact Card': const ContactCardForm(width: 296, height: 128),
    'Event Badge': const EventBadgeForm(width: 296, height: 128),
    'Entry Pass': const EntryPassTagForm(width: 296, height: 128),
  };

  for (final entry in forms.entries) {
    testWidgets('${entry.key} deletes a crop completed after Generate',
        (tester) async {
      final generateLabels = <String, String>{
        'Employee ID': l10n.generateIdCard,
        'Price Tag': l10n.generatePriceTag,
        'Contact Card': l10n.generateContactTag,
        'Event Badge': l10n.generateBadge,
        'Entry Pass': l10n.generatePass,
      };
      await _expectLateCropDeleted(
        tester,
        form: entry.value,
        photoLabel: entry.key == 'Price Tag'
            ? l10n.selectProductImage
            : l10n.selectProfilePhoto,
        generateLabel: generateLabels[entry.key]!,
        l10n: l10n,
        croppedBytes: imageBytes,
        temporaryDirectory: temporaryDirectory,
        temporaryDirectoryRequested: temporaryDirectoryRequested,
        temporaryDirectoryResult: temporaryDirectoryResult,
      );
    });
  }

  test('successful crop writes retain all bytes', () async {
    final image = File('${temporaryDirectory.path}/mep_crop_123.png');
    final written = await writeTemporaryImage(image, imageBytes);
    expect(written.path, image.path);
    expect(await image.readAsBytes(), imageBytes);
  });

  test('failed crop writes delete the partial file and preserve the error',
      () async {
    final image = File('${temporaryDirectory.path}/mep_crop_456.png');
    final failure = FileSystemException('Simulated full disk', image.path);
    await expectLater(
      writeTemporaryImage(_PartialWriteFile(image, failure), imageBytes),
      throwsA(same(failure)),
    );
    expect(await image.exists(), isFalse);
  });
}
