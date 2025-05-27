import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/teacher.dart';
import '../storage/local_teachers_provider.dart';
import '../teachers/teachers_provider.dart';

final qrTeachaerProvider =
    StateNotifierProvider<QrTeacherNotifier, QrTeacherState>((ref) {
      final teacherCallback =
          ref.watch(getTeachersProvider.notifier).getTeacher;

      final summitTeacherCallBack =
          ref.watch(localTeachersProvider.notifier).toggleSaveOrRemove;

      return QrTeacherNotifier(
        teacherCallback: teacherCallback,
        summitTeacherCallback: summitTeacherCallBack,
      );
    });

typedef TeacherCallback = Future<Teacher> Function({required String id});
typedef SummitTeacherCallback = Future<void> Function(Teacher teacher);

class QrTeacherNotifier extends StateNotifier<QrTeacherState> {
  bool isLoading = false;
  TeacherCallback teacherCallback;
  SummitTeacherCallback summitTeacherCallback;

  QrTeacherNotifier({
    required this.teacherCallback,
    required this.summitTeacherCallback,
  }) : super(QrTeacherState());

  Future<void> changeQr(String idTeacher, int idAttendance) async {
    if (isLoading) return;
    isLoading = true;

    if (idTeacher == state.teacher?.id.toString()) {
      isLoading = false;
      return;
    }

    state = state.copyWith(isLoading: true);

    final Teacher getTeacher = await teacherCallback(id: idTeacher);
    getTeacher.idAttendance = idAttendance;

    state = state.copyWith(isLoading: false, teacher: getTeacher);
    isLoading = false;

    return;
  }

  Future<void> summit() async {
    if (isLoading) return;
    isLoading = true;

    if (state.teacher == null) {
      isLoading = false;
      return;
    }

    state = state.copyWith(isSummit: true);

    await summitTeacherCallback(state.teacher!);

    state = state.copyWith(isSummit: false, isTeacherNull: true);
    isLoading = false;
    return;
  }

  Future<void> cancelSummit() async {
    if (isLoading) return;
    isLoading = true;
    state = state.copyWith(isTeacherNull: true);
    isLoading = false;
    return;
  }
}

class QrTeacherState {
  final Teacher? teacher;
  final bool isLoading;
  final bool isSummit;

  QrTeacherState({this.teacher, this.isLoading = false, this.isSummit = false});

  QrTeacherState copyWith({
    Teacher? teacher,
    bool? isLoading,
    bool? isSummit,
    bool isTeacherNull = false,
  }) {
    if (isTeacherNull) {
      return QrTeacherState(
        teacher: null,
        isLoading: isLoading ?? this.isLoading,
        isSummit: isSummit ?? this.isSummit,
      );
    }
    return QrTeacherState(
      teacher: teacher ?? this.teacher,
      isLoading: isLoading ?? this.isLoading,
      isSummit: isSummit ?? this.isSummit,
    );
  }
}
