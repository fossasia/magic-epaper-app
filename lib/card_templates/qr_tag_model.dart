import 'package:flutter/material.dart';

enum QrTagType { link, wifi, phone, email, sms, text }

class QrTagModel {
  final QrTagType type;
  final String caption;
  final String iconKey;

  final String content;

  final String emailAddress;
  final String emailSubject;

  final String smsNumber;
  final String smsMessage;

  final String ssid;
  final String wifiPassword;
  final String wifiSecurity;
  final bool wifiHidden;

  const QrTagModel({
    this.type = QrTagType.link,
    this.caption = '',
    this.iconKey = 'none',
    this.content = '',
    this.emailAddress = '',
    this.emailSubject = '',
    this.smsNumber = '',
    this.smsMessage = '',
    this.ssid = '',
    this.wifiPassword = '',
    this.wifiSecurity = 'WPA',
    this.wifiHidden = false,
  });

  QrTagModel copyWith({
    QrTagType? type,
    String? caption,
    String? iconKey,
    String? content,
    String? emailAddress,
    String? emailSubject,
    String? smsNumber,
    String? smsMessage,
    String? ssid,
    String? wifiPassword,
    String? wifiSecurity,
    bool? wifiHidden,
  }) {
    return QrTagModel(
      type: type ?? this.type,
      caption: caption ?? this.caption,
      iconKey: iconKey ?? this.iconKey,
      content: content ?? this.content,
      emailAddress: emailAddress ?? this.emailAddress,
      emailSubject: emailSubject ?? this.emailSubject,
      smsNumber: smsNumber ?? this.smsNumber,
      smsMessage: smsMessage ?? this.smsMessage,
      ssid: ssid ?? this.ssid,
      wifiPassword: wifiPassword ?? this.wifiPassword,
      wifiSecurity: wifiSecurity ?? this.wifiSecurity,
      wifiHidden: wifiHidden ?? this.wifiHidden,
    );
  }

  String get qrData {
    switch (type) {
      case QrTagType.link:
      case QrTagType.text:
        return content.trim();
      case QrTagType.phone:
        final n = content.trim();
        return n.isEmpty ? '' : 'tel:$n';
      case QrTagType.email:
        final addr = emailAddress.trim();
        if (addr.isEmpty) return '';
        final sub = emailSubject.trim();
        return sub.isEmpty
            ? 'mailto:$addr'
            : 'mailto:$addr?subject=${Uri.encodeComponent(sub)}';
      case QrTagType.sms:
        final n = smsNumber.trim();
        if (n.isEmpty) return '';
        final msg = smsMessage.trim();
        return msg.isEmpty ? 'sms:$n' : 'SMSTO:$n:$msg';
      case QrTagType.wifi:
        final s = ssid.trim();
        if (s.isEmpty) return '';
        final hidden = wifiHidden ? 'H:true;' : '';
        if (wifiSecurity == 'nopass') {
          return 'WIFI:T:nopass;S:${_wifiEscape(s)};$hidden;';
        }
        return 'WIFI:T:$wifiSecurity;S:${_wifiEscape(s)};'
            'P:${_wifiEscape(wifiPassword)};$hidden;';
    }
  }

  bool get hasContent => qrData.trim().isNotEmpty;

  static String _wifiEscape(String value) => value
      .replaceAll('\\', '\\\\')
      .replaceAll(';', '\\;')
      .replaceAll(',', '\\,')
      .replaceAll(':', '\\:')
      .replaceAll('"', '\\"');
}

String defaultIconForType(QrTagType type) {
  switch (type) {
    case QrTagType.link:
      return 'link';
    case QrTagType.wifi:
      return 'wifi';
    case QrTagType.phone:
      return 'phone';
    case QrTagType.email:
      return 'email';
    case QrTagType.sms:
      return 'sms';
    case QrTagType.text:
      return 'info';
  }
}

class QrTagIconOption {
  final String key;
  final IconData? icon;

  const QrTagIconOption(this.key, this.icon);
}

const List<QrTagIconOption> qrTagIconOptions = [
  QrTagIconOption('none', null),
  QrTagIconOption('link', Icons.link),
  QrTagIconOption('wifi', Icons.wifi),
  QrTagIconOption('phone', Icons.phone),
  QrTagIconOption('email', Icons.email_outlined),
  QrTagIconOption('sms', Icons.sms_outlined),
  QrTagIconOption('laptop', Icons.laptop_mac),
  QrTagIconOption('bag', Icons.shopping_bag_outlined),
  QrTagIconOption('luggage', Icons.luggage),
  QrTagIconOption('key', Icons.vpn_key_outlined),
  QrTagIconOption('home', Icons.home_outlined),
  QrTagIconOption('car', Icons.directions_car_outlined),
  QrTagIconOption('pets', Icons.pets),
  QrTagIconOption('restaurant', Icons.restaurant),
  QrTagIconOption('info', Icons.info_outline),
  QrTagIconOption('star', Icons.star_outline),
];

IconData? qrTagIconFor(String key) {
  for (final option in qrTagIconOptions) {
    if (option.key == key) return option.icon;
  }
  return null;
}
