import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_cseiio/infrastructure/datasource/isar_datasource.dart';
import 'package:app_cseiio/infrastructure/repositories/local_storage_repository_impl.dart';

final localStorageRepositoryProvider = Provider((ref) {
  return LocalStorageRepositoryImpl(datasource: IsarDatasource());
});
