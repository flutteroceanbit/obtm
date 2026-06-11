import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'logger.dart';

class DateFormatter {
  static String formateDate({
    String outputFormatter =
        "MM/dd/yyyy HH:mm:ss", //change "MM/dd/yyy hh:mm a" to "MM/dd/yyyy HH:mm:ss"
    required String inputFormatter,
    required input,
  }) {
    Logger.println(
        "DATE_FORMATTER: formateDate: outputFormatter: $outputFormatter");
    Logger.println(
        "DATE_FORMATTER: formateDate: inputFormatter: $inputFormatter");
    Logger.println("DATE_FORMATTER: formateDate: input: $input");

    var inputFormat = DateFormat(inputFormatter);
    var inputDate = inputFormat.parse(input); // <-- dd/MM 24H format

    var outputFormat = DateFormat(outputFormatter);
    return outputFormat.format(inputDate);
  }

  static DateTime dateFromString({
    required String inputFormatter,
    required input,
  }) {
    Logger.println(
        "DATE_FORMATTER: dateFromString: inputFormatter: $inputFormatter");
    Logger.println("DATE_FORMATTER: dateFromString: input: $input");
    var inputFormat = DateFormat(inputFormatter);
    return inputFormat.parse(input); // <-- dd/MM 24H format
  }

  static DateTime timeFromString({
    required String inputFormatter,
    required input,
  }) {
    Logger.println(
        "DATE_FORMATTER: timeFromString: inputFormatter: $inputFormatter");
    Logger.println("DATE_FORMATTER: timeFromString: input: $input");
    var inputFormat = DateFormat(inputFormatter);
    return inputFormat.parse(
        '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}$input');
  }
}

extension DateTimeExtension on DateTime {
  DateTime get firstDayOfWeek => subtract(Duration(days: weekday - 1));

  DateTime get lastDayOfWeek =>
      add(Duration(days: DateTime.daysPerWeek - weekday));

  DateTime get lastDayOfMonth =>
      month < 12 ? DateTime(year, month + 1, 0) : DateTime(year + 1, 1, 0);

  int compareJustDateTo(DateTime other) {
    if (year < other.year) return -1;
    if (year > other.year) return 1;
    if (month < other.month) return -1;
    if (month > other.month) return 1;
    if (day < other.day) return -1;
    if (day > other.day) return 1;
    return 0;
  }
}

extension TimeOfDayExtension on TimeOfDay {
  int compareTo(TimeOfDay other) {
    if (hour < other.hour) return -1;
    if (hour > other.hour) return 1;
    if (minute < other.minute) return -1;
    if (minute > other.minute) return 1;
    return 0;
  }
}
