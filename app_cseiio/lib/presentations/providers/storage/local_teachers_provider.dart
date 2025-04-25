import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/teacher.dart';
import '../../../domain/repositories/local/local_storage_repository.dart';
import 'local_storage_provider.dart';

final localTeachersProvider =
    StateNotifierProvider<StorageTeachersNotifier, Map<int, Teacher>>((ref) {
      final localStorageRepository = ref.watch(localStorageRepositoryProvider);
      return StorageTeachersNotifier(
        localStorageRepository: localStorageRepository,
      );
    });

class StorageTeachersNotifier extends StateNotifier<Map<int, Teacher>> {
  final LocalStorageRepository localStorageRepository;
  int cont = 0;

  StorageTeachersNotifier({required this.localStorageRepository}) : super({});

  Future<List<Teacher>> loadTeachers() async {
    final teachers = await localStorageRepository.loadTeachers();

    final tempTeacherMap = <int, Teacher>{};
    for (var teacher in teachers) {
      tempTeacherMap[teacher.id] = teacher;
    }

    state = {...state, ...tempTeacherMap};

    return teachers;
  }

  Future<void> toggleSaveOrRemove(Teacher teacher) async {
    await localStorageRepository.toggleSaveOrRemove(teacher);
    final bool isTeacherInState = state[teacher.id] != null;

    if (isTeacherInState) {
      state.remove(teacher.id);
      state = {...state};
    } else {
      state = {...state, teacher.id: teacher};
    }
  }
}
