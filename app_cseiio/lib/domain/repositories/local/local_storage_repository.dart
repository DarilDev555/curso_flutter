import '../../entities/teacher.dart';

abstract class LocalStorageRepository {
  Future<void> toggleSaveOrRemove(Teacher teacher);

  Future<List<Teacher>> loadTeachers(int idAttendance);

  Future<bool> isTeacherOnDBs(int teacherId, int idEvent, int idDayEvent);

  Future<bool> saveTeacher(Teacher teacher);

  Future<bool> removeTeacher(Teacher teacher);
}
