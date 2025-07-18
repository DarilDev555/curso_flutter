import '../../../domain/datasources/attendance/attendance_datasource.dart';
import '../../../domain/entities/attendance.dart';
import '../../../domain/repositories/attendance/attendance_repository.dart';

class AttendanceRepositoryImpl extends AttendanceRepository {
  final AttendanceDatasource attendanceDatasource;

  AttendanceRepositoryImpl({required this.attendanceDatasource});

  @override
  Future<Attendance> getAttendance(String idAttendance) {
    return attendanceDatasource.getAttendance(idAttendance);
  }
}
