import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/teacher.dart';
import '../../../domain/entities/user.dart';
import '../auth/auth_provider.dart';
import '../storage/local_teachers_provider.dart';
import '../teachers/teachers_provider.dart';
import '../teachers/teachers_repository_provider.dart';

final qrTeachaerProvider =
    StateNotifierProvider<QrTeacherNotifier, QrTeacherState>((ref) {
      final teacherCallback =
          ref.watch(getTeachersProvider.notifier).getTeacher;

      final saveTeacherCallBack =
          ref.watch(localTeachersProvider.notifier).saveTeacher;

      final user = ref.watch(authProvider).user!;

      final registerAttendanceCallBack =
          ref.watch(teacherRepositoryProvider).regiterAttendance;

      return QrTeacherNotifier(
        teacherCallback: teacherCallback,
        saveTeacherCallback: saveTeacherCallBack,
        user: user,
        registerAttendanceCallBack: registerAttendanceCallBack,
      );
    });

typedef TeacherCallback = Future<Teacher> Function({required String id});
typedef SummitTeacherCallback = Future<void> Function(Teacher teacher);
typedef RegisterAttendanceCallBack =
    Future<Teacher> Function({
      required String idAttendance,
      required String idTeacher,
    });

class QrTeacherNotifier extends StateNotifier<QrTeacherState> {
  bool isLoading = false;
  TeacherCallback teacherCallback;
  SummitTeacherCallback saveTeacherCallback;
  User user;
  RegisterAttendanceCallBack registerAttendanceCallBack;

  QrTeacherNotifier({
    required this.teacherCallback,
    required this.saveTeacherCallback,
    required this.user,
    required this.registerAttendanceCallBack,
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
    final newTeacher = getTeacher.copyWith(
      idAttendance: idAttendance,
      attendanceRegister: DateTime.now(),
    );

    state = state.copyWith(isLoading: false, teacher: newTeacher);
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
    await saveTeacherCallback(state.teacher!);

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
