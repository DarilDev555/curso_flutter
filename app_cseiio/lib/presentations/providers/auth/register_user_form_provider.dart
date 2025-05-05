import 'auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import '../../inputs/inputs.dart';

final registerUserFormProvider = StateNotifierProvider.autoDispose<
  RegisterUserFormNotifier,
  RegisterUserFormState
>((ref) {
  final registerUserCallback = ref.watch(authProvider.notifier).registrerUser;
  final userRegisterCheckIsValidCallback =
      ref.watch(authProvider.notifier).userRegisterCheckIsValid;

  return RegisterUserFormNotifier(
    registerUserCallback,
    userRegisterCheckIsValidCallback,
  );
});

// Notifier controlador del estado
class RegisterUserFormNotifier extends StateNotifier<RegisterUserFormState> {
  final Future<Map<String, List<String>>?> Function({
    required String userName,
    required String email,
    required String password,
    required String firstName,
    required String paternalLastName,
    required String maternalLastName,
    required String electoralKey,
    required String curp,
  })
  registerCallback;
  final Future<Map<String, List<String>>?> Function({
    required String userName,
    required String email,
    required String password,
    required String passwordConfirmation,
  })
  userRegisterCheckIsvalid;

  RegisterUserFormNotifier(this.registerCallback, this.userRegisterCheckIsvalid)
    : super(RegisterUserFormState());

  void onNameChange(String value) {
    final newName = Username.dirty(value);
    state = state.copyWith(
      userName: newName,
      isValid: Formz.validate([
        newName,
        state.email,
        state.password,
        state.secondPassword,
      ]),
    );
  }

  void onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([
        newEmail,
        state.userName,
        state.password,
        state.secondPassword,
      ]),
    );
  }

  void onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([
        newPassword,
        state.userName,
        state.email,
        state.secondPassword,
      ]),
    );
  }

  void onSecondPasswordChange(String value) {
    final newSecondPassword = Password.dirty(
      value,
      confirmPassword: state.password.value,
    );
    state = state.copyWith(
      secondPassword: newSecondPassword,
      isValid: Formz.validate([
        newSecondPassword,
        state.userName,
        state.email,
        state.password,
      ]),
    );
  }

  void onFirstnameChange(String value) {
    final newFirstname = Name.dirty(value);
    state = state.copyWith(
      firstName: newFirstname,
      isValid: Formz.validate([
        newFirstname,
        state.paternalLastName,
        state.maternalLastName,
        state.electoralCode,
        state.curp,
      ]),
    );
  }

  void onPaternalLastnameChange(String value) {
    final newPaternalLastname = Name.dirty(value);
    state = state.copyWith(
      paternalLastName: newPaternalLastname,
      isValid: Formz.validate([
        state.firstName,
        newPaternalLastname,
        state.maternalLastName,
        state.electoralCode,
        state.curp,
      ]),
    );
  }

  void onMaternalLastnameChange(String value) {
    final newMaternalLastname = Name.dirty(value);
    state = state.copyWith(
      maternalLastName: newMaternalLastname,
      isValid: Formz.validate([
        state.firstName,
        state.paternalLastName,
        newMaternalLastname,
        state.electoralCode,
        state.curp,
      ]),
    );
  }

  void onElectoralCodeChange(String value) {
    final newElectoralCode = ElectoralCode.dirty(value);
    state = state.copyWith(
      electoralCode: newElectoralCode,
      isValid: Formz.validate([
        state.firstName,
        state.paternalLastName,
        state.maternalLastName,
        newElectoralCode,
        state.curp,
      ]),
    );
  }

  void onCurpChange(String value) {
    final newCurp = Curp.dirty(value);
    state = state.copyWith(
      curp: newCurp,
      isValid: Formz.validate([
        state.firstName,
        state.paternalLastName,
        state.maternalLastName,
        state.electoralCode,
        newCurp,
      ]),
    );
  }

  void onFormSumit() async {
    _touchEveryField();
    if (!state.isValid && !(state.isSumit)) return;
    state = state.copyWith(isSumit: true);

    final errors = await registerCallback(
      userName: state.userName.value,
      email: state.email.value,
      password: state.password.value,
      firstName: state.firstName.value,
      paternalLastName: state.paternalLastName.value,
      maternalLastName: state.maternalLastName.value,
      electoralKey: state.electoralCode.value,
      curp: state.curp.value,
    );
    if (errors != null &&
        errors.values.every((element) => element.isNotEmpty)) {
      state = state.copyWith(errors: errors, isSumit: false);
      return;
    }
    state = state.copyWith(isSumit: false);
  }

  void checkUserForm() async {
    _touchEveryField();
    if (!state.isValid || state.isCheckingUser) return;
    state = state.copyWith(isCheckingUser: true);

    if (state.isValidUser) {
      state = state.copyWith(isValidUser: false);
    }
    final errors = await userRegisterCheckIsvalid(
      userName: state.userName.value,
      email: state.email.value,
      password: state.password.value,
      passwordConfirmation: state.secondPassword.value,
    );
    if (errors != null && errors.values.any((element) => element.isNotEmpty)) {
      state = state.copyWith(errors: errors);
      state = state.copyWith(isCheckingUser: false);

      return;
    }

    state = state.copyWith(
      errors: {},
      isValidUser: true,
      isCheckingUser: false,
    );
  }

  _touchEveryField() {
    final userName = Username.dirty(state.userName.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final secondPassword = Password.dirty(
      state.secondPassword.value,
      confirmPassword:
          state.password.value, // Asegurar que tome la contraseña principal
    );

    state = state.copyWith(
      isFormPosted: true,
      userName: userName,
      email: email,
      password: password,
      secondPassword: secondPassword,
      isValid: Formz.validate([userName, email, password, secondPassword]),
    );
  }

  void switchModal() {
    state = state.copyWith(openModal: !state.openModal);
  }
}

