import '../../domain/entities/register.dart';
import '../models/api_cseiio/attendance/register/register_response_cseiio.dart';

class RegisterMapper {
  static Register registerCseiioToEntity(
    RegisterResponseCseiio registerResponseCseiio,
  ) => Register(
    id: registerResponseCseiio.id.toString(),
    attendanceTeacherId: registerResponseCseiio.attendanceTeacherId.toString(),
    userId: registerResponseCseiio.userId.toString(),
    registerTime: registerResponseCseiio.registerTime,
  );
}
