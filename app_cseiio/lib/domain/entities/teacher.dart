import 'attendance.dart';
import 'package:isar/isar.dart';

part 'teacher.g.dart';

@collection
class Teacher {
  Id isarId = Isar.autoIncrement;
  int? idAttendance;

  final int id;
  final int institutionId;
  final int? userId;
  final String firstName;
  final String paternalLastName;
  final String maternalLastName;
  final String gender;
  final String electoralCode;
  final String email;
  final String curp;
  final DateTime dateRegister;
  final String? avatar;
  final DateTime createdAt;
  final DateTime updatedAt;

  @ignore
  final List<Attendance>? attendance;

  Teacher({
    this.idAttendance = -1,

    required this.id,
    required this.institutionId,
    required this.userId,
    required this.firstName,
    required this.paternalLastName,
    required this.maternalLastName,
    required this.gender,
    required this.electoralCode,
    required this.email,
    required this.curp,
    required this.dateRegister,
    required this.avatar,
    required this.createdAt,
    required this.updatedAt,
    this.attendance,
  });
}
