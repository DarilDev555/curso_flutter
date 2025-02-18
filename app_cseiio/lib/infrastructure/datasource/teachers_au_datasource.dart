import 'package:app_cseiio/domain/datasources/teachers_datasource.dart';
import 'package:app_cseiio/domain/entities/institution.dart';
import 'package:app_cseiio/domain/entities/teacher.dart';
import 'package:dio/dio.dart';
import 'package:app_cseiio/infrastructure/mappers/institution_mapper.dart';
import 'package:app_cseiio/infrastructure/mappers/teacher_mapper.dart';
import 'package:app_cseiio/infrastructure/models/teacherau/teacherinstitution_response.dart';
import 'package:app_cseiio/infrastructure/models/teacherau/teachersau_response.dart';

class TeachersauDatasource extends TeachersDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://172.31.162.15:8000/api',
      headers: {
        'Authorization':
            'Bearer 1|SPhBaRcecpshcRfwP7eYbLYce2CYZj8iVLoIoBoi3925f42a',
      },
    ),
  );

  List<Teacher> _jsonToTeacher(Map<String, dynamic> json) {
    final teacherAUResponse = TeachersauResponse.fromJson(json);
    final List<Teacher> teachers =
        teacherAUResponse.teachers
            .map(
              (teacherAU) => TeacherMapper.teacherAUToEntity(
                teacherAU,
                baseUrlImage: 'http://172.31.162.15:8000/',
              ),
            )
            .toList();

    return teachers;
  }

  @override
  Future<List<Teacher>> getTeachers({int page = 0}) async {
    final response = await dio.get('/teacher', queryParameters: {'page': page});

    return _jsonToTeacher(response.data);
  }

  // TODO implementar tamben en repositorio
  @override
  Future<Institution> getInstitutionTeacher({String? id}) async {
    final response = await dio.get('/teacherInstitution/$id');

    if (response.statusCode != 200) {
      throw Exception('Teacher with id: $id not found');
    }

    // final institutionAU = InstitutionAU.fromJson(response.data);
    final institutionAU =
        TeacherInstitutionResponse.fromJson(response.data).institution;

    final institution = InstitutionMapper.institutionAUToEntity(institutionAU);

    return institution;
  }
}
