import 'package:dio/dio.dart';

import '../../../config/const/environment.dart';
import '../../../domain/datasources/attendance/attendance_datasource.dart';
import '../../../domain/entities/attendance.dart';
import '../../mappers/attendance_mapper.dart';
import '../../models/api_cseiio/api_cseiio.dart';
import '../../models/api_cseiio/attendance/attendance_isvalidate_form_response_cseiio.dart';

class AttendanceDatasourceImpl extends AttendanceDatasource {
  final String accessToken;
  final Dio dio;

  AttendanceDatasourceImpl({required this.accessToken})
    : dio = Dio(
        BaseOptions(
          baseUrl: Environment.apiUrl,
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Accept': 'application/json',
          },
        ),
      );

  @override
  Future<Attendance> getAttendance(String idAttendance) async {
    final response = await dio.get('/attendance/$idAttendance');

    final AttendanceResponseCseiio attendanceResponseCseiio =
        AttendanceResponseCseiio.fromJson(response.data);

    return AttendanceMapper.attendanceCseiioToEntity(attendanceResponseCseiio);
  }

  @override
  Future<Map<String, dynamic>> checkAttendance(
    String name,
    String description,
    String attendanceTime,
  ) async {
    final response = await dio.post(
      '/attendanceIsValidate',
      data: {
        'name': name,
        'description': description,
        'attendance_time': attendanceTime,
      },
    );

    final attendanceResponse = AttendanceIsValidateFormResponseCseiio.fromJson(
      response.data,
    );
    if (attendanceResponse.valid) {
      return {};
    }
    return {
      'isValid': attendanceResponse.valid,
      'name': attendanceResponse.errors!.name,
      'description': attendanceResponse.errors!.descripcion,
      'attendance_time': attendanceResponse.errors!.attendanceTime,
    };
  }
}
