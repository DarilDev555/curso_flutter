import '../api_cseiio.dart';

class TeacherDetailsResponseCseiio {
  final InstitutionRespondeCseiio institution;
  final List<DataResponse> data;

  TeacherDetailsResponseCseiio({required this.institution, required this.data});

  factory TeacherDetailsResponseCseiio.fromJson(Map<String, dynamic> json) =>
      TeacherDetailsResponseCseiio(
        institution: InstitutionRespondeCseiio.fromJson(json["institution"]),
        data: List<DataResponse>.from(
          json["data"].map((x) => DataResponse.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "institution": institution.toJson(),
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DataResponse {
  final EventResponceCseiio event;

  DataResponse({required this.event});

  factory DataResponse.fromJson(Map<String, dynamic> json) =>
      DataResponse(event: EventResponceCseiio.fromJson(json["event"]));

  Map<String, dynamic> toJson() => {"event": event.toJson()};
}
