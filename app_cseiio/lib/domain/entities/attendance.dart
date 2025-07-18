import 'register.dart';

class Attendance {
  final int id;
  final int eventDayId;
  final String name;
  final String descripcion;
  final DateTime attendanceTime;
  final Register? register;

  Attendance({
    required this.id,
    required this.eventDayId,
    required this.name,
    required this.descripcion,
    required this.attendanceTime,
    required this.register,
  });
}
