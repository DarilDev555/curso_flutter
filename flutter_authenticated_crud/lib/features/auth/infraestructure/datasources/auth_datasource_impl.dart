import 'package:dio/dio.dart';
import 'package:flutter_authenticated_crud/config/const/environment.dart';
import 'package:flutter_authenticated_crud/features/auth/domain/domain.dart';
import 'package:flutter_authenticated_crud/features/auth/infraestructure/errors/auth_errors.dart';
import 'package:flutter_authenticated_crud/features/auth/infraestructure/infraestructure.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final dio = Dio(BaseOptions(baseUrl: Environment.apiUrl));

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get(
        '/auth/check-status',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
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
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
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
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> register(String name, String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/register',
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
    } catch (e) {
      throw Exception();
    }
  }
}
