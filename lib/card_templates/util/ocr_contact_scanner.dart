import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ocr_native/flutter_ocr_native.dart';
import 'package:image_picker/image_picker.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/util/app_logger.dart' show AppLogger;
import 'package:magicepaperapp/util/image_source_picker.dart';

class OcrContactResult {
  final String fullName;
  final String jobTitle;
  final String company;
  final String phone;
  final String email;
  final String link;

  const OcrContactResult({
    this.fullName = '',
    this.jobTitle = '',
    this.company = '',
    this.phone = '',
    this.email = '',
    this.link = '',
  });

  bool get hasAnyData =>
      fullName.isNotEmpty ||
      jobTitle.isNotEmpty ||
      company.isNotEmpty ||
      phone.isNotEmpty ||
      email.isNotEmpty ||
      link.isNotEmpty;
}

class _OcrFieldDef {
  final String key;
  final String label;
  final IconData icon;
  const _OcrFieldDef(this.key, this.label, this.icon);
}

final _emailRe =
    RegExp(r'[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}');
final _phoneRe =
    RegExp(r'(\+?1[\s\-.]?)?\(?\d{3}\)?[\s\-.]?\d{3}[\s\-.]?\d{4}');
final _urlRe =
    RegExp(r'(https?://|www\.)[^\s]+', caseSensitive: false);
final _priceRe = RegExp(
    r'[\$£€¥₹]\s*\d+[.,]\d{2}|\d+[.,]\d{2}\s*[\$£€¥₹]|\b\d+[.,]\d{2}\b');
final _barcodeRe = RegExp(r'\b\d{8,13}\b');
final _idNumberRe =
    RegExp(r'(?:EMP|ID|No\.?|#)\s*[A-Z0-9\-]{3,10}|\b\d{4,8}\b');
final _labelPrefixRe =
    RegExp(r'^(name|id|dept|division|position|role|org|company|venue|pass|ticket)[:\s]+',
        caseSensitive: false);

Future<T> _showLoaderWhile<T>(
  BuildContext context,
  Future<T> Function() task,
) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: colorBlack54,
    builder: (_) => const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(colorAccent),
      ),
    ),
  );
  try {
    return await task();
  } finally {
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}

String _stripLabelPrefix(String line) =>
    line.replaceFirst(_labelPrefixRe, '').trim();

bool _looksLikeName(String line) {
  final words = line.trim().split(RegExp(r'\s+'));
  return words.length >= 2 &&
      words.length <= 5 &&
      !line.contains(RegExp(r'[0-9@/\\|]'));
}

({
  String email,
  String phone,
  String url,
  String price,
  String barcode,
  String idNumber,
  List<String> remaining,
}) _extractStructured(List<String> lines) {
  String email = '';
  String phone = '';
  String url = '';
  String price = '';
  String barcode = '';
  String idNumber = '';
  final remaining = <String>[];

  for (final raw in lines) {
    var rest = _stripLabelPrefix(raw);

    if (email.isEmpty && _emailRe.hasMatch(rest)) {
      email = _emailRe.firstMatch(rest)!.group(0)!;
      rest = rest.replaceFirst(email, '').trim();
    }
    if (url.isEmpty && _urlRe.hasMatch(rest)) {
      url = _urlRe.firstMatch(rest)!.group(0)!;
      rest = rest.replaceFirst(url, '').trim();
    }
    if (phone.isEmpty && _phoneRe.hasMatch(rest)) {
      final m = _phoneRe.firstMatch(rest)!.group(0)!.trim();
      phone = m;
      rest = rest.replaceFirst(m, '').trim();
    }
    if (price.isEmpty && _priceRe.hasMatch(rest)) {
      price = _priceRe.firstMatch(rest)!.group(0)!.trim();
      rest = rest.replaceFirst(price, '').trim();
    }
    if (barcode.isEmpty && _barcodeRe.hasMatch(rest)) {
      barcode = _barcodeRe.firstMatch(rest)!.group(0)!.trim();
      rest = rest.replaceFirst(barcode, '').trim();
    }
    if (idNumber.isEmpty && _idNumberRe.hasMatch(rest)) {
      idNumber = _idNumberRe.firstMatch(rest)!.group(0)!.trim();
      rest = rest.replaceFirst(idNumber, '').trim();
    }

    if (rest.isNotEmpty) remaining.add(rest);
  }

  return (
    email: email,
    phone: phone,
    url: url,
    price: price,
    barcode: barcode,
    idNumber: idNumber,
    remaining: remaining,
  );
}

