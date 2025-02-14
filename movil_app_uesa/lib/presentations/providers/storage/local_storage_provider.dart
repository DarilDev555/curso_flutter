import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movil_app_uesa/infrastructure/datasource/isar_datasource.dart';
import 'package:movil_app_uesa/infrastructure/repositories/local_storage_repository_impl.dart';

final localStorageRepositoryProvider = Provider(
  (ref) {
    return LocalStorageRepositoryImpl(datasource: IsarDatasource());
  },
);
