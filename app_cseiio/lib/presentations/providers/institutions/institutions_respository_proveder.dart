import '../../../infrastructure/datasources/institution/institution_datasource_impl.dart';
import '../../../infrastructure/repositories/institution/institution_repository_impl.dart';
import '../auth/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final institutionsRepositoryProvider = Provider((ref) {
  final user = ref.watch(authProvider).user;

  return InstitutionRepositoryImpl(
    datasource: InstitutionDatasourceImpl(
      accessToken: user == null ? '' : user.token,
    ),
  );
});
