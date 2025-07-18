import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../infrastructure/datasources/attendance/attendance_datasource_impl.dart';
import '../../../infrastructure/repositories/attendance/attendance_repository_impl.dart';
import '../auth/auth_provider.dart';

final attendanceRepositoryProvider = Provider((ref) {
  final String accessToken = ref.watch(authProvider).user!.token;

  return AttendanceRepositoryImpl(
    attendanceDatasource: AttendanceDatasourceImpl(accessToken: accessToken),
  );
});
