import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:magicepaperapp/card_templates/calendar_model.dart';
import 'package:magicepaperapp/theme/colors.dart';

class CalendarCardWidget extends StatelessWidget {
  final CalendarModel data;
  final Color ink;
  final Color background;
  final Color highlight;
  final String? localeName;
  final String? dayFooter;

  const CalendarCardWidget({
    super.key,
    required this.data,
    this.ink = colorBlack,
    this.background = colorWhite,
    this.highlight = colorBlack,
    this.localeName,
    this.dayFooter,
  });

  @override
  Widget build(BuildContext context) {
    final locale =
        localeName ?? Localizations.maybeLocaleOf(context)?.toString();
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        Widget child;
        switch (data.view) {
          case CalendarView.month:
            child = _buildMonth(w, h, locale);
            break;
          case CalendarView.week:
            child = _buildWeek(w, h, locale);
            break;
          case CalendarView.day:
            child = _buildDay(w, h, locale);
            break;
        }
        return Container(width: w, height: h, color: background, child: child);
      },
    );
  }

  Widget _buildMonth(double w, double h, String? locale) {
    final title = toBeginningOfSentenceCase(
      DateFormat.yMMMM(locale).format(data.firstOfMonth),
    );
    final cells = data.monthCells;
    final weeks = data.weekCount;

    const dividerH = 1.0;
    final titleH = h * 0.18;
    final weekdayH = h * 0.12;
    final gridH = h - titleH - weekdayH - dividerH;
    final rowH = gridH / weeks;
    final cellW = w / 7;
    final minSide = rowH < cellW ? rowH : cellW;

    final titleFont = (titleH * 0.58).clamp(8.0, 48.0);
    final weekdayFont = (weekdayH * 0.72).clamp(5.0, 24.0);
    final dayFont = (minSide * 0.54).clamp(6.0, 40.0);
    final ring = minSide * 0.98;
    final ringWidth = (ring * 0.09).clamp(1.5, 4.0);

    return Column(
      children: [
        SizedBox(
          height: titleH,
          child: Center(child: _text(title, titleFont, bold: true)),
        ),
        SizedBox(
          height: weekdayH,
          child: Row(
            children: [
              for (final weekday in data.weekdayOrder)
                Expanded(
                  child: Center(
                    child: _text(
                      _weekdayLabel(weekday, locale, 3),
                      weekdayFont,
                      bold: true,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Container(height: dividerH, color: ink),
        Expanded(
          child: Column(
            children: [
              for (var week = 0; week < weeks; week++)
                Expanded(
                  child: Row(
                    children: [
                      for (var col = 0; col < 7; col++)
                        Expanded(
                          child: _monthCell(
                            cells[week * 7 + col],
                            ring,
                            ringWidth,
                            dayFont,
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _monthCell(int? day, double ring, double ringWidth, double dayFont) {
    if (day == null) return const SizedBox.shrink();
    final selected = data.isSelectedDay(day);
    final label = _text('$day', dayFont, bold: true);
    if (!selected) return Center(child: label);
    return Center(child: _ring(ring, ringWidth, label));
  }

  Widget _buildWeek(double w, double h, String? locale) {
    final days = data.weekDays;
    final title = _weekRangeLabel(days.first, days.last, locale);

    const dividerH = 1.0;
    final titleH = h * 0.2;
    final bodyH = h - titleH - dividerH;
    final cellW = w / 7;
    final minSide = bodyH < cellW ? bodyH : cellW;

    final titleFont = (titleH * 0.5).clamp(8.0, 40.0);
    final labelFont = (bodyH * 0.16).clamp(5.0, 20.0);
    final numFont = (minSide * 0.42).clamp(8.0, 48.0);
    final ring = (minSide * 0.62).clamp(14.0, 96.0);
    final ringWidth = (ring * 0.09).clamp(1.5, 4.0);

    return Column(
      children: [
        SizedBox(
          height: titleH,
          child: Center(child: _text(title, titleFont, bold: true)),
        ),
        Container(height: dividerH, color: ink),
        Expanded(
          child: Row(
            children: [
              for (final date in days)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _text(
                        DateFormat.E(locale).format(date).length > 3
                            ? DateFormat.E(locale).format(date).substring(0, 3)
                            : DateFormat.E(locale).format(date),
                        labelFont,
                        bold: true,
                      ),
                      SizedBox(height: bodyH * 0.06),
                      data.isSelectedDate(date)
                          ? _ring(ring, ringWidth,
                              _text('${date.day}', numFont, bold: true))
                          : _text('${date.day}', numFont, bold: true),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDay(double w, double h, String? locale) {
    final date = data.anchor;
    final weekday = DateFormat.EEEE(locale).format(date).toUpperCase();
    final monthYear = toBeginningOfSentenceCase(
      DateFormat.yMMMM(locale).format(date),
    );

    final weekdayFont = (h * 0.14).clamp(8.0, 34.0);
    final numFont = (h * 0.5).clamp(20.0, 200.0);
    final monthFont = (h * 0.13).clamp(8.0, 32.0);
    final footerFont = (h * 0.09).clamp(6.0, 22.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.06),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _text(weekday, weekdayFont, bold: true, spacing: 2),
          Expanded(
            child: FittedBox(
              fit: BoxFit.contain,
              child: _text('${date.day}', numFont, bold: true),
            ),
          ),
          _text(monthYear, monthFont, bold: true),
          SizedBox(height: h * 0.03),
          _text(dayFooter ?? _fallbackFooter(date), footerFont),
        ],
      ),
    );
  }

  String _fallbackFooter(DateTime date) {
    final dayOfYear = DateTime(date.year, date.month, date.day)
            .difference(DateTime(date.year, 1, 1))
            .inDays +
        1;
    return 'Day $dayOfYear of ${date.year}';
  }

  Widget _ring(double size, double width, Widget child) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: highlight, width: width),
      ),
      child: child,
    );
  }

  Widget _text(String value, double size,
      {bool bold = false, double spacing = 0}) {
    return Text(
      value,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: size,
        fontWeight: bold ? FontWeight.bold : FontWeight.w500,
        color: ink,
        letterSpacing: spacing,
      ),
    );
  }

  String _weekdayLabel(int weekday, String? locale, int maxLen) {
    final reference = DateTime(2024, 1, weekday);
    final label = DateFormat.E(locale).format(reference);
    return label.length > maxLen ? label.substring(0, maxLen) : label;
  }

  String _weekRangeLabel(DateTime start, DateTime end, String? locale) {
    final startStr = DateFormat.MMMd(locale).format(start);
    if (start.month == end.month) {
      return '$startStr – ${end.day}, ${end.year}';
    }
    final endStr = DateFormat.MMMd(locale).format(end);
    return '$startStr – $endStr, ${end.year}';
  }
}
