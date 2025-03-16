import 'package:app_cseiio/config/const/environment.dart';
import 'package:app_cseiio/domain/datasources/teachers/teachers_datasource.dart';
import 'package:app_cseiio/domain/entities/institution.dart';
import 'package:app_cseiio/domain/entities/teacher.dart';
import 'package:app_cseiio/infrastructure/mappers/institution_mapper.dart';
import 'package:app_cseiio/infrastructure/mappers/teacher_mapper.dart';
import 'package:app_cseiio/infrastructure/models/api_cseiio/teachers/teacher_response_cseiio.dart';
import 'package:app_cseiio/infrastructure/models/api_cseiio/teachers/teacherinstitution_response_cseiio.dart';
import 'package:app_cseiio/infrastructure/models/api_cseiio/teachers/teachers_response_cseiio.dart';
import 'package:dio/dio.dart';

class TeachersCseiioDatasourceImpl extends TeachersDatasource {
  final String accessToken;
  final Dio dio;
  TeachersCseiioDatasourceImpl({required this.accessToken})
    : dio = Dio(
        BaseOptions(
          baseUrl: Environment.apiUrl,
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Accept': 'application/json',
          },
        ),
      );

  List<Teacher> _jsonToTeacher(Map<String, dynamic> json) {
    final teacherAUResponse = TeachersCseiioResponse.fromJson(json);
    final List<Teacher> teachers =
        teacherAUResponse.teachers
            .map(
              (teacherAU) => TeacherMapper.teacherCseiioToEntity(
                teacherAU,
                baseUrlImage: Environment.apiUrl,
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
        TeacherInstitutionResponseCseiio.fromJson(response.data).institution;

    final institution = InstitutionMapper.institutionAUToEntity(institutionAU);

    return institution;
  }

  @override
  Future<Teacher> getTeacherById({required String id}) async {
    final response = await dio.get('/teacher/$id');

    if (response.statusCode != 200) {
      throw Exception('Teacher with id: $id not found');
    }

    final teacherResponse = TeacherResponseCseiio.fromJson(
      response.data['teacher'],
    );

    final teacher = TeacherMapper.teacherCseiioToEntity(
      teacherResponse,
      baseUrlImage: Environment.apiUrl,
    );

    return teacher;
  }
}
