import '../api_cseiio.dart';

class TeachersAndAttendancesToEventDayResponseCseiio {
  final List<TeacherResponseCseiio> teachers;

  TeachersAndAttendancesToEventDayResponseCseiio({required this.teachers});

  factory TeachersAndAttendancesToEventDayResponseCseiio.fromJson(
    Map<String, dynamic> json,
  ) => TeachersAndAttendancesToEventDayResponseCseiio(
    teachers: List<TeacherResponseCseiio>.from(
      json["teachers"].map((x) => TeacherResponseCseiio.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "teachers": List<dynamic>.from(teachers.map((x) => x.toJson())),
  };
}
