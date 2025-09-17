import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HumanFormats {
  static String number(double number, [int decimals = 0]) {
    final formatterNumber = NumberFormat.compactCurrency(
      decimalDigits: decimals,
      symbol: '',
      locale: 'en',
    ).format(number);

    return formatterNumber;
  }

  static String formatDate(
    DateTime date, {
    bool nameDay = false,
    bool abreviado = false,
  }) {
    if (nameDay) {
      return abreviado == false
          ? DateFormat('EEEE dd-MM-yyyy ', 'es_ES').format(date).toUpperCase()
          : DateFormat(
            'EE dd/MM/yy ',
            'es_ES',
          ).format(date).toUpperCase(); // Español (España)
    }
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formatDateForSumitApi(DateTime datetime) {
    return DateFormat('yyyy-MM-dd').format(datetime);
  }

  static String formatDateWithNameDay(DateTime datetime) {
    return DateFormat.yMMMMEEEEd('es_ES').format(datetime);
  }

  static String formatTimeForSumitApi(DateTime datetime) {
    return DateFormat('Hm').format(datetime);
  }

  static String formatTimeAttendanceToSumit(TimeOfDay time) {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('yyyy-MM-dd hh:mm:ss').format(date);
  }

  static String formateHour(String? date) {
    if (date == null) return '--';
    return DateFormat('jm').format(DateTime.parse(date));
  }

  static String formateHourToTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final date = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    return DateFormat('jm').format(date);
  }

  static String timeStringToDateTimeFormat(String timeString) {
    final parts = timeString.split(':');
    final DateTime date = DateTime(
      DateTime.now().year, // Año actual (puedes usar cualquier año)
      DateTime.now().month, // Mes actual
      DateTime.now().day, // Día actual
      int.parse(parts[0]), // Horas
      int.parse(parts[1]), // Minutos
      parts.length > 2 ? int.parse(parts[2]) : 0, // Segundos (opcional)
    );

    return DateFormat('jm').format(date);
  }

  static String hourFormatToDatetime(DateTime dateTime, {bool list = true}) {
    return (list)
        ? '  ◉ ${DateFormat.yMMMMd().format(dateTime)} \n  ◉ ${DateFormat.jm().format(dateTime)}'
        : '${DateFormat.yMMMMd().format(dateTime)} ${DateFormat.jm().format(dateTime)}';
  }

  static String justhourFormatToDatetime(DateTime? dateTime) {
    if (dateTime != null) return DateFormat.jm().format(dateTime);
    return 'S/A';
  }
}
