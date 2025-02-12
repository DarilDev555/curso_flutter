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

typedef TeacherCallback = Future<List<Teacher>> Function({int page});

class TeachersNotifier extends StateNotifier<List<Teacher>> {
  int currentPage = 0;
  bool isLoading = false;
  int ultimaPeticon = 10;
  TeacherCallback fetchgetTeachers;

  TeachersNotifier({required this.fetchgetTeachers}) : super([]);

  Future<void> loadTeachers() async {
    if (isLoading) return;

    isLoading = true;
    final List<Teacher> teachers = await fetchgetTeachers(page: currentPage);
    print(
        'teachers ${teachers.length} ultimapeticion ${ultimaPeticon} currentpage $currentPage');

    if (teachers.isEmpty) {
      isLoading = false;
      return;
    }

    if (teachers.length == 10 && ultimaPeticon == 10) {
      currentPage++;
      ultimaPeticon = teachers.length;
      state.addAll(teachers);
      isLoading = false;
      return;
    }
    if (teachers.length > ultimaPeticon) {
      for (var i = ultimaPeticon; i < teachers.length; i++) {
        state = [...state, teachers[i]];
      }

      ultimaPeticon = teachers.length;
      isLoading = false;
      teachers.length == 10 ? currentPage++ : 0;
      return;
    }
    // ultima ueron 10 pero la entrega son menores
    if (ultimaPeticon == 10) {
      state.addAll(teachers);

      ultimaPeticon = teachers.length;
      isLoading = false;
      return;
    }
    isLoading = false;
  }
}
