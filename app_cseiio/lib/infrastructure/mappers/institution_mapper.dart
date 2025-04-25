import '../../domain/entities/institution.dart';
import 'location_mapper.dart';
import '../models/api_cseiio/institution/institution_response_cseiio.dart';

class InstitutionMapper {
  static Institution institutionAUToEntity(
    InstitutionRespondeCseiio institutioncseiio,
  ) {
    return Institution(
      id: institutioncseiio.id,
      location: LocationMapper.locationCseiioToEntity(
        institutioncseiio.location,
      ),
      code: institutioncseiio.code,
      name: institutioncseiio.name,
      createdAt: institutioncseiio.createdAt,
      updatedAt: institutioncseiio.updatedAt,
    );
  }
}
