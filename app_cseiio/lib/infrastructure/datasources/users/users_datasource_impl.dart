import '../../../config/const/environment.dart';
import '../../../domain/datasources/users/users_datasource.dart';
import '../../../domain/entities/user.dart';
import '../../mappers/user_mapper.dart';
import '../../models/api_cseiio/users/users_register_response_cseiio.dart';
import 'package:dio/dio.dart';

class UsersDatasourceImpl extends UsersDatasource {
  final String accessToken;
  final Dio dio;

  UsersDatasourceImpl({required this.accessToken})
    : dio = Dio(
        BaseOptions(
          baseUrl: Environment.apiUrl,
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Accept': 'application/json',
          },
        ),
      );

  @override
  Future<List<User>> getUsersResgiters({int page = 0}) async {
    final response = await dio.get(
      '/user-register',
      queryParameters: {'page': page},
    );

    final userCseiioResponse = UsersRegisterResponseCseiio.fromJson(
      response.data,
    );

    final List<User> users =
        userCseiioResponse.users.map(UserMapper.userCseiioToEntity).toList();

    return users;
  }
}
