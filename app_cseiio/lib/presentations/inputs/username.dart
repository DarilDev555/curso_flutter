import 'package:formz/formz.dart';

// Errores específicos para username
enum UsernameError { empty, length, format }

class Username extends FormzInput<String, UsernameError> {
  // Letras, números, guiones bajos y puntos. Sin espacios.
  static final RegExp usernameRegExp = RegExp(r'^[a-zA-Z0-9._]+$');

  const Username.pure() : super.pure('');
  const Username.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == UsernameError.empty) return 'El campo es requerido';
    if (displayError == UsernameError.length) {
      return 'Debe tener entre 5 y 15 caracteres';
    }
    if (displayError == UsernameError.format) {
      return 'Solo puede contener letras, números, "_" y "."';
    }

    return null;
  }

  @override
  UsernameError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return UsernameError.empty;
    if (value.length < 5 || value.length > 15) return UsernameError.length;
    if (!usernameRegExp.hasMatch(value)) return UsernameError.format;

    return null;
  }
}
