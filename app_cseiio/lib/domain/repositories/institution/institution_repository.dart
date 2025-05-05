import '../../entities/institution.dart';

abstract class InstitutionRepository {
  Future<List<Institution>> getInstitution({int page = 0});

  Future<Institution> getInstitutionById({required String id});

  Future<Institution> searchInstitutions({String? name, String? code});
}