List<String> _cleanLines(String raw) => raw
    .split('\n')
    .map((l) => l.trim())
    .where((l) => l.isNotEmpty)
    .toList();

Map<String, String> _parseContactFields(String text) {
  final s = _extractStructured(_cleanLines(text));
  String fullName = '', jobTitle = '', company = '';
  for (final line in s.remaining) {
    if (fullName.isEmpty && _looksLikeName(line)) {
      fullName = line;
    } else if (fullName.isNotEmpty && jobTitle.isEmpty) {
      jobTitle = line;
    } else if (jobTitle.isNotEmpty && company.isEmpty) {
      company = line;
    }
  }
  return {
    'fullName': fullName,
    'jobTitle': jobTitle,
    'company': company,
    'phone': s.phone,
    'email': s.email,
    'link': s.url,
  };
}

Map<String, String> _parseEmployeeIdFields(String text) {
  final s = _extractStructured(_cleanLines(text));
  String name = '', position = '', division = '', companyName = '';
  for (final line in s.remaining) {
    if (name.isEmpty && _looksLikeName(line)) {
      name = line;
    } else if (name.isNotEmpty && position.isEmpty && !line.contains(RegExp(r'\d'))) {
      position = line;
    } else if (position.isNotEmpty && division.isEmpty && !line.contains(RegExp(r'\d'))) {
      division = line;
    } else if (companyName.isEmpty && !line.contains(RegExp(r'\d'))) {
      companyName = line;
    }
  }
  return {
    'name': name,
    'companyName': companyName,
    'position': position,
    'division': division,
    'idNumber': s.idNumber,
    'qrData': s.url,
  };
}

Map<String, String> _parseEventBadgeFields(String text) {
  final s = _extractStructured(_cleanLines(text));
  String attendeeName = '', role = '', organization = '';
  for (final line in s.remaining) {
    if (attendeeName.isEmpty && _looksLikeName(line)) {
      attendeeName = line;
    } else if (attendeeName.isNotEmpty && role.isEmpty && !line.contains(RegExp(r'\d'))) {
      role = line;
    } else if (role.isNotEmpty && organization.isEmpty) {
      organization = line;
    }
  }
  return {
    'attendeeName': attendeeName,
    'organization': organization,
    'role': role,
    'ticketId': s.idNumber,
    'qrData': s.url,
  };
}

Map<String, String> _parseEntryPassFields(String text) {
  final s = _extractStructured(_cleanLines(text));
  String visitorName = '', venueName = '';
  for (final line in s.remaining) {
    if (visitorName.isEmpty && _looksLikeName(line)) {
      visitorName = line;
    } else if (venueName.isEmpty && line.length > 4) {
      venueName = line;
    }
  }
  return {
    'visitorName': visitorName,
    'venueName': venueName,
    'passId': s.idNumber,
    'qrData': s.url,
  };
}

Map<String, String> _parsePriceTagFields(String text) {
  final s = _extractStructured(_cleanLines(text));
  String productName = '', productDescription = '';
  for (final line in s.remaining) {
    if (productName.isEmpty) {
      productName = line;
    } else if (productDescription.isEmpty) {
      productDescription = line;
    }
  }
  return {
    'productName': productName,
    'productDescription': productDescription,
    'price': s.price,
    'barcode': s.barcode,
  };
}

