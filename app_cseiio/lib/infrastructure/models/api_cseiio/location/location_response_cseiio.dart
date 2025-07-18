class LocationResponseCseiio {
  final String id;
  final String street;
  final String city;
  final String state;
  final String postalCode;
  final String description;
  final String latitude;
  final String longitude;

  LocationResponseCseiio({
    required this.id,
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.description,
    required this.latitude,
    required this.longitude,
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
  };
}
