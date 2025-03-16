import 'package:app_cseiio/domain/entities/role.dart';
import 'package:app_cseiio/domain/entities/user.dart';

class UserMapper {
  static User userjsonToEntity(Map<String, dynamic> json) {
    final Map<String, dynamic> mapUser = json['user'];
    final String jsonToken = json['access_token'];

    return User(
      id: mapUser['id'].toString(),
      roleId: mapUser['role_id'].toString(),
      userName: mapUser['userName'],
      email: mapUser['email'],
      profilePicture: mapUser['profile_picture'],
      role: Role(
        id: mapUser['role']['id'].toString(),
        name: mapUser['role']['name'],
      ),
      token: jsonToken,
    );
  }
}
