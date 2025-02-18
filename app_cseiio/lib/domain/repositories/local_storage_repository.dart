import 'package:app_cseiio/domain/entities/teacher.dart';

abstract class LocalStorageRepository {
  Future<void> toggleSaveOrRemove(Teacher teacher);

  Future<List<Teacher>> loadTeachers();

  Future<bool> isTeacherOnDBs(int teacherId);
}
