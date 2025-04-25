import 'role.dart';

class User {
  final String id;
  final String roleId;
  final String userName;
  final String email;
  final String profilePicture;
  final Role role;
  final String token;

  User({
    required this.id,
    required this.roleId,
    required this.userName,
    required this.email,
    required this.profilePicture,
    required this.role,
    this.token = '',
  });
}
