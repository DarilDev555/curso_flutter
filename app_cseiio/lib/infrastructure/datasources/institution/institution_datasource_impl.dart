import '../../../config/const/environment.dart';
import '../../../domain/datasources/institution/institution_datasource.dart';
import '../../../domain/entities/institution.dart';
import '../../mappers/institution_mapper.dart';
import '../../models/api_cseiio/api_cseiio.dart';
import 'package:dio/dio.dart';

import '../../../presentations/errors/auth_errors.dart';

class InstitutionDatasourceImpl extends InstitutionDatasource {
  final String accessToken;
  final Dio dio;

  InstitutionDatasourceImpl({required this.accessToken})
    : dio = Dio(
        BaseOptions(
          baseUrl: Environment.apiUrl,
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Accept': 'application/json',
          },
        ),
      );

  @override
  Future<List<Institution>> getInstitution({int page = 0}) async {
    try {
      final response = await dio.get(
        '/institution',
        queryParameters: {'page': page},
      );

      final institutionCseiioResponse = InstitutionsResponseCseiio.fromJson(
        response.data,
      );

      return institutionCseiioResponse.institutions
          .map(InstitutionMapper.institutionAUToEntity)
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(message: 'Token incorrecto');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError(message: 'Revisar conexion a internet');
      }
      throw Exception();
    } on Exception catch (_) {
      throw Exception();
    }
  }

  @override
  Future<Institution> getInstitutionById({required String id}) async {
    final response = await dio.get('/institution/$id');
    final InstitutionRespondeCseiio institutionRespondeCseiio =
        InstitutionRespondeCseiio.fromJson(response.data);

    return InstitutionMapper.institutionAUToEntity(institutionRespondeCseiio);
  }

  @override
  Future<List<Institution>> searchInstitutions({
    String? name,
    String? code,
  }) async {
    throw Exception();
    try {
      final response = await dio.get(
        '/institutions/search',
        queryParameters: {'name': name, 'code': code},
      );

      final institutionCseiioResponse = InstitutionsResponseCseiio.fromJson(
        response.data,
      );

      return institutionCseiioResponse.institutions
          .map(InstitutionMapper.institutionAUToEntity)
          .toList();
    } catch (e) {}
  }
}
