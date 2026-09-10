import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:magicepaperapp/card_templates/utils/ocr_recognizer.dart';
import 'package:magicepaperapp/constants/color_constants.dart';
import 'package:magicepaperapp/constants/dimens.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/utils/app_logger.dart' show AppLogger;
import 'package:magicepaperapp/utils/image_source_picker.dart';

bool get isOcrSupported =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS);

final _emailRe = RegExp(r'[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}');
final _phoneRe =
    RegExp(r'(\+?\d{1,3}[\s\-.]?)?\(?\d{3}\)?[\s\-.]?\d{3}[\s\-.]?\d{4}');
final _urlRe = RegExp(r'(https?://|www\.)[^\s]+', caseSensitive: false);
final _priceRe =
    RegExp(r'[\$£€¥₹]\s*\d+([.,]\d{1,2})?|\d+[.,]\d{2}\s*[\$£€¥₹]');
final _labelledIdRe = RegExp(r'(?:EMP|ID|No\.?|#)\s*[:#]?\s*([A-Z0-9\-]{3,12})',
    caseSensitive: false);
final _barcodeRe = RegExp(r'\b\d{8,13}\b');
final _genericIdRe = RegExp(r'\b[A-Z0-9]{4,8}\b');
final _companyRe = RegExp(
    r'\b(inc|ltd|llc|corp|co|gmbh|pvt|limited|technologies|technology|solutions|systems|labs|studios?|group|enterprises|industries|consulting|services|software|media|ventures|partners|university|college|institute|foundation)\b\.?',
    caseSensitive: false);
final _titleRe = RegExp(
    r'\b(engineer|developer|manager|designer|director|officer|ceo|cto|cfo|coo|founder|co-?founder|lead|head|consultant|analyst|architect|president|vp|executive|specialist|coordinator|administrator|intern|scientist|researcher|advisor|associate|assistant|supervisor|technician|marketer|strategist|professor|teacher|student)\b',
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

Future<String?> _pickAndRecognize(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
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
      () => recognizeTextFromPath(picked.path),
    );
    return text.isEmpty ? null : text;
  } catch (e) {
    AppLogger.error('OCR scan failed', e);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.ocrCouldNotReadImage)),
      );
    }
    return null;
  }
}

Future<String?> scanImageForRawText(BuildContext context) async {
  if (!isOcrSupported) return null;
  return _pickAndRecognize(context);
}

List<String> _cleanLines(String text) =>
    text.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();

String? _firstMatch(RegExp re, String text) {
  final m = re.firstMatch(text);
  return m?.group(0);
}

List<String> _textLines(List<String> lines) => lines
    .where((l) =>
        !_emailRe.hasMatch(l) && !_urlRe.hasMatch(l) && !_phoneRe.hasMatch(l))
    .toList();

bool _looksLikeCompany(String l) => _companyRe.hasMatch(l);
bool _looksLikeTitle(String l) => _titleRe.hasMatch(l);

bool _looksLikeName(String l) {
  if (l.length < 3 || l.length > 50) return false;
  if (_companyRe.hasMatch(l) || _titleRe.hasMatch(l)) return false;
  final words = l.trim().split(RegExp(r'\s+'));
  if (words.length < 2 || words.length > 4) return false;
  return words.every((w) => RegExp(r"^[A-Za-z\-'.]+$").hasMatch(w));
}

String _extractId(List<String> lines) {
  for (final line in lines) {
    final labelled = _labelledIdRe.firstMatch(line);
    if (labelled != null) return labelled.group(1)!.trim();
  }
  for (final line in lines) {
    final barcode = _barcodeRe.firstMatch(line);
    if (barcode != null) return barcode.group(0)!.trim();
  }
  for (final line in lines) {
    final generic = _genericIdRe.firstMatch(line);
    if (generic != null && RegExp(r'\d').hasMatch(generic.group(0)!)) {
      return generic.group(0)!.trim();
    }
  }
  return '';
}

Map<String, String> _parseContact(String text) {
  final lines = _cleanLines(text);
  final joined = lines.join(' ');
  final email = _firstMatch(_emailRe, joined) ?? '';
  final url = _firstMatch(_urlRe, joined) ?? '';
  final phone = _firstMatch(_phoneRe, joined) ?? '';
  String fullName = '', jobTitle = '', company = '';
  final leftover = <String>[];
  for (final line in _textLines(lines)) {
    if (fullName.isEmpty && _looksLikeName(line)) {
      fullName = line;
    } else if (jobTitle.isEmpty && _looksLikeTitle(line)) {
      jobTitle = line;
    } else if (company.isEmpty && _looksLikeCompany(line)) {
      company = line;
    } else {
      leftover.add(line);
    }
  }
  for (final line in leftover) {
    if (fullName.isEmpty && _looksLikeName(line)) {
      fullName = line;
    } else if (jobTitle.isEmpty) {
      jobTitle = line;
    } else if (company.isEmpty) {
      company = line;
    }
  }
  return {
    'fullName': fullName,
    'jobTitle': jobTitle,
    'company': company,
    'phone': phone,
    'email': email,
    'link': url,
  };
}

