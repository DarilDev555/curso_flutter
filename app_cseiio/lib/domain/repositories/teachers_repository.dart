import 'package:app_cseiio/domain/entities/institution.dart';
import 'package:app_cseiio/domain/entities/teacher.dart';

abstract class TeachersRepository {
  Future<List<Teacher>> getTeachers({int page = 0});

  Future<Institution> getInstitutionTeacher({String id});
}
