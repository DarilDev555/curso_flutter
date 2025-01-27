import 'package:movil_app_uesa/domain/entities/institution.dart';
import 'package:movil_app_uesa/domain/entities/teacher.dart';

abstract class TeachersRepository {
  Future<List<Teacher>> getTeachers();

  Future<Institution> getInstitutionTeacher();
}