Future<Map<String, String>?> _runOcrScan(
  BuildContext context,
  List<_OcrFieldDef> fieldDefs,
  Map<String, String> Function(String) parser,
) async {
  final source = await chooseImageSource(context);
  if (source == null) return null;
  if (!context.mounted) return null;

  Map<String, String> parsed;
  try {
    final picked = await ImagePicker().pickImage(
      source: source,
      maxWidth: 2200,
      imageQuality: 90,
    );
    if (picked == null) return null;
    if (!context.mounted) return null;
    parsed = await _showLoaderWhile(
      context,
      () async {
        final reader = OcrReader();
        final result = await reader.readFromFile(File(picked.path));
        return parser(result.text);
      },
    );
  } catch (e) {
    AppLogger.error('OCR failed', e);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not read text from image.')),
      );
    }
    return null;
  }

  if (parsed.values.every((v) => v.isEmpty)) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No details detected.')),
      );
    }
    return null;
  }

  if (!context.mounted) return null;
  return _showReviewSheet(context, fieldDefs, parsed);
}

Future<Map<String, String>?> _showReviewSheet(
  BuildContext context,
  List<_OcrFieldDef> fieldDefs,
  Map<String, String> values,
) {
  return showModalBottomSheet<Map<String, String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: colorWhite,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _OcrReviewSheet(fieldDefs: fieldDefs, values: values),
  );
}

class _OcrReviewSheet extends StatefulWidget {
  final List<_OcrFieldDef> fieldDefs;
  final Map<String, String> values;
  const _OcrReviewSheet({required this.fieldDefs, required this.values});

  @override
  State<_OcrReviewSheet> createState() => _OcrReviewSheetState();
}

