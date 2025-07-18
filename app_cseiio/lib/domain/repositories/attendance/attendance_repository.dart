import '../../entities/attendance.dart';

abstract class AttendanceRepository {
  Future<Attendance> getAttendance(String idAttendance);
}
