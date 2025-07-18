import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/teacher.dart';
import 'teachers_repository_provider.dart';

//Provider
final getTeachersAndAttendanceToEventDayProvider = StateNotifierProvider<
  TeachersAndAttendanceToEventDayNotifier,
  Map<String, List<Teacher>>
>((ref) {
  final fetchgetTeachers2 =
      ref.watch(teacherRepositoryProvider).getTeacherAndAttendanceToEventDay;

  return TeachersAndAttendanceToEventDayNotifier(
    fetchgetTeachers: fetchgetTeachers2,
  );
});

typedef TeachersAndAttendanceToEventDayCallback =
    Future<List<Teacher>> Function({required String id, int page});

//Notifier
class TeachersAndAttendanceToEventDayNotifier
    extends StateNotifier<Map<String, List<Teacher>>> {
  Map<String, int> currentPage = {};
  bool isLoading = false;
  Map<String, int> ultimaPeticon = {};
  TeachersAndAttendanceToEventDayCallback fetchgetTeachers;

  TeachersAndAttendanceToEventDayNotifier({required this.fetchgetTeachers})
    : super({});

  Future<void> loadTeachers(String id) async {
    if (isLoading) return;

    isLoading = true;
    currentPage[id] =
        currentPage[id] == null ? currentPage[id] = 0 : currentPage[id]!;
    final List<Teacher> teachers = await fetchgetTeachers(
      id: id,
      page: currentPage[id]!,
    );

    if (teachers.isEmpty) {
      isLoading = false;
      return;
    }

    final newState = Map<String, List<Teacher>>.from(state);

    if (teachers.length == 10 &&
        (ultimaPeticon[id] == null || ultimaPeticon[id] == 10)) {
      currentPage[id] = currentPage[id]! + 1;
      ultimaPeticon[id] = teachers.length;

      newState[id] = [...?newState[id], ...teachers];
      state = newState;

      isLoading = false;
      return;
    }
    if (teachers.length > ultimaPeticon[id]!) {
      List<Teacher> teachersAux = [];

      for (var i = ultimaPeticon[id]!; i < teachers.length; i++) {
        teachersAux = [...teachersAux, teachers[i]];
      }

      newState[id] = [...?newState[id], ...teachersAux];
      state = newState;

      ultimaPeticon[id] = teachers.length;
      isLoading = false;
      teachers.length == 10 ? currentPage[id] = currentPage[id]! + 1 : 0;
      return;
    }
    // ultima ueron 10 pero la entrega son menores
    if (ultimaPeticon[id] == 10) {
      newState[id] = [...?newState[id], ...teachers];
      state = newState;

      ultimaPeticon[id] = teachers.length;
      isLoading = false;
      return;
    }
    isLoading = false;
  }
}
