import '../../entities/attendance.dart';

abstract class AttendanceRepository {
  Future<Attendance> getAttendance(String idAttendance);
  Future<Map<String, dynamic>> checkAttendance(
    String name,
    String description,
    String attendanceTime,
  );
}
