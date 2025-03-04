import 'package:flutter_authenticated_crud/features/auth/domain/domain.dart';

class UserMapper {
  static User userjsonToEntity(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      fulname: json['fullName'],
      roles: List<String>.from(json['roles'].map((role) => role)),
      token: json['token'] ?? '',
    );
  }
}
