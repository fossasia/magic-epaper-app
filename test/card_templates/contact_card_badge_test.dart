import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:magicepaperapp/card_templates/contact_card_badge.dart';
import 'package:magicepaperapp/card_templates/contact_card_model.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';

void main() {
  setUp(() async {
    final getIt = GetIt.instance;
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    if (getIt.isRegistered<AppLocalizations>()) {
      getIt.unregister<AppLocalizations>();
    }
    getIt.registerSingleton<AppLocalizations>(l10n);
  });

  tearDown(() async {
    await GetIt.instance.reset();
  });

  ContactCardModel model(ContactQrMode mode) => ContactCardModel(
        fullName: 'Jonathan Carter-Williamson',
        jobTitle: 'Senior Product Manager',
        company: 'ACME Corporation International',
        phone: '+1 (555) 010-2000',
        email: 'jonathan.carter@acme-corp.com',
        link: 'https://linkedin.com/in/jonathan-carter',
        qrMode: mode,
      );

  const sizes = <Size>[
    Size(416, 240),
    Size(320, 240),
    Size(250, 122),
    Size(296, 128),
    Size(264, 176),
    Size(400, 300),
    Size(800, 480),
    Size(880, 528),
  ];

  Future<void> pumpBadge(
      WidgetTester tester, Size size, ContactCardModel data) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: ContactCardBadge(data: data),
            ),
          ),
        ),
      ),
    );
  }

  for (final size in sizes) {
    testWidgets('renders without overflow at ${size.width}x${size.height}',
        (tester) async {
      await pumpBadge(tester, size, model(ContactQrMode.vCard));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('renders in link mode without overflow', (tester) async {
    await pumpBadge(tester, const Size(296, 128), model(ContactQrMode.link));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders with only a name filled in', (tester) async {
    final data = ContactCardModel(
      fullName: 'Ada Lovelace',
      jobTitle: '',
      company: '',
      phone: '',
      email: '',
      link: '',
      qrMode: ContactQrMode.vCard,
    );
    await pumpBadge(tester, const Size(296, 128), data);
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
