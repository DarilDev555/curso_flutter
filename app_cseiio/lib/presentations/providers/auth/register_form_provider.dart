import 'package:app_cseiio/presentations/providers/auth/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import '../../inputs/inputs.dart';

final registerFormProvider = StateNotifierProvider.autoDispose<
  RegisterFormNotifier,
  RegisterFormState
>((ref) {
  final registerUserCallback = ref.watch(authProvider.notifier).registrerUser;

  return RegisterFormNotifier(registerUserCallback);
});

// Notifier controlador del estado
class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Function(String name, String email, String password) registerCallback;

  RegisterFormNotifier(this.registerCallback) : super(RegisterFormState());

  onNameChange(String value) {
    final newName = Name.dirty(value);
    state = state.copyWith(
      name: newName,
      isValid: Formz.validate([
        newName,
        state.email,
        state.password,
        state.secondPassword,
      ]),
    );
  }

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([
        newEmail,
        state.name,
        state.password,
        state.secondPassword,
      ]),
    );
  }

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([
        newPassword,
        state.name,
        state.email,
        state.secondPassword,
      ]),
    );
  }

  onSecondPasswordChange(String value) {
    final newSecondPassword = Password.dirty(
      value,
      confirmPassword: state.password.value,
    );
    state = state.copyWith(
      secondPassword: newSecondPassword,
      isValid: Formz.validate([
        newSecondPassword,
        state.name,
        state.email,
        state.password,
      ]),
    );
  }

  onFormSumit() async {
    _touchEveryField();
    if (!state.isValid) return;
    await registerCallback(
      state.name.value,
      state.email.value,
      state.password.value,
    );
  }

  _touchEveryField() {
    final name = Name.dirty(state.name.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final secondPassword = Password.dirty(
      state.secondPassword.value,
      confirmPassword:
          state.password.value, // Asegurar que tome la contraseña principal
    );

    state = state.copyWith(
      isFormPosted: true,
      name: name,
      email: email,
      password: password,
      secondPassword: secondPassword,
      isValid: Formz.validate([name, email, password, secondPassword]),
    );
  }
}

// State clase que va a tomar el estado
class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Name name;
  final Email email;
  final Password password;
  final Password secondPassword;

  RegisterFormState({
    this.isPosting = false,
    this.isFormPosted = true,
    this.isValid = false,
    this.name = const Name.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.secondPassword = const Password.pure(),
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Name? name,
    Email? email,
    Password? password,
    Password? secondPassword,
  }) {
    return RegisterFormState(
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      secondPassword: secondPassword ?? this.secondPassword,
    );
  }

  @override
  String toString() => ''' 
    isPosting: $isPosting
    isFormPosted: $isFormPosted
    isValid: $isValid
    name: $name
    email: $email
    password: $password
    secondPassword: $secondPassword
  ''';
}
