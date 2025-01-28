class InstitutionAU {
  final int id;
  final int locationId;
  final String code;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  InstitutionAU({
    required this.id,
    required this.locationId,
    required this.code,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InstitutionAU.fromJson(Map<String, dynamic> json) => InstitutionAU(
        id: json["id"],
        locationId: json["location_id"],
        code: json["code"],
        name: json["name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "location_id": locationId,
        "code": code,
        "name": name,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
