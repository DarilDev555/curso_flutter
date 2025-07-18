import 'package:dio/dio.dart';

import '../../../config/const/environment.dart';
import '../../../domain/datasources/attendance/attendance_datasource.dart';
import '../../../domain/entities/attendance.dart';
import '../../mappers/attendance_mapper.dart';
import '../../models/api_cseiio/api_cseiio.dart';

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
}
