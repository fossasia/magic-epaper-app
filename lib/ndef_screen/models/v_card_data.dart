class VCardData {
  final String firstName;
  final String lastName;
  final String organization;
  final String title;
  final String mobileNumber;
  final String emailAddress;
  final String street;
  final String city;
  final String zipCode;
  final String country;
  final String website;

  VCardData({
    required this.firstName,
    required this.lastName,
    required this.organization,
    required this.title,
    required this.mobileNumber,
    required this.emailAddress,
    required this.street,
    required this.city,
    required this.zipCode,
    required this.country,
    required this.website,
  });

  String toVCardString() {
    StringBuffer vcard = StringBuffer();

    vcard.writeln('BEGIN:VCARD');
    vcard.writeln('VERSION:3.0');

    if (firstName.isNotEmpty || lastName.isNotEmpty) {
      vcard.writeln('FN;CHARSET=UTF-8:$firstName $lastName');
    }

    if (firstName.isNotEmpty || lastName.isNotEmpty) {
      vcard.writeln('N;CHARSET=UTF-8:$lastName;$firstName;;;');
    }

    if (emailAddress.isNotEmpty) {
      vcard.writeln('EMAIL;CHARSET=UTF-8;type=HOME,INTERNET:$emailAddress');
    }

    if (mobileNumber.isNotEmpty) {
      vcard.writeln('TEL;TYPE=CELL:$mobileNumber');
    }

    if (street.isNotEmpty ||
        city.isNotEmpty ||
        zipCode.isNotEmpty ||
        country.isNotEmpty) {
      vcard.writeln(
          'ADR;CHARSET=UTF-8;TYPE=HOME:;;$street;$city;;$zipCode;$country');
    }

    if (title.isNotEmpty) {
      vcard.writeln('TITLE;CHARSET=UTF-8:$title');
    }

    if (organization.isNotEmpty) {
      vcard.writeln('ORG;CHARSET=UTF-8:$organization');
    }

    if (website.isNotEmpty) {
      vcard.writeln('URL;CHARSET=UTF-8:$website');
    }

    DateTime now = DateTime.now();
    String timestamp = now
        .toIso8601String()
        .replaceAll(':', '')
        .replaceAll('-', '')
        .replaceAll('.', '');
    vcard.writeln('REV:${timestamp}Z');

    vcard.writeln('END:VCARD');

    return vcard.toString();
  }
}
