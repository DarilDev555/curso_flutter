import '../../domain/entities/role.dart';
import '../models/api_cseiio/role/role_response_cseiio.dart';

class RoleMapper {
  static Role roleCseiioToEntity(RoleResponseCseiio roleResponseCseiio) =>
      Role(id: roleResponseCseiio.id, name: roleResponseCseiio.name);
}
