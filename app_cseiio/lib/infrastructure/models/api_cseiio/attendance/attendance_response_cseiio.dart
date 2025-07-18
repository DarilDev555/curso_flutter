import 'register/register_response_cseiio.dart';

class AttendanceResponseCseiio {
  final int id;
  final int eventDayId;
  final String name;
  final String descripcion;
  final DateTime attendanceTime;
  final RegisterResponseCseiio? register;

  AttendanceResponseCseiio({
    required this.id,
    required this.eventDayId,
    required this.name,
    required this.descripcion,
    required this.attendanceTime,
    required this.register,
  });

  factory AttendanceResponseCseiio.fromJson(Map<String, dynamic> json) {
    return AttendanceResponseCseiio(
      id: json["id"],
      eventDayId: json["event_day_id"],
      name: json["name"],
      descripcion: json["descripcion"],
      attendanceTime:
          json["attendance_time"] == null
              ? DateTime.parse(json["attendancetime"])
              : DateTime.parse(json["attendance_time"]),
      register:
          json["register"] == null
              ? null
              : RegisterResponseCseiio.fromJson(json["register"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "event_day_id": eventDayId,
    "name": name,
    "descripcion": descripcion,
    "attendance_time": attendanceTime,
    "register": register?.toJson(),
  };
}
