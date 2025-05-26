import '../../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register({
    required String userName,
    required String email,
    required String password,
    required String firstName,
    required String paternalLastName,
    required String maternalLastName,
    required String gender,
    required String electoralKey,
    required String curp,
    required String institutionId,
  });
  Future<Map<String, List<String>>> userRegisterIsValid({
    required String userName,
    required String email,
    required String password,
    required String passwordConfirmation,
  });
  Future<User> checkAuthStatus(String token);
  Future<User> updateAvatarUser(String urlPhoto, String token);
}
