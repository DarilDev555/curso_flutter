import 'package:formz/formz.dart';
import '../../domain/entities/entities.dart';

enum InstitutionValidationError { empty }

class InstitutionInput
    extends FormzInput<Institution?, InstitutionValidationError> {
  const InstitutionInput.pure() : super.pure(null);
  const InstitutionInput.dirty([super.value]) : super.dirty();

  @override
  InstitutionValidationError? validator(Institution? value) {
    return value == null ? InstitutionValidationError.empty : null;
  }

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == InstitutionValidationError.empty) {
      return 'Debe seleccionar una institución';
    }

    return null;
  }
}
