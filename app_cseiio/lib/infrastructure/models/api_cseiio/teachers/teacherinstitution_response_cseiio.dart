import '../institution/institution_response_cseiio.dart';

class TeacherInstitutionResponseCseiio {
  final InstitutionRespondeCseiio institution;
  final int status;

  TeacherInstitutionResponseCseiio({
    required this.institution,
    required this.status,
  });

  factory TeacherInstitutionResponseCseiio.fromJson(
    Map<String, dynamic> json,
  ) => TeacherInstitutionResponseCseiio(
    // institution: InstitutionAU.fromJson(json["institution"]),
    institution: InstitutionRespondeCseiio.fromJson(json["institution"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "institution": institution.toJson(),
    "status": status,
  };
}
