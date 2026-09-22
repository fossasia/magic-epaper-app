import 'package:flutter_test/flutter_test.dart';
import 'package:magicepaperapp/card_templates/contact_card_model.dart';

ContactCardModel _model({
  String fullName = 'Ada Lovelace',
  String jobTitle = 'Engineer',
  String company = 'Analytical Engines',
  String phone = '+1 555 0100',
  String email = 'ada@example.com',
  String link = 'https://example.com',
  ContactQrMode qrMode = ContactQrMode.vCard,
}) {
  return ContactCardModel(
    fullName: fullName,
    jobTitle: jobTitle,
    company: company,
    phone: phone,
    email: email,
    link: link,
    qrMode: qrMode,
  );
}

void main() {
  group('ContactCardModel', () {
    test('vCard mode produces a valid vCard with all fields', () {
      final data = _model().qrData;

      expect(data, startsWith('BEGIN:VCARD'));
      expect(data, endsWith('END:VCARD'));
      expect(data, contains('VERSION:3.0'));
      expect(data, contains('FN:Ada Lovelace'));
      expect(data, contains('TITLE:Engineer'));
      expect(data, contains('ORG:Analytical Engines'));
      expect(data, contains('TEL;TYPE=CELL:+1 555 0100'));
      expect(data, contains('EMAIL;TYPE=INTERNET:ada@example.com'));
      expect(data, contains('URL:https://example.com'));
    });

    test('empty fields are omitted from the vCard', () {
      final data = _model(
        jobTitle: '',
        company: '',
        phone: '',
        email: '',
        link: '',
      ).qrData;

      expect(data, contains('FN:Ada Lovelace'));
      expect(data, isNot(contains('TITLE:')));
      expect(data, isNot(contains('ORG:')));
      expect(data, isNot(contains('TEL')));
      expect(data, isNot(contains('EMAIL')));
      expect(data, isNot(contains('URL:')));
    });

    test('special characters are escaped in the vCard', () {
      final data = _model(company: 'Doe, Inc; Ltd').qrData;

      expect(data, contains(r'ORG:Doe\, Inc\; Ltd'));
    });

    test('link mode uses the raw link as the QR payload', () {
      final model = _model(
        link: 'https://linkedin.com/in/ada',
        qrMode: ContactQrMode.link,
      );

      expect(model.qrData, 'https://linkedin.com/in/ada');
      expect(model.qrData, isNot(contains('BEGIN:VCARD')));
      expect(model.isLinkQr, isTrue);
    });

    test('link mode with an empty link falls back to a vCard', () {
      final model = _model(link: '', qrMode: ContactQrMode.link);

      expect(model.isLinkQr, isFalse);
      expect(model.qrData, startsWith('BEGIN:VCARD'));
      expect(model.qrData, contains('FN:Ada Lovelace'));
    });

    test('hasAnyData reflects whether any field is filled', () {
      expect(_model().hasAnyData, isTrue);
      expect(
        _model(
          fullName: '',
          jobTitle: '',
          company: '',
          phone: '',
          email: '',
          link: '',
        ).hasAnyData,
        isFalse,
      );
    });
  });
}
