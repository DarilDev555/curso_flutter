class Institution {
  final int id;
  final int locationId;
  final String code;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Institution({
    required this.id,
    required this.locationId,
    required this.code,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });
}
