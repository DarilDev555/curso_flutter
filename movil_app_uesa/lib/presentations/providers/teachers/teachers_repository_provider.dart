import 'package:movil_app_uesa/infrastructure/datasource/teachers_au_datasource.dart';
import 'package:movil_app_uesa/infrastructure/repositories/teachers_au_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final teacherRepositoryProvider = Provider(
  (ref) {
    return TeachersauRepositoryImpl(TeachersauDatasource());
  },
);
