//import 'package:app_cseiio/infraestructure/models/teacherau/teacher_teachersau.dart';
import 'teacher_response_cseiio.dart';

class TeachersCseiioResponse {
  final List<TeacherResponseCseiio> teachers;
  final int status;

  TeachersCseiioResponse({required this.teachers, required this.status});

  factory TeachersCseiioResponse.fromJson(Map<String, dynamic> json) =>
      TeachersCseiioResponse(
        teachers: List<TeacherResponseCseiio>.from(
          json["teachers"].map((x) => TeacherResponseCseiio.fromJson(x)),
        ),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
    "teachers": List<dynamic>.from(teachers.map((x) => x.toJson())),
    "status": status,
  };
}
