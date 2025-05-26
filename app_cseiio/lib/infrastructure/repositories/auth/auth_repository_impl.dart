import '../../../domain/datasources/auth/auth_datasource.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/auth/auth_repository.dart';

import '../../datasources/auth/auth_datasource_impl.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl([AuthDatasource? dataSource])
    : datasource = dataSource ?? AuthDatasourceImpl();

  @override
  Future<User> checkAuthStatus(String token) {
    return datasource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
    return datasource.login(email, password);
  }

  @override
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
  }) {
    return datasource.register(
      userName: userName,
      email: email,
      password: password,
      firstName: firstName,
      paternalLastName: paternalLastName,
      maternalLastName: maternalLastName,
      gender: gender,
      electoralKey: electoralKey,
      curp: curp,
      institutionId: institutionId,
    );
  }

  @override
  Future<Map<String, List<String>>> userRegisterIsValid({
    required String userName,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) {
    return datasource.userRegisterIsValid(
      userName: userName,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }

  @override
  Future<User> updateAvatarUser(String urlPhoto, String token) {
    return datasource.updateAvatarUser(urlPhoto, token);
  }
}
