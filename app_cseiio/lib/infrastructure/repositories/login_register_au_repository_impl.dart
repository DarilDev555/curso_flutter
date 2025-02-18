import 'package:app_cseiio/domain/repositories/login_register_repositories.dart';
import 'package:app_cseiio/infrastructure/datasource/login_register_au_datasource_impl.dart';

class LoginRegisterAuRepositoryImpl extends LoginRegisterRepositories {
  final LoginRegisterAuDatasourceImpl loginRegisterAuDatasource;

  LoginRegisterAuRepositoryImpl(this.loginRegisterAuDatasource);

  @override
  Future<String> login({String? email, String? password}) {
    return loginRegisterAuDatasource.login(email: email, password: password);
  }
}
