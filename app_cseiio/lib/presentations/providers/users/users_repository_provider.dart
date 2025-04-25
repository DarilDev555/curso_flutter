import '../../../infrastructure/datasources/users/users_datasource_impl.dart';
import '../../../infrastructure/repositories/users/users_repository_impl.dart';
import '../auth/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final usersRepositoryProvider = Provider((ref) {
  final String accessToken = ref.watch(authProvider).user!.token;

  return UsersRepositoryImpl(
    usersDatasource: UsersDatasourceImpl(accessToken: accessToken),
  );
});
