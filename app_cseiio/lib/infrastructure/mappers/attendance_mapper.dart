import '../../domain/entities/attendance.dart';
import 'register_mapper.dart';
import '../models/api_cseiio/api_cseiio.dart';

class AttendanceMapper {
  static Attendance attendanceCseiioToEntity(
    AttendanceResponseCseiio attendanceResponseCseiio,
  ) => Attendance(
    id: attendanceResponseCseiio.id,
    eventDayId: attendanceResponseCseiio.eventDayId,
    name: attendanceResponseCseiio.name,
    descripcion: attendanceResponseCseiio.descripcion,
    attendanceTime: attendanceResponseCseiio.attendanceTime,
    createdAt: attendanceResponseCseiio.createdAt,
    updatedAt: attendanceResponseCseiio.updatedAt,
    register:
        attendanceResponseCseiio.register != null
            ? RegisterMapper.registerCseiioToEntity(
              attendanceResponseCseiio.register!,
            )
            : null,
  );
}
