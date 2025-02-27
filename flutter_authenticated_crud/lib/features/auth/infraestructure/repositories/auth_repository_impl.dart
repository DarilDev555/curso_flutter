import 'package:flutter_authenticated_crud/features/auth/domain/domain.dart';
import '../infraestructure.dart';

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
