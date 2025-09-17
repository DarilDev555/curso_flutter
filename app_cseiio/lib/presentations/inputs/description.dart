import 'package:formz/formz.dart';

// Define los errores de validación
enum DescriptionError { empty, length, format }

// Clase para validar nombres
class Description extends FormzInput<String, DescriptionError> {
  static final RegExp nameRegExp = RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$");

  // Representa un campo sin modificar
  const Description.pure([String? value]) : super.pure(value ?? '');

  // Representa un campo modificado
  const Description.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == DescriptionError.empty) return 'El campo es requerido';
    if (displayError == DescriptionError.length) {
      return 'Debe tener al menos 3 caracteres';
    }
    if (displayError == DescriptionError.format) {
      return 'Solo puede contener letras, espacios y numeros';
    }

    return null;
  }

  @override
  DescriptionError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return DescriptionError.empty;
    if (value.length < 3) return DescriptionError.length;
    if (!nameRegExp.hasMatch(value)) return DescriptionError.format;

    return null;
  }
}
