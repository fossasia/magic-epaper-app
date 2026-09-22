import 'dart:io';

enum ContactQrMode { vCard, link }

class ContactCardModel {
  final String fullName;
  final String jobTitle;
  final String company;
  final String phone;
  final String email;
  final String link;
  final ContactQrMode qrMode;
  final File? profileImage;

  ContactCardModel({
    required this.fullName,
    required this.jobTitle,
    required this.company,
    required this.phone,
    required this.email,
    required this.link,
    required this.qrMode,
    this.profileImage,
  });

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'jobTitle': jobTitle,
        'company': company,
        'phone': phone,
        'email': email,
        'link': link,
        'qrMode': qrMode.name,
        if (profileImage != null) 'profileImagePath': profileImage!.path,
      };

  factory ContactCardModel.fromJson(Map<String, dynamic> json) {
    final path = json['profileImagePath'] as String?;
    return ContactCardModel(
      fullName: json['fullName'] as String? ?? '',
      jobTitle: json['jobTitle'] as String? ?? '',
      company: json['company'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      link: json['link'] as String? ?? '',
      qrMode: ContactQrMode.values.firstWhere(
        (mode) => mode.name == json['qrMode'],
        orElse: () => ContactQrMode.vCard,
      ),
      profileImage:
          (path != null && File(path).existsSync()) ? File(path) : null,
    );
  }

  String get qrData {
    if (isLinkQr) {
      return link.trim();
    }
    return _buildVCard();
  }

  bool get isLinkQr => qrMode == ContactQrMode.link && link.trim().isNotEmpty;

  bool get hasAnyData =>
      fullName.trim().isNotEmpty ||
      jobTitle.trim().isNotEmpty ||
      company.trim().isNotEmpty ||
      phone.trim().isNotEmpty ||
      email.trim().isNotEmpty ||
      link.trim().isNotEmpty;

  String _buildVCard() {
    final buffer = StringBuffer()
      ..write('BEGIN:VCARD\n')
      ..write('VERSION:3.0\n');

    final name = fullName.trim();
    if (name.isNotEmpty) {
      buffer
        ..write('N:${_escape(name)};;;;\n')
        ..write('FN:${_escape(name)}\n');
    }
    if (jobTitle.trim().isNotEmpty) {
      buffer.write('TITLE:${_escape(jobTitle.trim())}\n');
    }
    if (company.trim().isNotEmpty) {
      buffer.write('ORG:${_escape(company.trim())}\n');
    }
    if (phone.trim().isNotEmpty) {
      buffer.write('TEL;TYPE=CELL:${_escape(phone.trim())}\n');
    }
    if (email.trim().isNotEmpty) {
      buffer.write('EMAIL;TYPE=INTERNET:${_escape(email.trim())}\n');
    }
    if (link.trim().isNotEmpty) {
      buffer.write('URL:${_escape(link.trim())}\n');
    }
    buffer.write('END:VCARD');
    return buffer.toString();
  }

  String _escape(String value) => value
      .replaceAll('\\', '\\\\')
      .replaceAll('\n', '\\n')
      .replaceAll(',', '\\,')
      .replaceAll(';', '\\;');
}
