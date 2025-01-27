import 'dart:convert';

import 'package:movil_app_uesa/infrastructure/models/teacherau/teacher_teachersau.dart';

TeachersauResponse teachersauResponceFromJson(String str) =>
    TeachersauResponse.fromJson(json.decode(str));

String teachersauResponseToJson(TeachersauResponse data) =>
    json.encode(data.toJson());

class TeachersauResponse {
  final List<TeacherAU> teachers;
  final int status;

  TeachersauResponse({
    required this.teachers,
    required this.status,
  });

  factory TeachersauResponse.fromJson(Map<String, dynamic> json) =>
      TeachersauResponse(
        teachers: List<TeacherAU>.from(
            json["teachers"].map((x) => TeacherAU.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "teachers": List<dynamic>.from(teachers.map((x) => x.toJson())),
        "status": status,
      };
}
