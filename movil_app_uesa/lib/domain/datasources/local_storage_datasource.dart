import 'package:movil_app_uesa/domain/entities/teacher.dart';

abstract class LocalStorageDatasource {
  Future<void> toggleSaveOrRemove(Teacher teacher);

  Future<List<Teacher>> loadTeachers();

  Future<bool> isTeacherOnDBs(int teacherId);
}
