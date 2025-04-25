import '../../domain/entities/teacher.dart';
import 'attendance_mapper.dart';
import '../models/api_cseiio/teachers/teacher_response_cseiio.dart';

class TeacherMapper {
  static Teacher teacherCseiioToEntity(
    TeacherResponseCseiio teacherResponseCseiio, {
    required String baseUrlImage,
  }) => Teacher(
    id: teacherResponseCseiio.id,
    institutionId: teacherResponseCseiio.institutionId,
    userId: teacherResponseCseiio.userId,
    firstName: teacherResponseCseiio.firstName,
    paternalLastName: teacherResponseCseiio.paternalLastName,
    maternalLastName: teacherResponseCseiio.maternalLastName,
    gender: teacherResponseCseiio.gender,
    electoralCode: teacherResponseCseiio.electoralCode,
    email: teacherResponseCseiio.email,
    curp: teacherResponseCseiio.curp,
    dateRegister: teacherResponseCseiio.dateRegister,
    avatar:
        teacherResponseCseiio.avatar != null
            // ? 'http://192.168.0.227:8000/${teacherAU.avatar}'
            ? '$baseUrlImage/${teacherResponseCseiio.avatar}'
            : 'https://tnsatlanta.org/wp-content/themes/tns-sixteen/images/img_headshot.png',
    createdAt: teacherResponseCseiio.createdAt,
    updatedAt: teacherResponseCseiio.updatedAt,
    attendance:
        teacherResponseCseiio.attendances
            ?.map(AttendanceMapper.attendanceCseiioToEntity)
            .toList(),
  );
}
