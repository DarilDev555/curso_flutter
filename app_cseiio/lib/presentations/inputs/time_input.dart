import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

// Define los errores de validación para horarios
enum TimeError { empty, invalid, duplicate }

// Clase para validar horarios usando TimeOfDay
class TimeInput extends FormzInput<TimeOfDay?, TimeError> {
  final List<TimeOfDay>? times;

  // Constructor para campo sin modificar
  const TimeInput.pure([super.value, this.times]) : super.pure();

  // Constructor para campo modificado
  const TimeInput.dirty([super.value, this.times]) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    switch (displayError) {
      case TimeError.empty:
        return 'El horario es requerido';
      case TimeError.invalid:
        return 'Horario inválido';
      case TimeError.duplicate:
        return 'Este horario ya existe';
      default:
        return null;
    }
  }

  @override
  TimeError? validator(TimeOfDay? value) {
    if (value == null) return TimeError.empty;

    // Validar duplicados
    if (times != null && times!.isNotEmpty) {
      final isDuplicate = times!.any(
        (existingTime) =>
            existingTime.hour == value.hour &&
            existingTime.minute == value.minute,
      );

      if (isDuplicate) return TimeError.duplicate;
    }

    // Validación adicional si necesitas rangos específicos
    // Ejemplo: validar que sea entre 8:00 y 20:00
    /*
    final totalMinutes = value.hour * 60 + value.minute;
    if (totalMinutes < 8*60 || totalMinutes > 20*60) {
      return TimeError.invalid;
    }
    */

    return null;
  }

  // Método útil para convertir de String a TimeOfDay
  static TimeOfDay? fromString(String time) {
    try {
      final parts = time.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } catch (e) {
      return null;
    }
  }

  // Método útil para formatear a String
  static String format(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  // Método auxiliar para obtener las horas existentes como lista de TimeOfDay
  static List<TimeOfDay> getExistingTimes(List<dynamic> existingItems) {
    return existingItems
        .where((item) => item?.timeAttendance?.value != null)
        .map((item) => item.timeAttendance.value as TimeOfDay)
        .toList();
  }
}