Map<String, String> _parseEmployeeId(String text) {
  final lines = _cleanLines(text);
  final joined = lines.join(' ');
  String name = '', companyName = '', position = '', division = '';
  final idNumber = _extractId(lines);
  final textOnly = _textLines(lines);
  final leftover = <String>[];
  for (final line in textOnly) {
    if (companyName.isEmpty && _looksLikeCompany(line)) {
      companyName = line;
    } else if (position.isEmpty && _looksLikeTitle(line)) {
      position = line;
    } else if (name.isEmpty && _looksLikeName(line)) {
      name = line;
    } else {
      leftover.add(line);
    }
  }
  for (final line in leftover) {
    if (name.isEmpty && _looksLikeName(line)) {
      name = line;
    } else if (position.isEmpty) {
      position = line;
    } else if (division.isEmpty && companyName.isNotEmpty) {
      division = line;
    } else if (companyName.isEmpty) {
      companyName = line;
    }
  }
  final url = _firstMatch(_urlRe, joined) ?? '';
  return {
    'name': name,
    'companyName': companyName,
    'position': position,
    'division': division,
    'idNumber': idNumber,
    'qrData': url,
  };
}

Map<String, String> _parseEventBadge(String text) {
  final lines = _cleanLines(text);
  final joined = lines.join(' ');
  String attendeeName = '', organization = '', role = '', eventName = '';
  final ticketId = _extractId(lines);
  final textOnly = _textLines(lines);
  final leftover = <String>[];
  for (final line in textOnly) {
    if (organization.isEmpty && _looksLikeCompany(line)) {
      organization = line;
    } else if (role.isEmpty && _looksLikeTitle(line)) {
      role = line;
    } else if (attendeeName.isEmpty && _looksLikeName(line)) {
      attendeeName = line;
    } else {
      leftover.add(line);
    }
  }
  for (final line in leftover) {
    if (attendeeName.isEmpty && _looksLikeName(line)) {
      attendeeName = line;
    } else if (eventName.isEmpty) {
      eventName = line;
    } else if (role.isEmpty) {
      role = line;
    }
  }
  final url = _firstMatch(_urlRe, joined) ?? '';
  return {
    'eventName': eventName,
    'attendeeName': attendeeName,
    'organization': organization,
    'role': role,
    'ticketId': ticketId,
    'qrData': url,
  };
}

Map<String, String> _parseEntryPass(String text) {
  final lines = _cleanLines(text);
  final joined = lines.join(' ');
  String visitorName = '', venueName = '';
  final passId = _extractId(lines);
  final textOnly = _textLines(lines);
  final leftover = <String>[];
  for (final line in textOnly) {
    if (venueName.isEmpty && _looksLikeCompany(line)) {
      venueName = line;
    } else if (visitorName.isEmpty && _looksLikeName(line)) {
      visitorName = line;
    } else {
      leftover.add(line);
    }
  }
  for (final line in leftover) {
    if (visitorName.isEmpty && _looksLikeName(line)) {
      visitorName = line;
    } else if (venueName.isEmpty) {
      venueName = line;
    }
  }
  final url = _firstMatch(_urlRe, joined) ?? '';
  return {
    'visitorName': visitorName,
    'venueName': venueName,
    'passId': passId,
    'qrData': url,
  };
}

Map<String, String> _parsePriceTag(String text) {
  final lines = _cleanLines(text);
  final joined = lines.join(' ');
  final price = _firstMatch(_priceRe, joined) ?? '';
  final barcode = _firstMatch(_barcodeRe, joined) ?? '';
  String productName = '', productDescription = '';
  final leftover = <String>[];
  for (final line in lines) {
    if (_priceRe.hasMatch(line) || _barcodeRe.hasMatch(line)) continue;
    if (productName.isEmpty) {
      productName = line;
    } else {
      leftover.add(line);
    }
  }
  if (leftover.isNotEmpty) {
    productDescription = leftover.join(' ');
  }
  return {
    'productName': productName,
    'productDescription': productDescription,
    'price': price,
    'barcode': barcode,
  };
}

Future<Map<String, String>?> _showReviewSheet(
  BuildContext context,
  Map<String, String> parsed,
  Map<String, String> labels,
) async {
  final l10n = AppLocalizations.of(context)!;
  final controllers = {
    for (final e in parsed.entries)
      if (e.value.isNotEmpty) e.key: TextEditingController(text: e.value),
  };

  if (controllers.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.ocrNoDetails)),
    );
    return null;
  }

  final result = await showModalBottomSheet<Map<String, String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: colorWhite,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _OcrReviewSheet(
      controllers: controllers,
      labels: labels,
      l10n: l10n,
    ),
  );

  for (final c in controllers.values) {
    c.dispose();
  }
  return result;
}

class _OcrReviewSheet extends StatefulWidget {
  final Map<String, TextEditingController> controllers;
  final Map<String, String> labels;
  final AppLocalizations l10n;

