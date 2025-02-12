import 'package:movil_app_uesa/domain/entities/institution.dart';
import 'package:movil_app_uesa/domain/entities/teacher.dart';

abstract class TeachersDatasource {
  Future<List<Teacher>> getTeachers({int page = 0});

  Future<Institution> getInstitutionTeacher({String id});
}
