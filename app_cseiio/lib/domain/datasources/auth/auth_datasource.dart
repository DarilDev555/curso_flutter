import '../../entities/user.dart';

abstract class AuthDatasource {
  Future<User> login(String email, String password);
  Future<User> register({
    required String userName,
    required String email,
    required String password,
    required String firstName,
    required String paternalLastName,
    required String maternalLastName,
    required String electoralKey,
    required String curp,
  });
  Future<Map<String, List<String>>> userRegisterIsValid({
    required String userName,
    required String email,
    required String password,
    required String passwordConfirmation,
  });
  Future<User> checkAuthStatus(String token);
}
