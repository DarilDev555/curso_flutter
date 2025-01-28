import 'package:movil_app_uesa/domain/entities/role.dart';

class User {
  final int id;
  final int roleId;
  final String email;
  final String profilePicture;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Role role;

  User({
    required this.id,
    required this.roleId,
    required this.email,
    required this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
  });
}
