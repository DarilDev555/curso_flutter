import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/teacher.dart';
import '../../../domain/repositories/local/local_storage_repository.dart';
import 'local_storage_provider.dart';

final localTeachersProvider =
    StateNotifierProvider<StorageTeachersNotifier, Map<int, List<Teacher>>>((
      ref,
    ) {
      final localStorageRepository = ref.watch(localStorageRepositoryProvider);
      return StorageTeachersNotifier(
        localStorageRepository: localStorageRepository,
      );
    });

class StorageTeachersNotifier extends StateNotifier<Map<int, List<Teacher>>> {
  final LocalStorageRepository localStorageRepository;
  int cont = 0;
  bool isLoading = false;

  StorageTeachersNotifier({required this.localStorageRepository}) : super({});

  Future<List<Teacher>> loadTeachers(int idAttendance) async {
    final teachers = await localStorageRepository.loadTeachers(idAttendance);

    state = {...state, idAttendance: teachers};

    return teachers;
  }

  Future<void> toggleSaveOrRemove(Teacher teacher) async {
    await localStorageRepository.toggleSaveOrRemove(teacher);
    final bool isAttendanceInState = state[teacher.idAttendance] != null;
    bool isTeacherInState = false;
    if (isAttendanceInState) {
      isTeacherInState = state[teacher.idAttendance]!.any(
        (element) => element.id == teacher.id,
      );
    }

    if (isTeacherInState) {
      final listteacherRemove = state[teacher.idAttendance]!;
      listteacherRemove.removeWhere((element) => element.id == teacher.id);
      state = {...state, teacher.idAttendance!: listteacherRemove};
    } else {
      (isAttendanceInState)
          ? state = {
            ...state,
            teacher.idAttendance!: [...state[teacher.idAttendance!]!, teacher],
          }
          : state = {
            ...state,
            teacher.idAttendance!: [teacher],
          };
    }
  }

  Future<void> saveTeacher(Teacher teacher) async {
    if (isLoading) return;
    isLoading = true;

    final bool save = await localStorageRepository.saveTeacher(teacher);
    if (!save) {
      isLoading = false;
      return;
    }
    final bool isAttendanceInState = state[teacher.idAttendance] != null;

    (isAttendanceInState)
        ? state = {
          ...state,
          teacher.idAttendance!: [...state[teacher.idAttendance!]!, teacher],
        }
        : state = {
          ...state,
          teacher.idAttendance!: [teacher],
        };
    isLoading = false;
    return;
  }

  Future<void> removeTeacher(Teacher teacher) async {
    if (isLoading) return;
    isLoading = true;

    final bool save = await localStorageRepository.removeTeacher(teacher);
    if (!save) return;

    final listteacherRemove = state[teacher.idAttendance]!;
    listteacherRemove.removeWhere((element) => element.id == teacher.id);
    state = {...state, teacher.idAttendance!: listteacherRemove};

    isLoading = false;
    return;
  }
}
