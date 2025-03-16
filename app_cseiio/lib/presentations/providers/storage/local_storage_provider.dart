import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_cseiio/infrastructure/datasources/local/isar_datasource.dart';
import 'package:app_cseiio/infrastructure/repositories/local/local_storage_repository_impl.dart';

final localStorageRepositoryProvider = Provider((ref) {
  return LocalStorageRepositoryImpl(datasource: IsarDatasource());
});
