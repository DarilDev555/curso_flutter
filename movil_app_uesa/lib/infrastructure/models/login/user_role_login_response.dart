class UserResponseAU {
  final int id;
  final int roleId;
  final String email;
  final String profilePicture;
  final DateTime createdAt;
  final DateTime updatedAt;
  final RoleResponseAU role;

  UserResponseAU({
    required this.id,
    required this.roleId,
    required this.email,
    required this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
  });

  factory UserResponseAU.fromJson(Map<String, dynamic> json) => UserResponseAU(
        id: json["id"],
        roleId: json["role_id"],
        email: json["email"],
        profilePicture: json["profile_picture"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        role: RoleResponseAU.fromJson(json["role"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role_id": roleId,
        "email": email,
        "profile_picture": profilePicture,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "role": role.toJson(),
      };
}

class RoleResponseAU {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  RoleResponseAU({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RoleResponseAU.fromJson(Map<String, dynamic> json) => RoleResponseAU(
        id: json["id"],
        name: json["name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
