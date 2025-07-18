import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/entities.dart';
import 'teachers_repository_provider.dart';

final getTeacherProvider =
    StateNotifierProvider<TeacherNotifier, Map<String, Teacher>>((ref) {
      final getTeacherByIdCallback =
          ref.watch(teacherRepositoryProvider).getTeacherById;

      return TeacherNotifier(getTeacherByIdCallback: getTeacherByIdCallback);
    });

typedef GetTeacherByIdCallback = Future<Teacher> Function({required String id});

class TeacherNotifier extends StateNotifier<Map<String, Teacher>> {
  final GetTeacherByIdCallback getTeacherByIdCallback;
  bool isLoading = false;
  TeacherNotifier({required this.getTeacherByIdCallback}) : super({});

  Future<void> getTeacher(String idTeacher) async {
    if (isLoading) return;
    isLoading = true;

    if (state[idTeacher] != null) {
      isLoading = false;
      return;
    }

    final Teacher teacher = await getTeacherByIdCallback(id: idTeacher);

    state = {...state, idTeacher: teacher};
    isLoading = false;
    return;
  }
}
