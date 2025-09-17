import 'package:formz/formz.dart';

// Define los errores de validación
enum DaysEventError { empty, length }

// Clase para validar nombres
class DaysEvent extends FormzInput<List<DateTime>, DaysEventError> {
  static final RegExp nameRegExp = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$");

  // Representa un campo sin modificar
  const DaysEvent.pure([List<DateTime>? dates]) : super.pure(dates ?? const []);

  // Representa un campo modificado
  const DaysEvent.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == DaysEventError.empty) return 'El campo es requerido';
    if (displayError == DaysEventError.length) {
      return 'Debe tener al menos 2 fechas seleccionadas';
    }
    // if (displayError == DaysEventError.format) {
    //   return 'Solo puede contener letras y espacios';
    // }

    return null;
  }

  @override
  DaysEventError? validator(List<DateTime> value) {
    if (value.isEmpty) return DaysEventError.empty;
    if (value.length < 2) return DaysEventError.length;
    // if (!nameRegExp.hasMatch(value)) return DaysEventError.format;

    return null;
  }
}
