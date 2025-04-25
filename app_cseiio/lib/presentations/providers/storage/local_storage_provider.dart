import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../infrastructure/datasources/local/isar_datasource.dart';
import '../../../infrastructure/repositories/local/local_storage_repository_impl.dart';

final localStorageRepositoryProvider = Provider((ref) {
  return LocalStorageRepositoryImpl(datasource: IsarDatasource());
});
