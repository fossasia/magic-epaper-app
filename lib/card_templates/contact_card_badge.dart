import 'dart:math' as math;
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:magicepaperapp/card_templates/contact_card_model.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/theme/colors.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

class ContactCardBadge extends StatelessWidget {
  final ContactCardModel data;

  final bool isPreview;

  final bool interactive;

  const ContactCardBadge({
    super.key,
    required this.data,
    this.isPreview = false,
    this.interactive = false,
  });

  Widget _field(BuildContext context, String id, Widget child) {
    if (!interactive) return child;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(id),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final pad = h * 0.06;
        final cw = w - pad * 2;
        final ch = h - pad * 2;

        final qrData = data.qrData.trim();
        final hasQr = qrData.isNotEmpty;

        final rightW = hasQr ? math.min(w * 0.32, ch * 0.94) : 0.0;
        final gapX = hasQr ? cw * 0.04 : 0.0;
        final leftW = cw - rightW - gapX;

        return Container(
          width: w,
          height: h,
          color: colorWhite,
          padding: EdgeInsets.all(pad),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: leftW,
                height: ch,
                child: _buildLeft(context, leftW, ch, cw),
              ),
              if (hasQr) ...[
                SizedBox(width: gapX),
                SizedBox(
                  width: rightW,
                  height: ch,
                  child: _buildRight(qrData, rightW, ch),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildLeft(BuildContext context, double leftW, double ch, double cw) {
    final hasPhoto = data.profileImage != null;

    final nameFilled = data.fullName.trim().isNotEmpty;
    final showName = nameFilled || isPreview;
    final nameText =
        nameFilled ? data.fullName.trim() : appLocalizations.yourName;

    final subEntries = <MapEntry<String, String>>[
      if (data.jobTitle.trim().isNotEmpty)
        MapEntry('jobTitle', data.jobTitle.trim()),
      if (data.company.trim().isNotEmpty)
        MapEntry('company', data.company.trim()),
    ];
    final hasSub = subEntries.isNotEmpty;

    final contactEntries = <MapEntry<String, String>>[
      if (data.phone.trim().isNotEmpty) MapEntry('phone', data.phone.trim()),
      if (data.email.trim().isNotEmpty) MapEntry('email', data.email.trim()),
      if (data.link.trim().isNotEmpty)
        MapEntry('link', _prettyLink(data.link.trim())),
    ];

    final nameH = showName ? ch * 0.28 : 0.0;
    final subH = hasSub ? ch * 0.16 : 0.0;
    var identH = nameH + subH;
    if (hasPhoto && identH < ch * 0.4) identH = ch * 0.4;
    final hasIdentity = identH > 0;

    final divTh = math.max(1.0, ch * 0.012);
    final showDivider = hasIdentity && contactEntries.isNotEmpty;
    final divBlockH = showDivider ? ch * 0.1 : 0.0;

    final contactsH = ch - identH - divBlockH;
    final perContactH = contactEntries.isEmpty
        ? 0.0
        : math.min(contactsH / contactEntries.length, ch * 0.32);

    final nameFs = nameH * 0.9;
    final subFs = subH * 0.82;
    final contactFs = perContactH * 0.8;

    final photoD = hasPhoto ? identH * 0.9 : 0.0;
    final photoGap = hasPhoto ? cw * 0.03 : 0.0;
    final identTextW = leftW - photoD - photoGap;

    final identityLines = <Widget>[
      if (showName)
        SizedBox(
          width: identTextW,
          height: nameH,
          child: _field(
            context,
            'fullName',
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                nameText,
                maxLines: 1,
                softWrap: false,
                style: TextStyle(
                  color: nameFilled
                      ? colorBlack
                      : colorBlack.withValues(alpha: 0.35),
                  fontSize: nameFs,
                  height: 1.0,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ),
      if (hasSub)
        SizedBox(
          width: identTextW,
          height: subH,
          child: Align(
            alignment: Alignment.centerLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < subEntries.length; i++) ...[
                    if (i > 0)
                      Text(
                        '  •  ',
                        style: TextStyle(
                          color: colorBlack,
                          fontSize: subFs,
                          height: 1.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    _field(
                      context,
                      subEntries[i].key,
                      Text(
                        subEntries[i].value,
                        maxLines: 1,
                        softWrap: false,
                        style: TextStyle(
                          color: colorBlack,
                          fontSize: subFs,
                          height: 1.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          hasIdentity ? MainAxisAlignment.start : MainAxisAlignment.center,
      children: [
        if (hasIdentity)
          SizedBox(
            height: identH,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (hasPhoto) ...[
                  _field(
                    context,
                    'profileImage',
                    Container(
                      width: photoD,
                      height: photoD,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: colorBlack, width: divTh),
                        image: DecorationImage(
                          image: FileImage(data.profileImage!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: photoGap),
                ],
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: identityLines,
                  ),
                ),
              ],
            ),
          ),
        if (showDivider) ...[
          SizedBox(height: divBlockH * 0.35),
          Container(width: leftW, height: divTh, color: colorBlack),
          SizedBox(height: divBlockH * 0.4),
        ],
        for (final entry in contactEntries)
          SizedBox(
            width: leftW,
            height: perContactH,
            child: _field(
              context,
              entry.key,
              Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    entry.value,
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(
                      color: colorBlack,
                      fontSize: contactFs,
                      height: 1.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRight(String qrData, double rightW, double ch) {
    final captionH = ch * 0.1;
    final qrSide = math.min(rightW, ch - captionH - ch * 0.04);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: qrSide,
          height: qrSide,
          child: BarcodeWidget(
            barcode: Barcode.qrCode(),
            data: qrData,
            color: colorBlack,
            backgroundColor: colorWhite,
            padding: EdgeInsets.all(qrSide * 0.08),
            drawText: false,
            errorBuilder: (context, error) => const SizedBox.shrink(),
          ),
        ),
        SizedBox(height: ch * 0.04),
        SizedBox(
          width: rightW,
          height: captionH,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              data.isLinkQr
                  ? appLocalizations.contactScanMe
                  : appLocalizations.contactScanToSave,
              style: const TextStyle(
                color: colorBlack,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _prettyLink(String link) {
    var result = link.trim();
    for (final prefix in const ['https://', 'http://', 'www.']) {
      if (result.toLowerCase().startsWith(prefix)) {
        result = result.substring(prefix.length);
      }
    }
    if (result.endsWith('/')) {
      result = result.substring(0, result.length - 1);
    }
    return result;
  }
}
