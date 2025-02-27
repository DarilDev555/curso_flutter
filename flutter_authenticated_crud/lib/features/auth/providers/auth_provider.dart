import 'package:flutter_authenticated_crud/features/auth/infraestructure/errors/auth_errors.dart';
import 'package:flutter_authenticated_crud/features/auth/infraestructure/repositories/auth_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/domain.dart';

//  PROVIDER
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();

  return AuthNotifier(authRepository: authRepository);
});

// NOTIFIER para controlar el estado
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;

  AuthNotifier({required this.authRepository}) : super(AuthState());

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error no controlado');
    }
  }

  void registrerUser(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final user = await authRepository.register(name, email, password);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error no controlado');
    }
  }

  void checkAuthStatus() async {}

  _setLoggedUser(User user) {
    //TODO: Guardar el token en el dispositivo

    state = state.copyWith(
      user: user,
      errorMessage: '',
      authStatus: AuthStatus.authenticated,
    );
  }

  Future<void> logout([String? errorMessage]) async {
    //TODO: limpiar token
    state = state.copyWith(
      user: null,
      authStatus: AuthStatus.notAuthenticated,
      errorMessage: errorMessage,
    );
  }
}

// STATE el estado mismo, la clase no el objeto
enum AuthStatus { checking, authenticated, notAuthenticated }

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
