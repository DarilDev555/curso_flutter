import 'dart:convert';

//import 'package:app_cseiio/infraestructure/models/teacherau/teacher_teachersau.dart';
import 'package:app_cseiio/infrastructure/models/api_cseiio/teachers/teacher_response_cseiio.dart';

TeachersCseiioResponse teachersauResponceFromJson(String str) =>
    TeachersCseiioResponse.fromJson(json.decode(str));

String teachersResponseToJson(TeachersCseiioResponse data) =>
    json.encode(data.toJson());

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
