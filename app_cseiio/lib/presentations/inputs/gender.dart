import 'package:formz/formz.dart';

// Errores posibles para Gender
enum GenderError { empty, invalid }

class Gender extends FormzInput<String, GenderError> {
  // Lista de géneros válidos
  static const List<String> validGenders = ['male', 'female', 'other'];

  const Gender.pure() : super.pure('');
  const Gender.dirty([super.value = '']) : super.dirty();

  @override
  GenderError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return GenderError.empty;
    if (!validGenders.contains(value.toLowerCase())) return GenderError.invalid;
    return null;
  }

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == GenderError.empty) return 'El campo es requerido';
    if (displayError == GenderError.invalid) return 'Género inválido';
    return null;
  }
}
