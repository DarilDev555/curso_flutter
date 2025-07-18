// ignore_for_file: file_names

import '../../../config/const/environment.dart';
import '../../../domain/datasources/teachers/teachers_datasource.dart';
import '../../../domain/entities/entities.dart';
import '../../../presentations/errors/auth_errors.dart';
import '../../../presentations/errors/teacher_summit_error.dart';
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
    try {
      final response = await dio.get('/teacher/$id');

      if (response.statusCode != 200) {
        throw Exception('Teacher with id: $id not found');
      }

      final teacherResponse = TeacherResponseCseiio.fromJson(response.data);

      final teacher = TeacherMapper.teacherCseiioToEntity(
        teacherResponse,
        baseUrlImage: Environment.apiUrl,
      );

      return teacher;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Teacher>> getTeacherAndAttendanceToEventDay({
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

  @override
  Future<Teacher> regiterAttendance({
    required String idTeacher,
    required String idAttendance,
  }) async {
    try {
      final response = await dio.post(
        '/register-attendance',
        data: {'id_teacher': idTeacher, 'id_attendance': idAttendance},
      );

      final teacherResponse = TeacherResponseCseiio.fromJson(response.data);

      final Teacher teacher = TeacherMapper.teacherCseiioToEntity(
        teacherResponse,
        baseUrlImage: Environment.apiUrl,
      );

      return teacher;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Teacher>> getTeachersToattendance({
    required String idAttendance,
    int page = 0,
  }) async {
    try {
      final response = await dio.get(
        '/teachersToAttendance',
        queryParameters: {'page': page, 'id_attendance': idAttendance},
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

  @override
  Future<Teacher> summitTeacherToAttendance(
    String idAttendance,
    String idTeacher,
  ) async {
    try {
      final response = await dio.post(
        '/summitTeacherToAttendance',
        data: {'id_attendance': idAttendance, 'id_teacher': idTeacher},
      );
      final teacherResponse = TeacherResponseCseiio.fromJson(
        response.data['teacher'],
      );

      return TeacherMapper.teacherCseiioToEntity(
        teacherResponse,
        baseUrlImage: Environment.apiUrl,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
          message: e.response?.data['message'] ?? 'Sesión expirada',
        );
      }
      if (e.response?.statusCode == 409 &&
          e.response?.data['message'] == 'Ya hay una asistencia registrada') {
        final teacherResponse = TeacherResponseCseiio.fromJson(
          e.response!.data['teacher'],
        );

        final teacherWithRegister = TeacherMapper.teacherCseiioToEntity(
          teacherResponse,
          baseUrlImage: Environment.apiUrl,
        );

        throw TeacherSummitError(
          message: e.response?.data['message'],
          errorCode: e.response!.statusCode.toString(),
          teahcer: teacherWithRegister,
        );
      }
      throw Exception();
    } on Exception catch (_) {
      throw Exception();
    }
  }
}
