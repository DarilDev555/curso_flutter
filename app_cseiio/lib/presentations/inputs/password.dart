import 'package:formz/formz.dart';

// Define los errores de validación
enum PasswordError { empty, length, format, mismatch, space }

// Clase para validar contraseñas
class Password extends FormzInput<String, PasswordError> {
  // RegExp para la validación: al menos un número y un carácter especial.
  static final RegExp passwordRegExp = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*\W)[^\s]{6,}$',
  );

  final String? confirmPassword; // Contraseña para comparar

  // Constructor para un campo sin modificar
  const Password.pure({this.confirmPassword}) : super.pure('');

  // Constructor para un campo modificado
  const Password.dirty(super.value, {this.confirmPassword}) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == PasswordError.empty) return 'El campo es requerido';
    if (displayError == PasswordError.length) return 'Mínimo 6 caracteres';
    if (displayError == PasswordError.format) {
      return 'Debe contener mayúscula, minúscula, \nun número y un carácter especial';
    }
    if (displayError == PasswordError.space) {
      return 'No debe contener espacios';
    }

    if (displayError == PasswordError.mismatch) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }

  @override
  PasswordError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return PasswordError.empty;
    if (value.contains(' ')) return PasswordError.space; // ← evita espacios
    if (value.length < 6) return PasswordError.length;
    if (!passwordRegExp.hasMatch(value)) return PasswordError.format;
    if (confirmPassword != null && value != confirmPassword) {
      return PasswordError.mismatch;
    }

    return null;
  }
}