class _OcrReviewSheetState extends State<_OcrReviewSheet> {
  late final Map<String, TextEditingController> _controllers;
  late final Map<String, bool> _enabled;

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (final f in widget.fieldDefs)
        f.key: TextEditingController(text: widget.values[f.key] ?? ''),
    };
    _enabled = {
      for (final f in widget.fieldDefs)
        f.key: (widget.values[f.key] ?? '').isNotEmpty,
    };
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _apply() {
    final result = {
      for (final f in widget.fieldDefs)
        f.key: (_enabled[f.key]! ? _controllers[f.key]!.text : ''),
    };
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;
    final maxHeight = MediaQuery.of(context).size.height * 0.75;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Padding(
        padding: EdgeInsets.fromLTRB(Dimens.spacingXl, Dimens.spacingXl,
            Dimens.spacingXl, bottomPad + Dimens.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.document_scanner_outlined, color: colorAccent),
                const SizedBox(width: Dimens.spacingS),
                const Text(
                  'Scanned Details',
                  style: TextStyle(
                    fontSize: Dimens.fontSizeXl,
                    fontWeight: FontWeight.bold,
                    color: colorBlack,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Text(
              'Review and deselect any fields you don\'t want to fill.',
              style: TextStyle(fontSize: Dimens.fontSizeS, color: grey600),
            ),
            const SizedBox(height: Dimens.spacingL),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: widget.fieldDefs.map((f) {
                    final ctrl = _controllers[f.key]!;
                    final isEnabled = _enabled[f.key]!;
                    if (ctrl.text.isEmpty) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Dimens.spacingM),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: isEnabled,
                            activeColor: colorPrimary,
                            onChanged: (v) =>
                                setState(() => _enabled[f.key] = v ?? false),
                          ),
                          Icon(f.icon,
                              size: Dimens.iconSizeM, color: colorAccent),
                          const SizedBox(width: Dimens.spacingS),
                          Expanded(
                            child: TextField(
                              controller: ctrl,
                              enabled: isEnabled,
                              style: TextStyle(
                                fontSize: Dimens.fontSizeM,
                                color: isEnabled ? colorBlack : grey400,
                              ),
                              decoration: InputDecoration(
                                labelText: f.label,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: Dimens.spacingS,
                                    vertical: Dimens.spacingS),
                                border: const OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: grey300)),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: colorPrimary, width: 2)),
                                disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: grey200)),
                                fillColor: isEnabled ? colorWhite : grey50,
                                filled: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: Dimens.spacingM),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _apply,
                icon: const Icon(Icons.check, size: 18),
                label: const Text(
                  'Fill Fields',
                  style: TextStyle(
                      fontSize: Dimens.fontSizeL, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary,
                  foregroundColor: colorWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimens.radiusM),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _contactFieldDefs = [
  _OcrFieldDef('fullName', 'Full Name', Icons.person_outline),
  _OcrFieldDef('jobTitle', 'Job Title', Icons.work_outline),
  _OcrFieldDef('company', 'Company', Icons.business_outlined),
  _OcrFieldDef('phone', 'Phone', Icons.phone_outlined),
  _OcrFieldDef('email', 'Email', Icons.email_outlined),
  _OcrFieldDef('link', 'Website / Link', Icons.link_outlined),
];

Future<OcrContactResult?> scanCardForContact(BuildContext context) async {
  final r = await _runOcrScan(context, _contactFieldDefs, _parseContactFields);
  if (r == null) return null;
  return OcrContactResult(
    fullName: r['fullName'] ?? '',
    jobTitle: r['jobTitle'] ?? '',
    company: r['company'] ?? '',
    phone: r['phone'] ?? '',
    email: r['email'] ?? '',
    link: r['link'] ?? '',
  );
}

const _employeeIdFieldDefs = [
  _OcrFieldDef('name', 'Name', Icons.person_outline),
  _OcrFieldDef('companyName', 'Company', Icons.business_outlined),
  _OcrFieldDef('position', 'Position / Title', Icons.work_outline),
  _OcrFieldDef('division', 'Division / Dept', Icons.group_outlined),
  _OcrFieldDef('idNumber', 'Employee ID', Icons.badge_outlined),
  _OcrFieldDef('qrData', 'QR / Link', Icons.link_outlined),
];

Future<Map<String, String>?> scanCardForEmployeeId(BuildContext context) =>
    _runOcrScan(context, _employeeIdFieldDefs, _parseEmployeeIdFields);

const _eventBadgeFieldDefs = [
  _OcrFieldDef('attendeeName', 'Attendee Name', Icons.person_outline),
  _OcrFieldDef('organization', 'Organization', Icons.business_outlined),
  _OcrFieldDef('role', 'Role', Icons.work_outline),
  _OcrFieldDef('ticketId', 'Ticket / Badge ID', Icons.confirmation_number_outlined),
  _OcrFieldDef('qrData', 'QR / Link', Icons.link_outlined),
];

Future<Map<String, String>?> scanCardForEventBadge(BuildContext context) =>
    _runOcrScan(context, _eventBadgeFieldDefs, _parseEventBadgeFields);

const _entryPassFieldDefs = [
  _OcrFieldDef('visitorName', 'Visitor Name', Icons.person_outline),
  _OcrFieldDef('venueName', 'Venue / Location', Icons.location_on_outlined),
  _OcrFieldDef('passId', 'Pass ID', Icons.badge_outlined),
  _OcrFieldDef('qrData', 'QR / Link', Icons.link_outlined),
];

Future<Map<String, String>?> scanCardForEntryPass(BuildContext context) =>
    _runOcrScan(context, _entryPassFieldDefs, _parseEntryPassFields);

const _priceTagFieldDefs = [
  _OcrFieldDef('productName', 'Product Name', Icons.label_outline),
  _OcrFieldDef('productDescription', 'Description', Icons.description_outlined),
  _OcrFieldDef('price', 'Price', Icons.attach_money),
  _OcrFieldDef('barcode', 'Barcode', Icons.barcode_reader),
];

Future<Map<String, String>?> scanCardForPriceTag(BuildContext context) =>
    _runOcrScan(context, _priceTagFieldDefs, _parsePriceTagFields);

Future<String?> scanImageForRawText(BuildContext context) async {
  final source = await chooseImageSource(context);
  if (source == null) return null;
  if (!context.mounted) return null;

  try {
    final picked = await ImagePicker()
        .pickImage(source: source, maxWidth: 2200, imageQuality: 90);
    if (picked == null) return null;
    if (!context.mounted) return null;
    final text = await _showLoaderWhile(
      context,
      () async {
        final reader = OcrReader();
        final result = await reader.readFromFile(File(picked.path));
        return result.text.trim();
      },
    );
    return text.isEmpty ? null : text;
  } catch (e) {
    AppLogger.error('OCR raw scan failed', e);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not read text from image.')),
      );
    }
    return null;
  }
}
