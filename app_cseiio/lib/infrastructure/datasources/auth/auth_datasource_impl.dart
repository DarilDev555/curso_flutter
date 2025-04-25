import '../../../config/const/environment.dart';
import '../../../domain/datasources/auth/auth_datasource.dart';
import '../../../domain/entities/user.dart';
import '../../../presentations/errors/auth_errors.dart';
import 'package:dio/dio.dart';

import '../../mappers/user_mapper.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final dio = Dio(BaseOptions(baseUrl: Environment.apiUrl));

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get(
        '/check-token',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final user = UserMapper.userjsonToEntity(response.data);

      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(message: 'Token incorrecto');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError(message: 'Revisar conexion a internet');
      }
      throw Exception();
    } on Exception catch (_) {
      throw Exception();
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      final user = UserMapper.userjsonToEntity(response.data);

      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
          message: e.response?.data['message'] ?? 'Credenciales incorrectas',
        );
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError(message: 'Revisar conexion a internet');
      }
      throw Exception();
    } on Exception catch (_) {
      throw Exception();
    }
  }

  @override
  Future<User> register(String name, String email, String password) async {
    try {
      final response = await dio.post(
        '/register',
        data: {'fullName': name, 'email': email, 'password': password},
      );

      final user = UserMapper.userjsonToEntity(response.data);

      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
          message: e.response?.data['message'] ?? 'Credenciales incorrectas',
        );
      }
      throw Exception();
    } on Exception catch (_) {
      throw Exception();
    }

    // throw UnimplementedError();
  }
}
