import 'package:formz/formz.dart';

// Define los errores de validación
enum NameError { empty, length, format }

// Clase para validar nombres
class Name extends FormzInput<String, NameError> {
  static final RegExp nameRegExp = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$");

  // Representa un campo sin modificar
  const Name.pure([String? value]) : super.pure(value ?? '');

  // Representa un campo modificado
  const Name.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == NameError.empty) return 'El campo es requerido';
    if (displayError == NameError.length) {
      return 'Debe tener al menos 3 caracteres';
    }
    if (displayError == NameError.format) {
      return 'Solo puede contener letras y espacios';
    }

    return null;
  }

  @override
  NameError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return NameError.empty;
    if (value.length < 3) return NameError.length;
    if (!nameRegExp.hasMatch(value)) return NameError.format;

    return null;
  }
}
