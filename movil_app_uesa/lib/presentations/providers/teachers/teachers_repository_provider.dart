import 'package:movil_app_uesa/infrastructure/datasource/teachersAU_datasource.dart';
import 'package:movil_app_uesa/infrastructure/repositories/teachersAU_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final teacherRepositoryProvider = Provider(
  (ref) {
    return TeachersauRepositoryImpl(TeachersauDatasource());
  },
);
