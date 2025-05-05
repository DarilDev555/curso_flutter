import 'package:formz/formz.dart';

// Errores específicos para CURP
enum CurpError { empty, format }

class Curp extends FormzInput<String, CurpError> {
  // CURP válida: 18 caracteres con estructura oficial
  static final RegExp curpRegExp = RegExp(
    r'^[A-Z]{4}\d{6}[HM][A-Z]{2}[B-DF-HJ-NP-TV-Z]{3}[A-Z\d]\d$',
    caseSensitive: false,
  );

  const Curp.pure() : super.pure('');
  const Curp.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == CurpError.empty) return 'El campo es requerido';
    if (displayError == CurpError.format) return 'CURP con formato inválido';

    return null;
  }

  @override
  CurpError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return CurpError.empty;
    if (!curpRegExp.hasMatch(value.toUpperCase())) return CurpError.format;

    return null;
  }
}
