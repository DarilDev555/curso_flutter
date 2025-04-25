import '../../entities/user.dart';

abstract class AuthDatasource {
  Future<User> login(String email, String password);
  Future<User> register(String name, String email, String password);
  Future<User> checkAuthStatus(String token);
}
