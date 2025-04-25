import '../../entities/institution.dart';
import '../../entities/teacher.dart';

abstract class TeachersRepository {
  Future<List<Teacher>> getTeachers({int page = 0});

  Future<Institution> getInstitutionTeacher({String id});

  Future<Teacher> getTeacherById({required String id});

  Future<List<Teacher>> getTeacherToAttendanceOrEvent({
    required String id,
    int page = 0,
  });

  Future<Map<String, dynamic>> getTeacherDetails({
    required String id,
    int page = 0,
  });
}
