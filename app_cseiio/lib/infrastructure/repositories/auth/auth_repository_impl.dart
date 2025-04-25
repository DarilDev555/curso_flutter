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
  Future<User> register(String name, String email, String password) {
    return datasource.register(name, email, password);
  }
}
