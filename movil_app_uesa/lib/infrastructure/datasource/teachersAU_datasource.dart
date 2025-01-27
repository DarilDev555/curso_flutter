import 'package:movil_app_uesa/domain/datasources/teachers_datasource.dart';
import 'package:movil_app_uesa/domain/entities/institution.dart';
import 'package:movil_app_uesa/domain/entities/teacher.dart';
import 'package:dio/dio.dart';
import 'package:movil_app_uesa/infrastructure/mappers/teacher_mapper.dart';
import 'package:movil_app_uesa/infrastructure/models/teacherau/teachersau_response.dart';

class TeachersauDatasource extends TeachersDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.0.227:8000/api',
      headers: {
        'Authorization':
            'Bearer 1|pkYDGZWUAOuRBu7l6VywoI6wrvLd9sZNXbICWDjO3a39bbc8',
      },
    ),
  );

  List<Teacher> _jsonToTeacher(Map<String, dynamic> json) {
    final teacherAUResponse = TeachersauResponse.fromJson(json);
    final List<Teacher> teachers = teacherAUResponse.teachers
        .map((teacherAU) => TeacherMapper.teacherAUToEntity(teacherAU,
            baseUrlImage: 'http://192.168.0.227:8000/'))
        .toList();

    return teachers;
  }

  @override
  Future<List<Teacher>> getTeachers() async {
    final response = await dio.get(
      '/teacher',
    );

    return _jsonToTeacher(response.data);
  }

// TODO implementar tamben en repositorio
  @override
  Future<Institution> getInstitutionTeacher() {
    // TODO: implement getInstitutionTeacher
    throw UnimplementedError();
  }
}
