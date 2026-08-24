import 'dart:math' as math;

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:magicepaperapp/card_templates/restaurant_menu_model.dart';
import 'package:magicepaperapp/theme/colors.dart';

TextStyle menuFont(String? family, TextStyle base) =>
    (family == null || family.isEmpty)
        ? base
        : GoogleFonts.getFont(family, textStyle: base);

class RestaurantMenuBadge extends StatelessWidget {
  final RestaurantMenuModel menu;

  const RestaurantMenuBadge({super.key, required this.menu});

  String? get _font => menu.fontFamily.isEmpty ? null : menu.fontFamily;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: menuFont(_font, const TextStyle()),
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth;
          final h = c.maxHeight;
          final minSide = math.min(w, h);
          final pad = minSide * 0.05;
          final items = menu.visibleItems;

          return Container(
            width: w,
            height: h,
            color: colorWhite,
            padding: EdgeInsets.symmetric(
              horizontal: pad,
              vertical: pad * 0.8,
            ),
            child: menu.style == MenuBoardStyle.scanToView
                ? _scanBoard(minSide)
                : _listBoard(h, items, minSide),
          );
        },
      ),
    );
  }

  Widget _listBoard(double h, List<MenuItem> items, double minSide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        _header(h),
        SizedBox(height: h * 0.014),
        _rule(minSide),
        SizedBox(height: h * 0.02),
        Expanded(
          child: items.isEmpty ? _emptyHint(h) : _itemList(items, minSide),
        ),
      ],
    );
  }

  Widget _rule(double minSide) {
    return Container(
      height: math.max(0.8, minSide * 0.009),
      color: colorBlack,
    );
  }

  Widget _scanBoard(double minSide) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final h = c.maxHeight;
        final portrait = h > w * 1.15;
        return portrait
            ? _scanPortrait(w, h, minSide)
            : _scanLandscape(w, h, minSide);
      },
    );
  }

  Widget _scanLandscape(double w, double h, double minSide) {
    final nameFs = math.min(h * 0.26, minSide * 0.3);
    final qrSize = math.min(h * 0.72, w * 0.4);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: _scanInfo(
            nameFs: nameFs,
            taglineFs: h * 0.09,
            centered: false,
          ),
        ),
        SizedBox(width: w * 0.03),
        Container(
          width: math.max(0.8, minSide * 0.008),
          height: h * 0.72,
          color: colorBlack,
        ),
        SizedBox(width: w * 0.03),
        _scanQr(qrSize: qrSize, captionFs: h * 0.08, gap: h * 0.035),
      ],
    );
  }

  Widget _scanPortrait(double w, double h, double minSide) {
    final nameFs = math.min(w * 0.15, h * 0.11);
    final qrSize = math.min(w * 0.62, h * 0.4);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _scanInfo(
          nameFs: nameFs,
          taglineFs: w * 0.06,
          centered: true,
        ),
        SizedBox(height: h * 0.05),
        _scanQr(qrSize: qrSize, captionFs: w * 0.058, gap: h * 0.02),
      ],
    );
  }

  Widget _scanInfo({
    required double nameFs,
    required double taglineFs,
    required bool centered,
  }) {
    final tagline = menu.subtitle.trim();
    final align = centered ? Alignment.center : Alignment.centerLeft;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
              centered ? MainAxisAlignment.center : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.restaurant, size: nameFs * 0.76, color: colorBlack),
            SizedBox(width: nameFs * 0.24),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: align,
                child: Text(
                  menu.title,
                  maxLines: 2,
                  textAlign: centered ? TextAlign.center : TextAlign.left,
                  style: TextStyle(
                    fontSize: nameFs,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.3,
                    color: colorBlack,
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (tagline.isNotEmpty) ...[
          SizedBox(height: nameFs * 0.2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: align,
            child: Text(
              tagline,
              maxLines: 1,
              style: TextStyle(
                fontSize: taglineFs,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
                color: colorBlack,
                height: 1.0,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _scanQr({
    required double qrSize,
    required double captionFs,
    required double gap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(qrSize * 0.06),
          decoration: BoxDecoration(
            color: colorWhite,
            border: Border.all(
              color: colorBlack,
              width: math.max(1.2, qrSize * 0.02),
            ),
            borderRadius: BorderRadius.circular(qrSize * 0.08),
          ),
          child: SizedBox(
            width: qrSize,
            height: qrSize,
            child: _qrCode(qrSize),
          ),
        ),
        SizedBox(height: gap),
        SizedBox(
          width: qrSize * 1.25,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'SCAN FOR FULL MENU',
              maxLines: 1,
              style: TextStyle(
                fontSize: captionFs,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
                color: colorBlack,
                height: 1.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _qrCode(double size) {
    final url = menu.menuUrl.trim();
    if (url.isEmpty) return _qrPlaceholder(size);
    return BarcodeWidget(
      barcode: Barcode.qrCode(),
      data: url,
      color: colorBlack,
      backgroundColor: colorWhite,
      drawText: false,
      padding: EdgeInsets.zero,
      errorBuilder: (context, error) => _qrPlaceholder(size),
    );
  }

  Widget _qrPlaceholder(double size) {
    return Container(
      decoration: BoxDecoration(
        border:
            Border.all(color: colorBlack, width: math.max(1.0, size * 0.02)),
        borderRadius: BorderRadius.circular(size * 0.06),
      ),
      child: Center(
        child: Icon(Icons.qr_code_2, size: size * 0.7, color: colorBlack),
      ),
    );
  }

  Widget _header(double h) {
    final subtitle = menu.subtitle.trim();
    final date = menu.dateLabel.trim();
    final eyebrow = date.isEmpty
        ? "TODAY'S SPECIAL"
        : "TODAY'S SPECIAL   ·   ${date.toUpperCase()}";
    final titleFs = h * 0.16;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            eyebrow,
            maxLines: 1,
            style: TextStyle(
              fontSize: h * 0.085,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
              color: colorBlack,
              height: 1.0,
            ),
          ),
        ),
        SizedBox(height: h * 0.012),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.restaurant, size: titleFs * 0.72, color: colorBlack),
            SizedBox(width: titleFs * 0.3),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  menu.title,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: titleFs,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: colorBlack,
                    height: 1.0,
                  ),
                ),
              ),
            ),
            SizedBox(width: titleFs * 0.3),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: Icon(Icons.restaurant,
                  size: titleFs * 0.72, color: colorBlack),
            ),
          ],
        ),
        if (subtitle.isNotEmpty) ...[
          SizedBox(height: h * 0.012),
          _metaText(subtitle, h * 0.088, FontWeight.w700),
        ],
      ],
    );
  }

  Widget _metaText(String text, double fs, FontWeight weight) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        maxLines: 1,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fs,
          fontWeight: weight,
          letterSpacing: 0.3,
          color: colorBlack,
          height: 1.0,
        ),
      ),
    );
  }

  Widget _itemList(List<MenuItem> items, double minSide) {
    return LayoutBuilder(
      builder: (context, c) {
        final unit = c.maxHeight / (items.isEmpty ? 1 : items.length);
        final rows = <Widget>[];
        var prevCat = '';
        for (final item in items) {
          final cat = item.category.trim();
          final showCat = cat.isNotEmpty && cat != prevCat;
          prevCat = cat;
          rows.add(SizedBox(
            height: unit,
            child: _itemRow(item, unit, minSide, showCategory: showCat),
          ));
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: rows,
        );
      },
    );
  }

  Widget _itemRow(MenuItem item, double itemH, double minSide,
      {bool showCategory = false}) {
    final hasPrice = item.price.trim().isNotEmpty;
    final nameFs = math.min(itemH * 0.58, minSide * 0.2);
    final markSize = nameFs * 0.88;
    final category = item.category.trim();

    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (item.isSpecial) ...[
            Icon(Icons.star, size: nameFs * 0.95, color: colorBlack),
            SizedBox(width: nameFs * 0.16),
          ],
          if (item.foodType != FoodType.none) ...[
            _FoodTypeMark(type: item.foodType, size: markSize),
            SizedBox(width: nameFs * 0.26),
          ],
          Expanded(
            flex: 5,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: item.name,
                    style: TextStyle(
                      fontSize: nameFs,
                      fontWeight: FontWeight.w700,
                      color: colorBlack,
                      height: 1.0,
                    ),
                  ),
                  if (showCategory && category.isNotEmpty)
                    TextSpan(
                      text: '  ($category)',
                      style: TextStyle(
                        fontSize: nameFs * 0.6,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: colorBlack,
                        height: 1.0,
                      ),
                    ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
          if (hasPrice) ...[
            SizedBox(width: nameFs * 0.5),
            Flexible(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${menu.currency}${item.price}',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: nameFs,
                      fontWeight: FontWeight.w800,
                      color: colorBlack,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _emptyHint(double h) {
    return Center(
      child: Text(
        '—',
        style: TextStyle(fontSize: h * 0.2, color: colorBlack),
      ),
    );
  }
}

class _FoodTypeMark extends StatelessWidget {
  final FoodType type;
  final double size;

  const _FoodTypeMark({required this.type, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _FoodTypeMarkPainter(type: type)),
    );
  }
}

class _FoodTypeMarkPainter extends CustomPainter {
  final FoodType type;

  _FoodTypeMarkPainter({required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final stroke = math.max(0.9, s * 0.09);
    final border = Paint()
      ..color = colorBlack
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    final fill = Paint()
      ..color = colorBlack
      ..style = PaintingStyle.fill;

    final inset = stroke / 2;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(inset, inset, s - stroke, s - stroke),
      Radius.circular(s * 0.14),
    );
    canvas.drawRRect(rect, border);

    final center = Offset(s / 2, s / 2);
    final glyph = s * 0.30;
    switch (type) {
      case FoodType.none:
        break;
      case FoodType.veg:
        canvas.drawCircle(center, glyph, fill);
        break;
      case FoodType.egg:
        final ring = Paint()
          ..color = colorBlack
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(0.8, s * 0.08);
        canvas.drawCircle(center, glyph, ring);
        break;
      case FoodType.nonVeg:
        final path = Path()
          ..moveTo(center.dx, center.dy - glyph)
          ..lineTo(center.dx + glyph, center.dy + glyph)
          ..lineTo(center.dx - glyph, center.dy + glyph)
          ..close();
        canvas.drawPath(path, fill);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _FoodTypeMarkPainter oldDelegate) =>
      oldDelegate.type != type;
}
