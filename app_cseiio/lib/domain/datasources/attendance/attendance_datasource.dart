import '../../entities/attendance.dart';

abstract class AttendanceDatasource {
  Future<Attendance> getAttendance(String idAttendance);
}
