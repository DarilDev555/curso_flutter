import 'package:movil_app_uesa/domain/entities/teacher.dart';

abstract class LocalStorageDatasource {
  Future<void> toggleSaveOrRemove(Teacher teacher);

  Future<List<Teacher>> loadTeachers({int limit = 10, offset = 0});

  Future<bool> isTeacherOnDBs(int teacherId);
}
