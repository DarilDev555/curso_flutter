class Location {
  final String id;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String description;
  final String latitude;
  final String longitude;
  final DateTime createdAt;
  final DateTime updatedAt;

  Location({
    required this.id,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });
}
