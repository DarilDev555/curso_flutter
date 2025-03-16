import 'package:app_cseiio/domain/datasources/teachers/teachers_datasource.dart';
import 'package:app_cseiio/domain/entities/institution.dart';
import 'package:app_cseiio/domain/entities/teacher.dart';
import 'package:app_cseiio/domain/repositories/teachers/teachers_repository.dart';

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
}
