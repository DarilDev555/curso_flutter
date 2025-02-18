import 'package:cinemapedia_nt/infrastructure/datasource/isar_datasource.dart';
import 'package:cinemapedia_nt/infrastructure/repositories/local_storage_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localStorageRepositoryProvider = Provider((ref) {
  return LocalStorageRepositoryImpl(datasource: IsarDatasource());
});
