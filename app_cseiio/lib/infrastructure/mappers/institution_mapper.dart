import 'package:app_cseiio/domain/entities/institution.dart';
import 'package:app_cseiio/infrastructure/models/api_cseiio/institution/institution_response_cseiio.dart';

class InstitutionMapper {
  static Institution institutionAUToEntity(InstitutionCseiio institutionAU) {
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
