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

  static String formateHour(String? date) {
    if (date == null) return '--';
    return DateFormat('jm').format(DateTime.parse(date));
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
}
