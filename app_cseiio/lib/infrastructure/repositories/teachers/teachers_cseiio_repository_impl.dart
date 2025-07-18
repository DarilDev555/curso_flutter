import '../../../domain/datasources/teachers/teachers_datasource.dart';
import '../../../domain/entities/institution.dart';
import '../../../domain/entities/teacher.dart';
import '../../../domain/repositories/teachers/teachers_repository.dart';

class TeachersCseiioRepositoryImpl extends TeachersRepository {
  final TeachersDatasource teachersDatasource;

  TeachersCseiioRepositoryImpl(this.teachersDatasource);

  @override
  Future<List<Teacher>> getTeachers({int page = 0}) {
    return teachersDatasource.getTeachers(page: page);
  }

  @override
  Future<Institution> getInstitutionTeacher({String? id}) {
    return teachersDatasource.getInstitutionTeacher(id: id!);
  }

  @override
  Future<Teacher> getTeacherById({required String id}) {
    return teachersDatasource.getTeacherById(id: id);
  }

  @override
  Future<List<Teacher>> getTeacherAndAttendanceToEventDay({
    required String id,
    int page = 0,
  }) {
    return teachersDatasource.getTeacherAndAttendanceToEventDay(
      id: id,
      page: page,
    );
  }

  @override
  Future<Map<String, dynamic>> getTeacherDetails({
    required String id,
    int page = 0,
  }) {
    return teachersDatasource.getTeacherDetails(id: id, page: page);
  }

  @override
  Future<Teacher> regiterAttendance({
    required String idTeacher,
    required String idAttendance,
  }) {
    return teachersDatasource.regiterAttendance(
      idTeacher: idTeacher,
      idAttendance: idAttendance,
    );
  }

  @override
  Future<List<Teacher>> getTeachersToattendance({
    required String idAttendance,
    int page = 0,
  }) {
    return teachersDatasource.getTeachersToattendance(
      idAttendance: idAttendance,
      page: page,
    );
  }

  @override
  Future<Teacher> summitTeacherToAttendance(
    String idAttendance,
    String idTeacher,
  ) {
    return teachersDatasource.summitTeacherToAttendance(
      idAttendance,
      idTeacher,
    );
  }
}
