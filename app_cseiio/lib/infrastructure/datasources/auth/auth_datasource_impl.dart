import '../../../config/const/environment.dart';
import '../../../domain/datasources/auth/auth_datasource.dart';
import '../../../domain/entities/user.dart';
import '../../../presentations/errors/auth_errors.dart';
import 'package:dio/dio.dart';

import '../../mappers/errors_mapper.dart';
import '../../mappers/user_mapper.dart';
import '../../models/api_cseiio/errors/user_register_form_is_valid_response_cseiio.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
      connectTimeout: const Duration(seconds: 7),
    ),
  );

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
    } on Exception catch (e) {
      print(e.toString());
      throw Exception();
    }
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
  }) async {
    try {
      final response = await dio.post(
        '/register',
        data: {
          'userName': userName,
          'email': email,
          'password': password,
          'password_confirmation': password,
          'firstName': firstName,
          'paternalLastName': paternalLastName,
          'maternalLastName': maternalLastName,
          'gender': gender,
          'electoralCode': electoralKey,
          'curp': curp,
          'institution_id': institutionId,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final user = UserMapper.userjsonToEntity(response.data);

      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final errorsCseiio = UserRegisterFormIsValidResponseCseiio.fromJson(
          e.response?.data,
        );

        final errors = ErrorsMapper.errorsUserRegisterFormCseiioToEntity(
          errorsCseiio,
        );
        throw FormErrorsListErros(errors: errors);
      }
      throw Exception();
    } on Exception catch (_) {
      throw Exception();
    }

    // throw UnimplementedError();
  }

  @override
  Future<Map<String, List<String>>> userRegisterIsValid({
    required String userName,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await dio.post(
        '/checkUser',
        data: {
          'userName': userName,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      final errorsCseiio = UserRegisterFormIsValidResponseCseiio.fromJson(
        response.data,
      );

      final errors = ErrorsMapper.errorsUserRegisterFormCseiioToEntity(
        errorsCseiio,
      );
      return errors;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final errorsCseiio = UserRegisterFormIsValidResponseCseiio.fromJson(
          e.response?.data,
        );

        final errors = ErrorsMapper.errorsUserRegisterFormCseiioToEntity(
          errorsCseiio,
        );
        throw FormErrorsListErros(errors: errors);
      }
      throw Exception();
    } on Exception catch (_) {
      throw Exception();
    }
  }

  @override
  Future<User> updateAvatarUser(String urlPhoto, String token) async {
    try {
      final fileName = urlPhoto.split('/').last;
      final FormData data = FormData.fromMap({
        'file': MultipartFile.fromFileSync(urlPhoto, filename: fileName),
      });

      final response = await dio.post(
        '/img/user',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final user = UserMapper.userjsonToEntity(response.data);
      return user;
    } catch (e) {
      throw Exception();
    }
  }
}
