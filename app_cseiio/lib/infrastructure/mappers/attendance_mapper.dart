import '../../domain/entities/attendance.dart';
import 'register_mapper.dart';
import '../models/api_cseiio/api_cseiio.dart';

class AttendanceMapper {
  static Attendance attendanceCseiioToEntity(
    AttendanceResponseCseiio attendanceResponseCseiio,
  ) => Attendance(
    id: attendanceResponseCseiio.id.toString(),
    eventDayId: attendanceResponseCseiio.eventDayId.toString(),
    name: attendanceResponseCseiio.name,
    descripcion: attendanceResponseCseiio.descripcion,
    attendanceTime: attendanceResponseCseiio.attendanceTime,
    register:
        attendanceResponseCseiio.register != null
            ? RegisterMapper.registerCseiioToEntity(
              attendanceResponseCseiio.register!,
            )
            : null,
  );
}
