import 'register.dart';

class Attendance {
  final String id;
  final String eventDayId;
  final String name;
  final String descripcion;
  final DateTime attendanceTime;
  final Register? register;

  Attendance({
    this.id = '-1',
    this.eventDayId = '-1',
    required this.name,
    required this.descripcion,
    required this.attendanceTime,
    this.register,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "event_day_id": eventDayId,
    "name": name,
    "descripcion": descripcion,
    "attendance_time": attendanceTime,
    "register": register?.toJson(),
  };

  Attendance copyWith({
    String? id,
    String? eventDayId,
    String? name,
    String? descripcion,
    DateTime? attendanceTime,
    Register? register,
  }) {
    return Attendance(
      id: id ?? this.id,
      eventDayId: eventDayId ?? this.eventDayId,
      name: name ?? this.name,
      descripcion: descripcion ?? this.descripcion,
      attendanceTime: attendanceTime ?? this.attendanceTime,
      register: register ?? this.register,
    );
  }
}
