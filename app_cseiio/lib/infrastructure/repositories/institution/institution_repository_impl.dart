import '../../../domain/datasources/institution/institution_datasource.dart';
import '../../../domain/entities/institution.dart';
import '../../../domain/repositories/institution/institution_repository.dart';

class InstitutionRepositoryImpl extends InstitutionRepository {
  final InstitutionDatasource datasource;

  InstitutionRepositoryImpl({required this.datasource});

  @override
  Future<List<Institution>> getInstitution({int page = 0}) {
    return datasource.getInstitution(page: page);
  }

  @override
  Future<Institution> getInstitutionById({required String id}) {
    return datasource.getInstitutionById(id: id);
  }
}
