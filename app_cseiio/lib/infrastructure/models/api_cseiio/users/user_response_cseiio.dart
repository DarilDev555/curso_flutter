import '../role/role_response_cseiio.dart';

class UserResponseCseiio {
  final String id;
  final String roleId;
  final String userName;
  final String email;
  final String profilePicture;
  final RoleResponseCseiio role;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserResponseCseiio({
    required this.id,
    required this.roleId,
    required this.userName,
    required this.email,
    required this.profilePicture,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserResponseCseiio.fromJson(Map<String, dynamic> json) =>
      UserResponseCseiio(
        id: json["id"].toString(),
        roleId: json["role_id"].toString(),
        userName: json["userName"],
        email: json["email"],
        profilePicture: json["profile_picture"],
        role: RoleResponseCseiio.fromJson(json["role"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "role_id": roleId,
    "userName": userName,
    "email": email,
    "profile_picture": profilePicture,
    "role": role,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
