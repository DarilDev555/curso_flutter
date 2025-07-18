import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/entities.dart';

final sliverTeacherSelectProvider = StateNotifierProvider<
  SliverTeacherSelectNotifier,
  Map<String, TeacherCellState>
>((ref) {
  return SliverTeacherSelectNotifier();
});

class SliverTeacherSelectNotifier
    extends StateNotifier<Map<String, TeacherCellState>> {
  SliverTeacherSelectNotifier() : super({});

  bool isLoading = false;

  Future<void> loadTeachers(List<Teacher> teachersLoad) async {
    if (isLoading) return;
    isLoading = true;
    Map<String, TeacherCellState> newState = {};
    for (var teacherLoad in teachersLoad) {
      newState[teacherLoad.id.toString()] = TeacherCellState(
        teacher: teacherLoad,
        isOpen: false,
      );
    }
    state = newState;
    isLoading = false;
    return;
  }

  Future<void> touchTeacherCell({required String idTeacher}) async {
    if (isLoading) return;
    isLoading = true;
    if (state[idTeacher] == null) {
      isLoading = false;
      return;
    }
    state[idTeacher] = state[idTeacher]!.copyWith(isOpen: true);
    isLoading = false;
    return;
  }
}

class TeacherCellState {
  final Teacher teacher;
  final bool isOpen;

  TeacherCellState({required this.teacher, required this.isOpen});

  TeacherCellState copyWith({Teacher? teacher, bool? isOpen}) =>
      TeacherCellState(
        teacher: teacher ?? this.teacher,
        isOpen: isOpen ?? this.isOpen,
      );
}
