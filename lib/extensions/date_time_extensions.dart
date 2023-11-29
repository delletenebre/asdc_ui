import 'dart:math';

import 'package:intl/intl.dart';

extension DateTimeFormatExtensions on DateTime? {
  static const dateFormat = 'yyyy-MM-dd';

  // String formatDateTime() {
  //   if (this == null) {
  //     return '';
  //   } else {
  //     return DateFormat('dd MMM yyyy г. (hh:mm)', 'ru').format(this!);
  //   }
  // }

  String format([String format = 'dd MMMM y', String locale = 'ru']) {
    if (this == null) {
      return '';
    } else {
      return DateFormat(format, locale).format(this!);
    }
  }

  // String yearsFromNow() {
  //   if (this == null) {
  //     return '';
  //   } else {
  //     final now = DateTime.now();
  //     final year = now.year - this!.year;
  //     final month = now.month - this!.month;
  //     if (month < 0) {
  //       /// negative month means it's still upcoming
  //       return '${year - 1}';
  //     } else {
  //       return '$year';
  //     }
  //   }
  // }

  DateTime? get startOfDay {
    if (this == null) {
      return null;
    } else {
      return DateTime(this!.year, this!.month, this!.day);
    }
  }

  DateTime? get endOfDay {
    if (this == null) {
      return null;
    } else {
      return DateTime(this!.year, this!.month, this!.day, 23, 59, 59);
    }
  }

  bool isAfterOrEqual(DateTime? other) {
    if (this == null || other == null) {
      return false;
    } else {
      return this!.compareTo(other) >= 0;
    }
  }

  bool isBeforeOrEqual(DateTime? other) {
    if (this == null || other == null) {
      return false;
    } else {
      return this!.compareTo(other) <= 0;
    }
  }
}

extension DateTimeManipulationsExtensions on DateTime {
  String format([String format = 'dd.MM.yyyy']) {
    return DateFormat(format).format(this);
  }

  /// добавляем год к текущей дате
  DateTime addYearLeapAware() {
    return add(Duration(days: isLeapYear() ? 366 : 365));
  }

  DateTime addDate({
    int years = 0,
    int months = 0,
    int days = 0,
  }) {
    DateTime date = add(Duration(
      days: days,
    ));
    date = date.addMonths(months);
    date = date.addMonths(years * 12);
    return date;
  }

  DateTime subDate({
    int years = 0,
    int months = 0,
    int days = 0,
  }) {
    DateTime date = subtract(Duration(
      days: days,
    ));
    date = date.addMonths(-months);
    date = date.addMonths(-years * 12);
    return date;
  }

  DateTime firstYearDay() {
    return DateTime(year, 1, 1);
  }

  DateTime lastYearDay() {
    return DateTime(year, 12, 31);
  }

  DateTime firstDay() {
    return DateTime(year, month, 1);
  }

  DateTime lastDay() {
    final date = addDate(months: 1);
    return DateTime(date.year, date.month, 0);
  }

  DateTime addMonths(int months) {
    final r = months % 12;
    final q = (months - r) ~/ 12;
    var newYear = year + q;
    var newMonth = month + r;
    if (newMonth > 12) {
      newYear++;
      newMonth -= 12;
    }
    final newDay = min(day, _daysInMonth(newYear, newMonth));
    if (isUtc) {
      return DateTime.utc(newYear, newMonth, newDay, hour, minute, second,
          millisecond, microsecond);
    } else {
      return DateTime(newYear, newMonth, newDay, hour, minute, second,
          millisecond, microsecond);
    }
  }

  int _daysInMonth(int year, int month) {
    int result = _daysInMonthArray[month];
    if (month == 2 && _isLeapYear(year)) {
      result++;
    }
    return result;
  }

  /// проверка високосный ли годs
  bool _isLeapYear(int year) =>
      (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));

  /// проверка високосный ли текщий год
  bool isLeapYear() {
    return _isLeapYear(year);
  }

  static const _daysInMonthArray = [
    0,
    31,
    28,
    31,
    30,
    31,
    30,
    31,
    31,
    30,
    31,
    30,
    31
  ];
}
