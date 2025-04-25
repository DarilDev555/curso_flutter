import 'institution_response_cseiio.dart';

class InstitutionsResponseCseiio {
  final List<InstitutionRespondeCseiio> institutions;

  InstitutionsResponseCseiio({required this.institutions});

  factory InstitutionsResponseCseiio.fromJson(Map<String, dynamic> json) =>
      InstitutionsResponseCseiio(
        institutions: List<InstitutionRespondeCseiio>.from(
          json["institutions"].map(
            (x) => InstitutionRespondeCseiio.fromJson(x),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
    "institutions": List<dynamic>.from(institutions.map((x) => x.toJson())),
  };
}
