import 'package:app_cseiio/config/const/environment.dart';
import 'package:dio/dio.dart';
import 'package:app_cseiio/domain/datasources/login_register_datasource.dart';
import 'package:app_cseiio/infrastructure/models/login/login_response.dart';

class LoginRegisterAuDatasourceImpl extends LoginRegisterDatasource {
  final dio = Dio(BaseOptions(baseUrl: Environment.apiUrl));

  @override
  Future<String> login({String? email, String? password}) async {
    print('$email $password');
    final response = await dio.post(
      '/login',
      data: {'email': email, 'password': password},
    );

    if (response.statusCode != 200) {
      throw Exception('Error al inicar sesion');
    }

    final loginResponse = LoginResponse.fromJson(response.data).accessToken;
    return loginResponse;
  }
}
