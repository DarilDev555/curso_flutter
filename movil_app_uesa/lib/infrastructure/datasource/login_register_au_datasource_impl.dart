import 'package:dio/dio.dart';
import 'package:movil_app_uesa/domain/datasources/login_register_datasource.dart';
import 'package:movil_app_uesa/infrastructure/models/login/login_response.dart';

class LoginRegisterAuDatasourceImpl extends LoginRegisterDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.42.0.1:8000/api',
    ),
  );

  @override
  Future<String> login({String? email, String? password}) async {
    print('$email $password');
    final response =
        await dio.post('/login', data: {'email': email, 'password': password});

    if (response.statusCode != 200) {
      throw Exception('Error al inicar sesion');
    }

    final loginResponse = LoginResponse.fromJson(response.data).accessToken;
    return loginResponse;
  }
}
