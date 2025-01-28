import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movil_app_uesa/domain/entities/teacher.dart';
import 'package:movil_app_uesa/presentations/providers/teachers/teachers_repository_provider.dart';

final getTeachersProvider =
    StateNotifierProvider<TeachersNotifier, List<Teacher>>(
  (ref) {
    final fetchgetTeachers2 = ref.watch(teacherRepositoryProvider).getTeachers;

    return TeachersNotifier(fetchgetTeachers: fetchgetTeachers2);
  },
);

typedef TeacherCallback = Future<List<Teacher>> Function();

class TeachersNotifier extends StateNotifier<List<Teacher>> {
  bool isLoading = false;
  TeacherCallback fetchgetTeachers;

  TeachersNotifier({required this.fetchgetTeachers}) : super([]);

  Future<void> loadTeachers() async {
    if (isLoading) return;

    isLoading = true;
    final List<Teacher> teachers = await fetchgetTeachers();
    state = teachers;
    isLoading = false;
  }
}
