import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magicepaperapp/card_templates/calendar_card_widget.dart';
import 'package:magicepaperapp/card_templates/calendar_model.dart';

void main() {
  final today = DateTime(2024, 2, 15);
  CalendarModel model({
    DateTime? anchor,
    bool weekStartsMonday = false,
    CalendarView view = CalendarView.month,
  }) =>
      CalendarModel(
        anchor: anchor ?? DateTime(2024, 2, 15),
        today: today,
        weekStartsMonday: weekStartsMonday,
        view: view,
      );

  group('CalendarModel month', () {
    test('reports the right number of days', () {
      expect(model().daysInMonth, 29);
    });

    test('lays out a Sunday-first grid with correct leading blanks', () {
      final cells = model().monthCells;
      expect(model().weekCount, 5);
      expect(cells, hasLength(35));
      expect(cells[3], isNull);
      expect(cells[4], 1);
      expect(cells.where((c) => c != null), hasLength(29));
      expect(model().weekdayOrder.first, 7);
    });

    test('lays out a Monday-first grid with correct leading blanks', () {
      final m = model(weekStartsMonday: true);
      final cells = m.monthCells;
      expect(m.weekCount, 5);
      expect(cells[2], isNull);
      expect(cells[3], 1);
      expect(m.weekdayOrder.first, 1);
    });

    test('marks the selected day in the month', () {
      expect(model().isSelectedDay(15), isTrue);
      expect(model().isSelectedDay(14), isFalse);
      expect(model().isOnToday, isTrue);
      expect(model(anchor: DateTime(2024, 2, 20)).isSelectedDay(20), isTrue);
      expect(model(anchor: DateTime(2024, 3, 1)).isOnToday, isFalse);
    });
  });

  group('CalendarModel week', () {
    test('week contains 7 days including the selected date', () {
      final m = model(view: CalendarView.week);
      final days = m.weekDays;
      expect(days, hasLength(7));
      expect(days.any((d) => m.isSelectedDate(d)), isTrue);
      expect(days.first, DateTime(2024, 2, 11));
      expect(days.last, DateTime(2024, 2, 17));
    });
  });

  group('CalendarModel navigation', () {
    test('steps by month/week/day and keeps the day for months', () {
      expect(model(view: CalendarView.month).step(1), DateTime(2024, 3, 15));
      expect(model(view: CalendarView.month).step(-1), DateTime(2024, 1, 15));
      expect(
          model(anchor: DateTime(2024, 1, 31), view: CalendarView.month)
              .step(1),
          DateTime(2024, 2, 29));
      expect(model(view: CalendarView.week).step(1), DateTime(2024, 2, 22));
      expect(model(view: CalendarView.day).step(1), DateTime(2024, 2, 16));
      expect(
          model(anchor: DateTime(2024, 12, 31), view: CalendarView.day).step(1),
          DateTime(2025, 1, 1));
    });
  });

  group('CalendarCardWidget renders without overflow', () {
    Future<void> pumpView(WidgetTester tester, CalendarView view) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 296,
                height: 128,
                child: CalendarCardWidget(data: model(view: view)),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }

    testWidgets('month view', (t) => pumpView(t, CalendarView.month));
    testWidgets('week view', (t) => pumpView(t, CalendarView.week));
    testWidgets('day view', (t) => pumpView(t, CalendarView.day));
  });
}
