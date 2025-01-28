import 'package:movil_app_uesa/infrastructure/models/teacherau/institution_teacherinstitution.dart';

class TeacherInstitutionResponse {
  final InstitutionAU institution;
  final int status;

  TeacherInstitutionResponse({
    required this.institution,
    required this.status,
  });

  factory TeacherInstitutionResponse.fromJson(Map<String, dynamic> json) =>
      TeacherInstitutionResponse(
        // institution: InstitutionAU.fromJson(json["institution"]),
        institution: InstitutionAU.fromJson(json["institution"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "institution": institution.toJson(),
        "status": status,
      };
}
