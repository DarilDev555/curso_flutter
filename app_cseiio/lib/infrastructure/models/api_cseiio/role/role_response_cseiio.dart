class RoleResponseCseiio {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  RoleResponseCseiio({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RoleResponseCseiio.fromJson(Map<String, dynamic> json) =>
      RoleResponseCseiio(
        id: json["id"].toString(),
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
