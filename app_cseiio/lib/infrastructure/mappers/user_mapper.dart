import '../../domain/entities/role.dart';
import '../../domain/entities/user.dart';
import 'role_mapper.dart';
import '../models/api_cseiio/users/user_response_cseiio.dart';

class UserMapper {
  static User userjsonToEntity(Map<String, dynamic> json) {
    final Map<String, dynamic> mapUser = json['user'];
    final String? jsonToken = json['access_token'];

    return User(
      id: mapUser['id'].toString(),
      roleId: mapUser['role_id'].toString(),
      userName: mapUser['userName'],
      email: mapUser['email'],
      profilePicture: mapUser['profile_picture'] ?? '',
      role: Role(
        id: mapUser['role']['id'].toString(),
        name: mapUser['role']['name'],
      ),
      token: jsonToken ?? '',
    );
  }

  static User userCseiioToEntity(UserResponseCseiio userResponseCseiio) {
    return User(
      id: userResponseCseiio.id,
      roleId: userResponseCseiio.roleId,
      userName: userResponseCseiio.userName,
      email: userResponseCseiio.email,
      profilePicture: userResponseCseiio.profilePicture,
      role: RoleMapper.roleCseiioToEntity(userResponseCseiio.role),
    );
  }
}