// State clase que va a tomar el estado
class RegisterUserFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final bool isValidUser;
  final bool isCheckingUser;
  final bool isSumit;
  final bool openModal;
  final Username userName;
  final Email email;
  final Password password;
  final Password secondPassword;
  final Name firstName;
  final Name paternalLastName;
  final Name maternalLastName;
  final ElectoralCode electoralCode;
  final Curp curp;
  final Map<String, List<String>>? errors;

  RegisterUserFormState({
    this.isPosting = false,
    this.isFormPosted = true,
    this.isValid = false,
    this.isValidUser = false,
    this.isCheckingUser = false,
    this.isSumit = false,
    this.openModal = false,

    this.userName = const Username.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.secondPassword = const Password.pure(),
    this.firstName = const Name.pure(),
    this.paternalLastName = const Name.pure(),
    this.maternalLastName = const Name.pure(),
    this.electoralCode = const ElectoralCode.pure(),
    this.curp = const Curp.pure(),
    this.errors,
  });

  RegisterUserFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    bool? isValidUser,
    bool? isCheckingUser,
    bool? isSumit,
    bool? openModal,
    Username? userName,
    Email? email,
    Password? password,
    Password? secondPassword,
    Name? firstName,
    Name? paternalLastName,
    Name? maternalLastName,
    ElectoralCode? electoralCode,
    Curp? curp,
    Map<String, List<String>>? errors,
  }) {
    return RegisterUserFormState(
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
      isValidUser: isValidUser ?? this.isValidUser,
      isCheckingUser: isCheckingUser ?? this.isCheckingUser,
      isSumit: isSumit ?? this.isSumit,
      openModal: openModal ?? this.openModal,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      password: password ?? this.password,
      secondPassword: secondPassword ?? this.secondPassword,
      firstName: firstName ?? this.firstName,
      paternalLastName: paternalLastName ?? this.paternalLastName,
      maternalLastName: maternalLastName ?? this.maternalLastName,
      electoralCode: electoralCode ?? this.electoralCode,
      curp: curp ?? this.curp,
      errors: errors ?? this.errors,
    );
  }

  @override
  String toString() => ''' 
    isPosting: $isPosting
    isFormPosted: $isFormPosted
    isValid: $isValid
    isValidUser: $isValidUser
    isCheckingUser: $isCheckingUser
    name: $userName
    email: $email
    password: $password
    secondPassword: $secondPassword
    firstName: $firstName
    paternalLastName: $paternalLastName
    maternalLastName: $maternalLastName
    electoralCode: $electoralCode
    curp: $curp
  ''';
}
