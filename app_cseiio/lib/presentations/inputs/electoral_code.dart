import 'package:formz/formz.dart';

// Errores específicos para la Clave de Elector
enum ElectoralCodeError { empty, format }

class ElectoralCode extends FormzInput<String, ElectoralCodeError> {
  // La clave electoral es alfanumérica, exactamente 18 caracteres
  static final RegExp claveElectorRegExp = RegExp(
    r'^[A-Z]{6}\d{6}[A-Z0-9]{6}$',
    caseSensitive: false,
  );

  const ElectoralCode.pure() : super.pure('');
  const ElectoralCode.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == ElectoralCodeError.empty) {
      return 'El campo es requerido';
    }
    if (displayError == ElectoralCodeError.format) {
      return 'Formato inválido (18 caracteres, letras y números)';
    }

    return null;
  }

  @override
  ElectoralCodeError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return ElectoralCodeError.empty;
    if (!claveElectorRegExp.hasMatch(value.toUpperCase())) {
      return ElectoralCodeError.format;
    }

    return null;
  }
}
