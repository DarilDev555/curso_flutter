import '../../../domain/entities/user.dart';
import '../../../domain/repositories/auth/auth_repository.dart';
import '../../../infrastructure/repositories/auth/auth_repository_impl.dart';
import '../../errors/auth_errors.dart';
import '../../../service/key_value_storage_service.dart';
import '../../../service/key_value_storage_service_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//  PROVIDER
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorageService: keyValueStorageService,
  );
});

// NOTIFIER para controlar el estado
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;

  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService,
  }) : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } on Exception catch (_) {
      logout('Error no controlado');
    }
  }

  Future<Map<String, List<String>>?> registrerUser({
    required String userName,
    required String email,
    required String password,
    required String firstName,
    required String paternalLastName,
    required String maternalLastName,
    required String electoralKey,
    required String curp,
  }) async {
    try {
      final user = await authRepository.register(
        userName: userName,
        email: email,
        password: password,
        firstName: firstName,
        paternalLastName: paternalLastName,
        maternalLastName: maternalLastName,
        electoralKey: electoralKey,
        curp: curp,
      );
      _setLoggedUser(user);
      return null;
    } on FormErrors catch (e) {
      return e.errors;
    } on CustomError catch (e) {
      logout(e.message);
    } on Exception catch (_) {
      logout('Error no controlado');
    }
    return null;
  }

  Future<Map<String, List<String>>?> userRegisterCheckIsValid({
    required String userName,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final errors = await authRepository.userRegisterIsValid(
        userName: userName,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      state = state.copyWith(authStatus: AuthStatus.registering);

      return errors;
    } on FormErrors catch (e) {
      return e.errors;
    } on Exception catch (_) {
      logout('Error no controlado');
    }
    return null;
  }

  void checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>("token");

    if (token == null) return logout();

    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    } on CustomError catch (_) {
      logout();
    }
  }

  _setLoggedUser(User user) async {
    await keyValueStorageService.setKeyValue("token", user.token);

    state = state.copyWith(
      user: user,
      errorMessage: '',
      authStatus: AuthStatus.authenticated,
    );
  }

  Future<void> logout([String? errorMessage]) async {
    await keyValueStorageService.removeKey("token");

    state = state.copyWith(
      user: null,
      authStatus: AuthStatus.notAuthenticated,
      errorMessage: errorMessage,
    );
  }
}

// STATE el estado mismo, la clase no el objeto
enum AuthStatus { checking, authenticated, notAuthenticated, registering }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.errorMessage = '',
    this.user,
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    user: user ?? this.user,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}
