import 'package:movil_app_uesa/domain/entities/teacher.dart';
import 'package:movil_app_uesa/infrastructure/models/teacherau/teacher_teachersau.dart';

class TeacherMapper {
  static Teacher teacherAUToEntity(TeacherResponseAU teacherAU,
          {required String baseUrlImage}) =>
      Teacher(
        id: teacherAU.id,
        institutionId: teacherAU.institutionId,
        firstName: teacherAU.firstName,
        paternalLastName: teacherAU.paternalLastName,
        maternalLastName: teacherAU.maternalLastName,
        gender: teacherAU.gender,
        electoralCode: teacherAU.electoralCode,
        email: teacherAU.email,
        curp: teacherAU.curp,
        dateRegister: teacherAU.dateRegister,
        avatar: teacherAU.avatar != null
            // ? 'http://192.168.0.227:8000/${teacherAU.avatar}'
            ? '$baseUrlImage${teacherAU.avatar}'
            : 'https://tnsatlanta.org/wp-content/themes/tns-sixteen/images/img_headshot.png',
        createdAt: teacherAU.createdAt,
        updatedAt: teacherAU.updatedAt,
      );
}
