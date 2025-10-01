import 'package:formz/formz.dart';

// Define los errores de validación
enum InvitationCodeError { empty, length, format }

// Clase para validar nombres
class InvitationCode extends FormzInput<String, InvitationCodeError> {
  // Representa un campo sin modificar
  const InvitationCode.pure([String? value]) : super.pure(value ?? '');

  // Representa un campo modificado
  const InvitationCode.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == InvitationCodeError.empty) {
      return 'El campo es requerido';
    }
    if (displayError == InvitationCodeError.length) {
      return 'Debe tener al menos 3 caracteres';
    }
    if (displayError == InvitationCodeError.format) {
      return 'Solo puede contener letras, espacios y numeros';
    }

    return null;
  }

  @override
  InvitationCodeError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return InvitationCodeError.empty;
    if (value.length < 3) return InvitationCodeError.length;

    return null;
  }
}
