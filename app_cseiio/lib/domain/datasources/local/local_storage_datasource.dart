import 'package:app_cseiio/domain/entities/teacher.dart';

abstract class LocalStorageDatasource {
  Future<void> toggleSaveOrRemove(Teacher teacher);

  Future<List<Teacher>> loadTeachers(int idEvent, int idDayEvent);

  Future<bool> isTeacherOnDBs(int teacherId, int idEvent, int idDayEvent);
}
