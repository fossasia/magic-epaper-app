import 'dart:math' as math;
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:magicepaperapp/card_templates/qr_tag_model.dart';
import 'package:magicepaperapp/l10n/app_localizations.dart';
import 'package:magicepaperapp/provider/getitlocator.dart';
import 'package:magicepaperapp/theme/colors.dart';

AppLocalizations get appLocalizations => getIt.get<AppLocalizations>();

class QrTagBadge extends StatelessWidget {
  final QrTagModel data;
  final bool isPreview;

  const QrTagBadge({super.key, required this.data, this.isPreview = false});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final h = c.maxHeight;
        final pad = math.min(w, h) * 0.08;
        final cw = w - 2 * pad;
        final ch = h - 2 * pad;
        final landscape = w >= h * 1.15;

        final icon = qrTagIconFor(data.iconKey);
        final captionFilled = data.caption.trim().isNotEmpty;
        final showCaption = captionFilled || isPreview;
        final captionText = captionFilled
            ? data.caption.trim()
            : appLocalizations.qrCaptionHint;
        final hasExtras = icon != null || showCaption;

        Widget body;
        if (!hasExtras) {
          body = Center(child: _qr(math.min(cw, ch)));
        } else if (landscape) {
          body =
              _landscape(cw, ch, icon, showCaption, captionFilled, captionText);
        } else {
          body =
              _portrait(cw, ch, icon, showCaption, captionFilled, captionText);
        }

        return Container(
          width: w,
          height: h,
          color: colorWhite,
          padding: EdgeInsets.all(pad),
          child: body,
        );
      },
    );
  }

  Widget _qr(double side) {
    final hasData = data.qrData.trim().isNotEmpty;
    if (!hasData) {
      return SizedBox(
        width: side,
        height: side,
        child: Icon(Icons.qr_code_2, size: side * 0.7, color: grey400),
      );
    }
    return SizedBox(
      width: side,
      height: side,
      child: BarcodeWidget(
        barcode: Barcode.qrCode(),
        data: data.qrData,
        color: colorBlack,
        backgroundColor: colorWhite,
        padding: EdgeInsets.all(side * 0.06),
        drawText: false,
        errorBuilder: (context, error) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _landscape(double cw, double ch, IconData? icon, bool showCaption,
      bool captionFilled, String captionText) {
    final qrSide = ch;
    final gap = cw * 0.05;
    final rightW = math.max(0.0, cw - qrSide - gap);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _qr(qrSide),
        SizedBox(width: gap),
        SizedBox(
          width: rightW,
          height: ch,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: ch * 0.3, color: colorBlack),
                SizedBox(height: ch * 0.06),
              ],
              if (showCaption)
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      captionText,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: ch * 0.16,
                        height: 1.1,
                        fontWeight: FontWeight.w700,
                        color: captionFilled ? colorBlack : grey400,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _portrait(double cw, double ch, IconData? icon, bool showCaption,
      bool captionFilled, String captionText) {
    final captionH = showCaption ? ch * 0.16 : 0.0;
    final iconH = icon != null ? ch * 0.16 : 0.0;
    final gaps = ch * 0.05;
    var qrSide = ch - captionH - iconH - gaps * 2;
    if (qrSide > cw) qrSide = cw;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: iconH, color: colorBlack),
          SizedBox(height: gaps),
        ],
        _qr(qrSide),
        if (showCaption) ...[
          SizedBox(height: gaps),
          SizedBox(
            width: cw,
            height: captionH,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                captionText,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: captionFilled ? colorBlack : grey400,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
