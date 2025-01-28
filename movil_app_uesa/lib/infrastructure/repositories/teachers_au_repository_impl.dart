import 'package:movil_app_uesa/domain/datasources/teachers_datasource.dart';
import 'package:movil_app_uesa/domain/entities/institution.dart';
import 'package:movil_app_uesa/domain/entities/teacher.dart';
import 'package:movil_app_uesa/domain/repositories/teachers_repository.dart';

class TeachersauRepositoryImpl extends TeachersRepository {
  final TeachersDatasource teachersDatasource;

  TeachersauRepositoryImpl(this.teachersDatasource);

  @override
  Future<List<Teacher>> getTeachers() {
    return teachersDatasource.getTeachers();
  }

  @override
  Future<Institution> getInstitutionTeacher({String? id}) {
    return teachersDatasource.getInstitutionTeacher(id: id!);
  }
}
