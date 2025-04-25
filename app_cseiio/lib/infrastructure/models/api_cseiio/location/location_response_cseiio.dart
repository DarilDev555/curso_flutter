class LocationResponseCseiio {
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

  LocationResponseCseiio({
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

  factory LocationResponseCseiio.fromJson(Map<String, dynamic> json) =>
      LocationResponseCseiio(
        id: json["id"].toString(),
        street: json["street"],
        city: json["city"],
        state: json["state"],
        postalCode: json["postal_code"],
        description: json["description"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "street": street,
    "city": city,
    "state": state,
    "postal_code": postalCode,
    "description": description,
    "latitude": latitude,
    "longitude": longitude,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
