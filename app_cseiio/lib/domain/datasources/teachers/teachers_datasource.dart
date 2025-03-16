import 'package:app_cseiio/domain/entities/institution.dart';
import 'package:app_cseiio/domain/entities/teacher.dart';

abstract class TeachersDatasource {
  Future<List<Teacher>> getTeachers({int page = 0});

  Future<Institution> getInstitutionTeacher({String id});

  Future<Teacher> getTeacherById({required String id});
}
