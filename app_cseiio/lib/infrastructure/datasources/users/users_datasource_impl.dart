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

  Future<String> _uploadFile(String path) async {
    try {
      final fileName = path.split('/').last;
      final FormData data = FormData.fromMap({
        'file': MultipartFile.fromFileSync(path, filename: fileName),
      });

      final respose = await dio.post('/img/user', data: data);

      return respose.data['image'];
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> crateUpdateUser(Map<String, dynamic> userLike) async {
    try {
      final String? userId = userLike['id'];
      final String method = (userId == null) ? 'POST' : 'PATCH';
      final String url = (userId == null) ? '/users' : '/users/$userId';

      userLike.remove('id');
      userLike['profile_picture'] = await _uploadFile(
        userLike['profile_picture'],
      );

      final response = await dio.request(
        url,
        data: userLike,
        options: Options(method: method),
      );

      final user = UserMapper.userjsonToEntity(response.data);
      return user;
    } catch (e) {
      throw Exception();
    }
  }

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
