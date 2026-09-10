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

  static double _fitFs(
      String text, double availW, double maxFs, FontWeight fw) {
    if (text.isEmpty || availW <= 0) return maxFs;
    var lo = 2.0;
    var hi = maxFs;
    for (var i = 0; i < 12; i++) {
      final mid = (lo + hi) / 2;
      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(fontSize: mid, fontWeight: fw, height: 1.0),
        ),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: double.infinity);
      if (tp.width <= availW) {
        lo = mid;
      } else {
        hi = mid;
      }
    }
    return lo;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final pad = h * 0.04;
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

    final photoGap = hasPhoto ? cw * 0.02 : 0.0;

    double nameFs = 0, nameH = 0, subH = 0, subFs = 0;
    bool subInline = true;

    const subIndentFrac = 0.04;

    void computeSizes(double textW) {
      nameFs = 0; nameH = 0; subH = 0; subFs = 0;
      if (showName) {
        nameFs = _fitFs(nameText, textW, ch * 0.33, FontWeight.w800);
        nameH = nameFs * 1.22;
      }
      if (hasSub) {
        final subTextW = math.max(1.0, textW * (1 - subIndentFrac));
        if (subEntries.length == 1) {
          subFs = _fitFs(subEntries.first.value, subTextW, ch * 0.45, FontWeight.w600);
          subH = subFs * 1.32;
          subInline = true;
        } else {
          final inlineText = subEntries.map((e) => e.value).join('  •  ');
          final inlineFs = _fitFs(inlineText, subTextW, ch * 0.45, FontWeight.w600);
          if (inlineFs >= ch * 0.065) {
            subFs = inlineFs;
            subH = subFs * 1.32;
            subInline = true;
          } else {
            final widest = subEntries.map((e) => e.value)
                .reduce((a, b) => a.length > b.length ? a : b);
            subFs = _fitFs(widest, subTextW, ch * 0.40, FontWeight.w600);
            subH = subFs * 1.28 * subEntries.length;
            subInline = false;
          }
        }
      }
    }

    computeSizes(hasPhoto ? leftW * 0.63 : leftW);
    double identH = math.max(nameH + subH, hasPhoto ? ch * 0.40 : 0.0);

    if (hasPhoto) {
      final photoD1 = identH * 0.72;
      final textW2 = math.max(1.0, leftW - photoD1 - photoGap);
      computeSizes(textW2);
      identH = math.max(nameH + subH, ch * 0.40);
    }

    final hasIdentity = identH > 0;
    final divTh = math.max(1.0, ch * 0.012);
    final showDivider = hasIdentity && contactEntries.isNotEmpty;
    final divBlockH = showDivider ? ch * 0.05 : 0.0;

    final contactsH = ch - identH - divBlockH;
    final perContactH = contactEntries.isEmpty
        ? 0.0
        : math.min(contactsH / contactEntries.length, ch * 0.32);

    double contactFs = perContactH;
    if (contactEntries.isNotEmpty) {
      final widest = contactEntries
          .map((e) => e.value)
          .reduce((a, b) => a.length > b.length ? a : b);
      contactFs = _fitFs(widest, leftW, perContactH * 1.08, FontWeight.w500);
    }

    final photoD = hasPhoto ? identH * 0.72 : 0.0;
    final identTextW = leftW - photoD - photoGap;
    final subIndent = identTextW * subIndentFrac;
    final textTopPad = ((identH - nameH - subH) / 2).clamp(0.0, double.infinity);

    Widget buildSubtitle() {
      if (subInline) {
        return Padding(
          padding: EdgeInsets.only(left: subIndent),
          child: SizedBox(
          width: identTextW - subIndent,
          height: subH,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < subEntries.length; i++) ...[
                  if (i > 0)
                    Text('  •  ',
                        style: TextStyle(
                            fontSize: subFs,
                            fontWeight: FontWeight.w600,
                            height: 1.0,
                            color: colorBlack)),
                  _field(
                    context,
                    subEntries[i].key,
                    Text(subEntries[i].value,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            fontSize: subFs,
                            fontWeight: FontWeight.w600,
                            height: 1.0,
                            color: colorBlack)),
                  ),
                ],
              ],
            ),
          ),
          ),
        );
      } else {
        return Padding(
          padding: EdgeInsets.only(left: subIndent),
          child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final e in subEntries)
              SizedBox(
                width: identTextW - subIndent,
                height: subFs * 1.28,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _field(
                    context,
                    e.key,
                    Text(e.value,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                            fontSize: subFs,
                            fontWeight: FontWeight.w600,
                            height: 1.0,
                            color: colorBlack)),
                  ),
                ),
              ),
          ],
          ),
        );
      }
    }

    final identityLines = <Widget>[
      if (showName)
        SizedBox(
          width: identTextW,
          height: nameH,
          child: _field(
            context,
            'fullName',
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                nameText,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.clip,
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
      if (hasSub) buildSubtitle(),
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
                  child: Padding(
                    padding: EdgeInsets.only(top: textTopPad),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: identityLines,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (showDivider) ...[
          SizedBox(height: divBlockH * 0.35),
          Container(width: leftW, height: divTh, color: colorBlack),
          SizedBox(height: divBlockH * 0.40),
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
                child: Text(
                  entry.value,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
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
      ],
    );
  }

  Widget _buildRight(String qrData, double rightW, double ch) {
    final captionH = ch * 0.12;
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
            fit: BoxFit.contain,
            child: Text(
              data.isLinkQr
                  ? appLocalizations.contactScanMe
                  : appLocalizations.contactScanToSave,
              style: TextStyle(
                color: colorBlack,
                fontSize: captionH,
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
