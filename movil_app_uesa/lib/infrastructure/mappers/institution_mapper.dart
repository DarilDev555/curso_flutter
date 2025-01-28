import 'package:movil_app_uesa/domain/entities/institution.dart';
import 'package:movil_app_uesa/infrastructure/models/teacherau/institution_teacherinstitution.dart';

class InstitutionMapper {
  static Institution institutionAUToEntity(InstitutionAU institutionAU) {
    return Institution(
      id: institutionAU.id,
      locationId: institutionAU.locationId,
      code: institutionAU.code,
      name: institutionAU.name,
      createdAt: institutionAU.createdAt,
      updatedAt: institutionAU.updatedAt,
    );
  }
}
