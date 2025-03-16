import 'package:app_cseiio/infrastructure/models/api_cseiio/institution/institution_response_cseiio.dart';

class TeacherInstitutionResponseCseiio {
  final InstitutionCseiio institution;
  final int status;

  TeacherInstitutionResponseCseiio({
    required this.institution,
    required this.status,
  });

  factory TeacherInstitutionResponseCseiio.fromJson(
    Map<String, dynamic> json,
  ) => TeacherInstitutionResponseCseiio(
    // institution: InstitutionAU.fromJson(json["institution"]),
    institution: InstitutionCseiio.fromJson(json["institution"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "institution": institution.toJson(),
    "status": status,
  };
}
