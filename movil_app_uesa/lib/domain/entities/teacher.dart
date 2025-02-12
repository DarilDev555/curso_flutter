import 'package:isar/isar.dart';

part 'teacher.g.dart';

@collection
class Teacher {
  Id? isarId;

  final int id;
  final int institutionId;
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

  Teacher({
    required this.id,
    required this.institutionId,
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
  });
}
