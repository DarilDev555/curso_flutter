import 'package:movil_app_uesa/domain/datasources/local_storage_datasource.dart';
import 'package:movil_app_uesa/domain/entities/teacher.dart';
import 'package:movil_app_uesa/domain/repositories/local_storage_repository.dart';

class LocalStorageRepositoryImpl extends LocalStorageRepository {
  final LocalStorageDatasource datasource;

  LocalStorageRepositoryImpl({
    required this.datasource,
  });

  @override
  Future<bool> isTeacherOnDBs(int teacherId) {
    return datasource.isTeacherOnDBs(teacherId);
  }

  @override
  Future<List<Teacher>> loadTeachers() {
    return datasource.loadTeachers();
  }

  @override
  Future<void> toggleSaveOrRemove(Teacher teacher) {
    return datasource.toggleSaveOrRemove(teacher);
  }
}
