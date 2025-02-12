import 'package:isar/isar.dart';
import 'package:movil_app_uesa/domain/entities/teacher.dart';

import 'package:movil_app_uesa/domain/datasources/local_storage_datasource.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatasource extends LocalStorageDatasource {
  late Future<Isar> db;

  IsarDatasource() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [TeacherSchema],
        directory: dir.path,
        inspector: true,
      );
    }

    return Future.value(Isar.getInstance());
  }

  @override
  Future<bool> isTeacherOnDBs(int teacherId) async {
    final isar = await db;

    final Teacher? isTeacherOnDB =
        await isar.teachers.filter().idEqualTo(teacherId).findFirst();

    return isTeacherOnDB != null;
  }

  @override
  Future<List<Teacher>> loadTeachers({int limit = 10, offset = 0}) async {
    final isar = await db;

    return isar.teachers.where().offset(offset).limit(limit).findAll();
  }

  @override
  Future<void> toggleSaveOrRemove(Teacher teacher) async {
    final isar = await db;

    final isTeacherOnDb =
        await isar.teachers.filter().idEqualTo(teacher.id).findFirst();

    if (isTeacherOnDb != null) {
      isar.writeTxnSync(
        () => isar.teachers.deleteSync(isTeacherOnDb.isarId!),
      );
      return;
    }

    isar.writeTxnSync(
      () => isar.teachers.putSync(teacher),
    );
  }
}
