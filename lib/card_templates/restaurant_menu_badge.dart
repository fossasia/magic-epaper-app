import 'dart:math' as math;

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:magicepaperapp/card_templates/restaurant_menu_model.dart';
import 'package:magicepaperapp/theme/colors.dart';

class RestaurantMenuBadge extends StatelessWidget {
  final RestaurantMenuModel menu;

  const RestaurantMenuBadge({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final h = c.maxHeight;
        final minSide = math.min(w, h);
        final pad = minSide * 0.05;
        final entries = menu.entries;

        return Container(
          width: w,
          height: h,
          color: colorWhite,
          padding: EdgeInsets.all(minSide * 0.03),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: colorBlack,
                width: math.max(1.5, minSide * 0.014),
              ),
              borderRadius: BorderRadius.circular(minSide * 0.05),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: pad,
              vertical: pad * 0.8,
            ),
            child: menu.style == MenuBoardStyle.scanToView
                ? _scanBoard(minSide)
                : _listBoard(h, entries, minSide),
          ),
        );
      },
    );
  }

  Widget _listBoard(double h, List<MenuEntry> entries, double minSide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        _header(h),
        SizedBox(height: h * 0.02),
        Expanded(
          child: entries.isEmpty ? _emptyHint(h) : _entryList(entries, minSide),
        ),
      ],
    );
  }

  Widget _scanBoard(double minSide) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final h = c.maxHeight;
        final meta = _metaLine();
        final titleFs = math.min(h * 0.26, minSide * 0.3);
        final qrSize = math.min(h * 0.86, w * 0.42);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.restaurant,
                          size: titleFs * 0.78, color: colorBlack),
                      SizedBox(width: titleFs * 0.26),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            menu.title,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: titleFs,
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
                  if (meta.isNotEmpty) ...[
                    SizedBox(height: h * 0.03),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        meta,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: h * 0.09,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: colorBlack,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: w * 0.04),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: qrSize,
                  height: qrSize,
                  child: _qrCode(qrSize),
                ),
                SizedBox(height: h * 0.04),
                SizedBox(
                  width: qrSize,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'SCAN TO VIEW MENU',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: h * 0.08,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        color: colorBlack,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
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
    final meta = _metaLine();
    final titleFs = h * 0.15;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
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
        if (meta.isNotEmpty) ...[
          SizedBox(height: h * 0.008),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              meta,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: h * 0.062,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: colorBlack,
                height: 1.0,
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _metaLine() {
    final subtitle = menu.subtitle.trim();
    final date = menu.dateLabel.trim();
    if (subtitle.isNotEmpty && date.isNotEmpty) return '$subtitle   ·   $date';
    return subtitle.isNotEmpty ? subtitle : date;
  }

  Widget _entryList(List<MenuEntry> entries, double minSide) {
    const headingWeight = 0.5;
    return LayoutBuilder(
      builder: (context, c) {
        var totalWeight = 0.0;
        for (final e in entries) {
          totalWeight += e.isHeading ? headingWeight : 1.0;
        }
        if (totalWeight <= 0) totalWeight = 1;
        final unit = c.maxHeight / totalWeight;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final e in entries)
              if (e.isHeading)
                SizedBox(
                  height: unit * headingWeight,
                  child: _sectionHeading(
                      e.heading!, unit * headingWeight, minSide),
                )
              else
                SizedBox(
                  height: unit,
                  child: _itemRow(e.item!, unit, minSide),
                ),
          ],
        );
      },
    );
  }

  Widget _sectionHeading(String text, double h, double minSide) {
    final fs = math.min(h * 0.66, minSide * 0.1);
    return Padding(
      padding: EdgeInsets.only(top: h * 0.12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              text.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: fs,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: colorBlack,
                height: 1.0,
              ),
            ),
          ),
          SizedBox(width: fs * 0.5),
          Expanded(
            child: Container(
              height: math.max(0.8, fs * 0.08),
              color: colorBlack,
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemRow(MenuItem item, double itemH, double minSide) {
    final hasPrice = item.price.trim().isNotEmpty;
    final nameFs = math.min(itemH * 0.66, minSide * 0.22);
    final markSize = nameFs * 0.88;

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
            child: Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(
                fontSize: nameFs,
                fontWeight: FontWeight.w700,
                color: colorBlack,
                height: 1.0,
              ),
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
