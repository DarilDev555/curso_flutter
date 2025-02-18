import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_cseiio/infrastructure/datasource/login_register_au_datasource_impl.dart';
import 'package:app_cseiio/infrastructure/repositories/login_register_au_repository_impl.dart';

final loginRepositoryProvider = Provider((ref) {
  return LoginRegisterAuRepositoryImpl(LoginRegisterAuDatasourceImpl());
});
