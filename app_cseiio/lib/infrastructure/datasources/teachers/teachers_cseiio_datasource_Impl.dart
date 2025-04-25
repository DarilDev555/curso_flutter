// ignore_for_file: file_names

import '../../../config/const/environment.dart';
import '../../../domain/datasources/teachers/teachers_datasource.dart';
import '../../../domain/entities/entities.dart';
import '../../../presentations/errors/auth_errors.dart';
import '../../mappers/mappers.dart';
import '../../models/api_cseiio/api_cseiio.dart';
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
              (teacherCseiio) => TeacherMapper.teacherCseiioToEntity(
                teacherCseiio,
                baseUrlImage: Environment.apiUrl,
              ),
            )
            .toList();

    return teachers;
  }

  @override
  Future<List<Teacher>> getTeachers({int page = 0}) async {
    try {
      final response = await dio.get(
        '/teacher',
        queryParameters: {'page': page},
        options: Options(headers: {'Accept': 'application/json'}),
      );

      return _jsonToTeacher(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
          message: e.response?.data['message'] ?? 'Credenciales incorrectas',
        );
      }
      throw Exception();
    } on Exception catch (_) {
      throw Exception();
    }
  }

  // TODO implementar tamben en repositorio
  @override
  Future<Institution> getInstitutionTeacher({String? id}) async {
    final response = await dio.get('/teacherInstitution/$id');

    if (response.statusCode != 200) {
      throw Exception('Teacher with id: $id not found');
    }

    // final institutionAU = InstitutionAU.fromJson(response.data);
    final institutionCseiio =
        TeacherInstitutionResponseCseiio.fromJson(response.data).institution;

    final institution = InstitutionMapper.institutionAUToEntity(
      institutionCseiio,
    );

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

  @override
  Future<List<Teacher>> getTeacherToAttendanceOrEvent({
    required String id,
    int page = 0,
  }) async {
    final response = await dio.get(
      '/teacherAndAttendanceToEventDay',
      queryParameters: {'eventDay_id': id, 'page': page},
    );

    if (response.statusCode != 200) {
      throw Exception('Teacher with id: $id not found');
    }

    final teachersResponce =
        TeachersAndAttendancesToEventDayResponseCseiio.fromJson(response.data);

    final List<Teacher> teachers =
        teachersResponce.teachers
            .map(
              (teacherCseiio) => TeacherMapper.teacherCseiioToEntity(
                teacherCseiio,
                baseUrlImage: Environment.apiUrl,
              ),
            )
            .toList();

    return teachers;
  }

  @override
  Future<Map<String, dynamic>> getTeacherDetails({
    required String id,
    int page = 0,
  }) async {
    final response = await dio.get(
      '/teacherDetails',
      queryParameters: {'idTeacher': id, 'page': page},
    );

    if (response.statusCode != 200) {
      throw Exception('Teacher with id: $id not found');
    }

    final teacherDetailsCseiio = TeacherDetailsResponseCseiio.fromJson(
      response.data,
    );

    final Institution institution = InstitutionMapper.institutionAUToEntity(
      teacherDetailsCseiio.institution,
    );
    final List<Event> events =
        teacherDetailsCseiio.data
            .map((e) => EventMapper.eventCseiioToEntity(e.event))
            .toList();

    return {'institution': institution, 'events': events};
  }
}
