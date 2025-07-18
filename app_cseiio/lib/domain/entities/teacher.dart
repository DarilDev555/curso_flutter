import 'attendance.dart';
import 'package:isar/isar.dart';

import 'entities.dart';

part 'teacher.g.dart';

@collection
class Teacher {
  Id isarId = Isar.autoIncrement;
  final int? idAttendance;
  final DateTime? attendanceRegister;

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

  @ignore
  final List<Attendance>? attendance;

  Teacher({
    this.idAttendance = -1,
    this.attendanceRegister,

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
    this.attendance,
  });

  Teacher copyWith({
    int? idAttendance,
    DateTime? attendanceRegister,
    int? id,
    int? institutionId,
    int? userId,
    String? firstName,
    String? paternalLastName,
    String? maternalLastName,
    String? gender,
    String? electoralCode,
    String? email,
    String? curp,
    DateTime? dateRegister,
    String? avatar,
    List<Attendance>? attendance,
  }) {
    return Teacher(
      idAttendance: idAttendance ?? this.idAttendance,
      attendanceRegister: attendanceRegister ?? this.attendanceRegister,

      id: id ?? this.id,
      institutionId: institutionId ?? this.institutionId,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      paternalLastName: paternalLastName ?? this.paternalLastName,
      maternalLastName: maternalLastName ?? this.maternalLastName,
      gender: gender ?? this.gender,
      electoralCode: electoralCode ?? this.electoralCode,
      email: email ?? this.email,
      curp: curp ?? this.curp,
      dateRegister: dateRegister ?? this.dateRegister,
      avatar: avatar ?? this.avatar,
      attendance: attendance ?? this.attendance,
    );
  }
}