  const _OcrReviewSheet({
    required this.controllers,
    required this.labels,
    required this.l10n,
  });

  @override
  State<_OcrReviewSheet> createState() => _OcrReviewSheetState();
}

class _OcrReviewSheetState extends State<_OcrReviewSheet> {
  late final Map<String, bool> _selected;

  @override
  void initState() {
    super.initState();
    _selected = {for (final k in widget.controllers.keys) k: true};
  }

  @override
  Widget build(BuildContext context) {
    final keys = widget.controllers.keys.toList();
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.85 - keyboardHeight,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(Icons.document_scanner_outlined,
                    color: colorAccent, size: 20),
                const SizedBox(width: 8),
                Text(
                  widget.l10n.ocrScannedDetails,
                  style: const TextStyle(
                    fontSize: Dimens.fontSizeXl,
                    fontWeight: FontWeight.bold,
                    color: colorBlack,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.l10n.ocrReviewHint,
              style: TextStyle(fontSize: Dimens.fontSizeS, color: grey600),
            ),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: keys.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final key = keys[i];
                final label = widget.labels[key] ?? key;
                final selected = _selected[key] ?? true;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: selected,
                      activeColor: colorAccent,
                      onChanged: (v) =>
                          setState(() => _selected[key] = v ?? false),
                    ),
                    Expanded(
                      child: TextField(
                        controller: widget.controllers[key],
                        enabled: selected,
                        decoration: InputDecoration(
                          labelText: label,
                          labelStyle: TextStyle(
                            color: selected ? colorAccent : grey400,
                            fontSize: Dimens.fontSizeM,
                          ),
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: grey300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: colorAccent),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final result = <String, String>{};
                    for (final key in keys) {
                      if (_selected[key] == true) {
                        final val = widget.controllers[key]!.text.trim();
                        if (val.isNotEmpty) result[key] = val;
                      }
                    }
                    Navigator.of(context).pop(result);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorPrimary,
                    foregroundColor: colorWhite,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    widget.l10n.ocrFillFields,
                    style: const TextStyle(
                      fontSize: Dimens.fontSizeL,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}

Future<Map<String, String>?> scanCardForContact(BuildContext context) async {
  if (!isOcrSupported) return null;
  final text = await _pickAndRecognize(context);
  if (text == null || !context.mounted) return null;
  final parsed = _parseContact(text);
  final l10n = AppLocalizations.of(context)!;
  return _showReviewSheet(context, parsed, {
    'fullName': l10n.fullName,
    'jobTitle': l10n.jobTitle,
    'company': l10n.companyOrganization,
    'phone': l10n.phoneNumber,
    'email': l10n.emailAddress,
    'link': l10n.ocrQrLink,
  });
}

Future<Map<String, String>?> scanCardForEmployeeId(BuildContext context) async {
  if (!isOcrSupported) return null;
  final text = await _pickAndRecognize(context);
  if (text == null || !context.mounted) return null;
  final parsed = _parseEmployeeId(text);
  final l10n = AppLocalizations.of(context)!;
  return _showReviewSheet(context, parsed, {
    'name': l10n.fullName,
    'companyName': l10n.companyOrganization,
    'position': l10n.jobTitle,
    'division': l10n.division,
    'idNumber': l10n.idNumber,
    'qrData': l10n.ocrQrLink,
  });
}

Future<Map<String, String>?> scanCardForEventBadge(BuildContext context) async {
  if (!isOcrSupported) return null;
  final text = await _pickAndRecognize(context);
  if (text == null || !context.mounted) return null;
  final parsed = _parseEventBadge(text);
  final l10n = AppLocalizations.of(context)!;
  return _showReviewSheet(context, parsed, {
    'eventName': l10n.eventName,
    'attendeeName': l10n.attendeeName,
    'organization': l10n.organization,
    'role': l10n.role,
    'ticketId': l10n.ticketId,
    'qrData': l10n.ocrQrLink,
  });
}

Future<Map<String, String>?> scanCardForEntryPass(BuildContext context) async {
  if (!isOcrSupported) return null;
  final text = await _pickAndRecognize(context);
  if (text == null || !context.mounted) return null;
  final parsed = _parseEntryPass(text);
  final l10n = AppLocalizations.of(context)!;
  return _showReviewSheet(context, parsed, {
    'visitorName': l10n.visitorName,
    'venueName': l10n.venueName,
    'passId': l10n.passId,
    'qrData': l10n.ocrQrLink,
  });
}

Future<Map<String, String>?> scanCardForPriceTag(BuildContext context) async {
  if (!isOcrSupported) return null;
  final text = await _pickAndRecognize(context);
  if (text == null || !context.mounted) return null;
  final parsed = _parsePriceTag(text);
  final l10n = AppLocalizations.of(context)!;
  return _showReviewSheet(context, parsed, {
    'productName': l10n.productName,
    'productDescription': l10n.productDescription,
    'price': l10n.price,
    'barcode': l10n.barcode,
  });
}
