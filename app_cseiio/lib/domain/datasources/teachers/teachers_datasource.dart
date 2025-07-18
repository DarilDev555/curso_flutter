import '../../entities/institution.dart';
import '../../entities/teacher.dart';

abstract class TeachersDatasource {
  Future<List<Teacher>> getTeachers({int page = 0});

  Future<Institution> getInstitutionTeacher({String id});

  Future<Teacher> getTeacherById({required String id});

  Future<List<Teacher>> getTeacherAndAttendanceToEventDay({
    required String id,
    int page = 0,
  });

  Future<Map<String, dynamic>> getTeacherDetails({
    required String id,
    int page = 0,
  });

  Future<Teacher> regiterAttendance({
    required String idTeacher,
    required String idAttendance,
  });

  Future<List<Teacher>> getTeachersToattendance({
    required String idAttendance,
    int page = 0,
  });

  Future<Teacher> summitTeacherToAttendance(
    String idAttendance,
    String idTeacher,
  );
}
