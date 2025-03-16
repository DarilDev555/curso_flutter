import 'package:app_cseiio/domain/datasources/local/local_storage_datasource.dart';
import 'package:app_cseiio/domain/entities/teacher.dart';
import 'package:app_cseiio/domain/repositories/local/local_storage_repository.dart';

class LocalStorageRepositoryImpl extends LocalStorageRepository {
  final LocalStorageDatasource datasource;

  LocalStorageRepositoryImpl({required this.datasource});

  @override
  Future<bool> isTeacherOnDBs(int teacherId, int idEvent, int idDayEvent) {
    return datasource.isTeacherOnDBs(teacherId, idEvent, idDayEvent);
  }

  @override
  Future<List<Teacher>> loadTeachers(int idEvent, int idDayEvent) {
    return datasource.loadTeachers(idEvent, idDayEvent);
  }

  @override
  Future<void> toggleSaveOrRemove(Teacher teacher) {
    return datasource.toggleSaveOrRemove(teacher);
  }
}
