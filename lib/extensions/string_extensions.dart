import 'dart:convert';
import 'dart:math';

import 'package:intl/intl.dart';

extension StringExtensions on String? {
  static String generateString(int length) {
    final random = Random.secure();
    final values = List<int>.generate(length, (i) => random.nextInt(255));
    return base64Url.encode(values);
  }

  String generateLogin() {
    /// генерируем строку случайных символов
    final string = generateString(6);

    if (this == null || this!.isEmpty) {
      return string;
    } else {
      return '$this-$string';
    }
  }

  String generatePassword() {
    /// генерируем строку случайных символов
    return generateString(12);
  }

  static const inFormat = 'yyyy-MM-dd';
  static const outFormat = 'dd.MM.yyyy';

  DateTime? toDate([String? dateFormat]) {
    if (dateFormat != null) {
      try {
        return DateFormat(dateFormat).parse(this ?? '');
      } catch (exception) {
        return null;
      }
    }

    return DateTime.tryParse(this ?? '');
  }

  String formatDate(
      {String? inputDateFormat, String outputDateFormat = outFormat}) {
    if (isDate(inputDateFormat)) {
      return DateFormat(outputDateFormat).format(toDate(inputDateFormat)!);
    }

    return '';
  }

  String fullDate() {
    if (isDate()) {
      return DateFormat('dd MMM yyyy').format(toDate()!);
    }

    return '';
  }

  bool isDate([String? dateFormat]) {
    return toDate(dateFormat) != null;
  }

  String formatHumanDate([String locale = 'ru']) {
    if (isDate()) {
      return DateFormat('dd MMM yyyy', locale).format(toDate()!);
    }

    return '';
  }

  String formatFullHumanDate([String locale = 'ru']) {
    if (isDate()) {
      return DateFormat('dd MMMM yyyy', locale).format(toDate()!);
    }

    return '';
  }

  String formatDateTime() {
    if (isDate()) {
      return DateFormat('dd MMM yyyy г. (hh:mm)', 'ru').format(toDate()!);
    }

    return '';
  }

  String emptyValue(String value) {
    if (this == null || this!.isEmpty) {
      return value;
    }

    return this!;
  }
}
