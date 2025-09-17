import 'package:formz/formz.dart';

import '../../config/helpers/human_formats.dart';

// Define los errores de validación
enum DateTimeInputError { empty, isTooEarly, isTooLate }

// Clase para validar nombres
class DateTimeInput extends FormzInput<DateTime?, DateTimeInputError> {
  final DateTime? timeBefor;
  final DateTime? timeAfter;

  // Representa un campo sin modificar
  const DateTimeInput.pure({this.timeAfter, this.timeBefor}) : super.pure(null);

  // Representa un campo modificado
  const DateTimeInput.dirty(super.value, {this.timeBefor, this.timeAfter})
    : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == DateTimeInputError.empty) {
      return 'El campo es requerido';
    }
    if (displayError == DateTimeInputError.isTooEarly) {
      return '"Por favor, selecciona una hora después de ${HumanFormats.justhourFormatToDatetime(timeBefor)}"';
    }
    if (displayError == DateTimeInputError.isTooLate) {
      return '"Por favor, selecciona una hora antes de ${HumanFormats.justhourFormatToDatetime(timeAfter)}"';
    }
    // if (displayError == DaysEventError.format) {
    //   return 'Solo puede contener letras y espacios';
    // }

    return null;
  }

  @override
  DateTimeInputError? validator(DateTime? value) {
    if (value == null) return DateTimeInputError.empty;
    if (timeBefor != null && value.isBefore(timeBefor!)) {
      return DateTimeInputError.isTooEarly;
    }
    if (timeAfter != null && value.isAfter(timeAfter!)) {
      return DateTimeInputError.isTooLate;
    }
    // if (!nameRegExp.hasMatch(value)) return DaysEventError.format;

    return null;
  }
}
