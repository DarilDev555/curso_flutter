import '../location/location_response_cseiio.dart';

class InstitutionRespondeCseiio {
  final String id;
  final int locationId;
  final String code;
  final String name;
  final LocationResponseCseiio location;

  InstitutionRespondeCseiio({
    required this.id,
    required this.locationId,
    required this.code,
    required this.name,
    required this.location,
  });

  factory InstitutionRespondeCseiio.fromJson(Map<String, dynamic> json) =>
      InstitutionRespondeCseiio(
        id: json["id"].toString(),
        locationId: json["location_id"],
        code: json["code"],
        name: json["name"],
        location: LocationResponseCseiio.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "location_id": locationId,
    "code": code,
    "name": name,
    "location": location.toJson(),
  };
}
