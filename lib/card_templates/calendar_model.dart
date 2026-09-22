enum CalendarView { month, week, day }

class CalendarModel {
  final DateTime anchor;
  final DateTime today;
  final bool weekStartsMonday;
  final CalendarView view;

  CalendarModel({
    required this.anchor,
    required this.today,
    this.weekStartsMonday = false,
    this.view = CalendarView.month,
  });

  int get year => anchor.year;
  int get month => anchor.month;

  DateTime get firstOfMonth => DateTime(anchor.year, anchor.month, 1);

  int get daysInMonth => DateTime(anchor.year, anchor.month + 1, 0).day;

  int get leadingBlanks {
    final firstWeekday = firstOfMonth.weekday;
    return weekStartsMonday ? firstWeekday - 1 : firstWeekday % 7;
  }

  int get weekCount => ((leadingBlanks + daysInMonth) / 7).ceil();

  List<int?> get monthCells {
    final cells = <int?>[];
    for (var i = 0; i < leadingBlanks; i++) {
      cells.add(null);
    }
    for (var day = 1; day <= daysInMonth; day++) {
      cells.add(day);
    }
    while (cells.length < weekCount * 7) {
      cells.add(null);
    }
    return cells;
  }

  List<int> get weekdayOrder => weekStartsMonday
      ? const [1, 2, 3, 4, 5, 6, 7]
      : const [7, 1, 2, 3, 4, 5, 6];

  DateTime get weekStart {
    final weekday = anchor.weekday;
    final offset = weekStartsMonday ? weekday - 1 : weekday % 7;
    return DateTime(anchor.year, anchor.month, anchor.day - offset);
  }

  List<DateTime> get weekDays {
    final start = weekStart;
    return List<DateTime>.generate(
      7,
      (i) => DateTime(start.year, start.month, start.day + i),
    );
  }

  int get dayOfYear =>
      DateTime(anchor.year, anchor.month, anchor.day)
          .difference(DateTime(anchor.year, 1, 1))
          .inDays +
      1;

  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool isSelectedDate(DateTime date) => isSameDay(date, anchor);

  bool isSelectedDay(int day) => day == anchor.day;

  bool get isOnToday => isSameDay(anchor, today);

  CalendarModel copyWith({
    DateTime? anchor,
    bool? weekStartsMonday,
    CalendarView? view,
  }) {
    return CalendarModel(
      anchor: anchor ?? this.anchor,
      today: today,
      weekStartsMonday: weekStartsMonday ?? this.weekStartsMonday,
      view: view ?? this.view,
    );
  }

  DateTime step(int direction) {
    switch (view) {
      case CalendarView.month:
        final lastDay =
            DateTime(anchor.year, anchor.month + direction + 1, 0).day;
        final day = anchor.day < lastDay ? anchor.day : lastDay;
        return DateTime(anchor.year, anchor.month + direction, day);
      case CalendarView.week:
        return DateTime(anchor.year, anchor.month, anchor.day + 7 * direction);
      case CalendarView.day:
        return DateTime(anchor.year, anchor.month, anchor.day + direction);
    }
  }
}
