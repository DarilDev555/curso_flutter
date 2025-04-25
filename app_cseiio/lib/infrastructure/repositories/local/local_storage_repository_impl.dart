import '../../../domain/datasources/local/local_storage_datasource.dart';
import '../../../domain/entities/teacher.dart';
import '../../../domain/repositories/local/local_storage_repository.dart';

class LocalStorageRepositoryImpl extends LocalStorageRepository {
  final LocalStorageDatasource datasource;

  LocalStorageRepositoryImpl({required this.datasource});

  @override
  Future<bool> isTeacherOnDBs(int teacherId, int idEvent, int idDayEvent) {
    return datasource.isTeacherOnDBs(teacherId, idEvent, idDayEvent);
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
