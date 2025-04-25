import '../../../infrastructure/datasources/teachers/teachers_cseiio_datasource_impl.dart';
import '../../../infrastructure/repositories/teachers/teachers_cseiio_repository_impl.dart';
import '../auth/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final teacherRepositoryProvider = Provider((ref) {
  final String accessToken = ref.watch(authProvider).user!.token;

  return TeachersCseiioRepositoryImpl(
    TeachersCseiioDatasourceImpl(accessToken: accessToken),
  );
});
