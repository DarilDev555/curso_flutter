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

  User copyWith({
    String? id,
    String? roleId,
    String? userName,
    String? email,
    String? profilePicture,
    Role? role,
    String? token,
  }) => User(
    id: id ?? this.id,
    roleId: roleId ?? this.roleId,
    userName: userName ?? this.userName,
    email: email ?? this.email,
    profilePicture: profilePicture ?? this.profilePicture,
    role: role ?? this.role,
    token: token ?? this.token,
  );
}
