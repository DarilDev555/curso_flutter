import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/teacher.dart';
import '../../errors/auth_errors.dart';
import '../../errors/teacher_summit_error.dart';
import '../auth/auth_provider.dart';
import '../storage/local_teachers_provider.dart';
import 'teachers_repository_provider.dart';

final teachersToAttendanceProvider = StateNotifierProvider<
  TeachersToAttendanceNotifier,
  Map<String, List<Teacher>>
>((ref) {
  final loadTEachers =
      ref.watch(teacherRepositoryProvider).getTeachersToattendance;

  final summitTeacher =
      ref.watch(teacherRepositoryProvider).summitTeacherToAttendance;

  final removeTeacher = ref.watch(localTeachersProvider.notifier).removeTeacher;

  final logout = ref.read(authProvider.notifier).logout;

  return TeachersToAttendanceNotifier(
    teachersToAttendanceCallBack: loadTEachers,
    teacherSummitToAttendanceCallBack: summitTeacher,
    removeTeacherToLocalStorageCallBack: removeTeacher,
    logoutCallBack: logout,
  );
});

typedef TeachersToAttendanceCallBack =
    Future<List<Teacher>> Function({required String idAttendance, int page});

typedef TeacherSummitToAttendance =
    Future<Teacher> Function(String idAttendance, String idTeacher);

typedef RemoveTeacherToLocalStorage = Future<void> Function(Teacher teacher);

typedef LogoutCallBack = Future<void> Function([String? errorMessage]);

class TeachersToAttendanceNotifier
    extends StateNotifier<Map<String, List<Teacher>>> {
  bool isLoading = false;
  Map<String, int> currentPage = {};
  Map<String, int> ultimaPeticon = {};
  final TeachersToAttendanceCallBack teachersToAttendanceCallBack;
  final TeacherSummitToAttendance teacherSummitToAttendanceCallBack;
  final RemoveTeacherToLocalStorage removeTeacherToLocalStorageCallBack;
  final LogoutCallBack logoutCallBack;

  TeachersToAttendanceNotifier({
    required this.teachersToAttendanceCallBack,
    required this.teacherSummitToAttendanceCallBack,
    required this.removeTeacherToLocalStorageCallBack,
    required this.logoutCallBack,
  }) : super({});

  Future<void> reloadTeachersToApi({required String idAttendance}) async {
    if (isLoading) return;
    final oldState = state;
    isLoading = true;
    currentPage[idAttendance] = 0;
    state = {};

    try {
      final List<Teacher> teachers = await teachersToAttendanceCallBack(
        idAttendance: idAttendance,
        page: currentPage[idAttendance]!,
      );
      if (teachers.isEmpty) {
        isLoading = false;
        return;
      }

      currentPage[idAttendance] = currentPage[idAttendance]! + 1;
      ultimaPeticon[idAttendance] = teachers.length;

      final newState = Map<String, List<Teacher>>.from(state);
      newState[idAttendance] = teachers;
      state = newState;

      isLoading = false;
      return;
    } catch (e) {
      state = oldState;
      isLoading = false;
      throw Exception();
    }
  }

  Future<void> loadTeachers({required String idAttendance}) async {
    if (isLoading) return;
    isLoading = true;
    currentPage[idAttendance] =
        currentPage[idAttendance] == null
            ? currentPage[idAttendance] = 0
            : currentPage[idAttendance]!;

    try {
      final List<Teacher> teachers = await teachersToAttendanceCallBack(
        idAttendance: idAttendance,
        page: currentPage[idAttendance]!,
      );
      if (teachers.isEmpty) {
        isLoading = false;
        return;
      }

      final newState = Map<String, List<Teacher>>.from(state);

      if (teachers.length == 10 &&
          (ultimaPeticon[idAttendance] == null ||
              ultimaPeticon[idAttendance] == 10)) {
        currentPage[idAttendance] = currentPage[idAttendance]! + 1;
        ultimaPeticon[idAttendance] = teachers.length;

        newState[idAttendance] = [...?newState[idAttendance], ...teachers];
        state = newState;

        isLoading = false;
        return;
      }
      if (teachers.length > ultimaPeticon[idAttendance]!) {
        List<Teacher> teachersAux = [];

        for (var i = ultimaPeticon[idAttendance]!; i < teachers.length; i++) {
          teachersAux = [...teachersAux, teachers[i]];
        }

        newState[idAttendance] = [...?newState[idAttendance], ...teachersAux];
        state = newState;

        ultimaPeticon[idAttendance] = teachers.length;
        isLoading = false;
        teachers.length == 10
            ? currentPage[idAttendance] = currentPage[idAttendance]! + 1
            : 0;
        return;
      }
      // ultima ueron 10 pero la entrega son menores
      if (ultimaPeticon[idAttendance] == 10) {
        newState[idAttendance] = [...?newState[idAttendance], ...teachers];
        state = newState;

        ultimaPeticon[idAttendance] = teachers.length;
        isLoading = false;
        return;
      }
      isLoading = false;
    } catch (e) {
      isLoading = false;
      throw Exception();
    }
  }

  Future<void> summitTeahcers(
    List<Teacher> teachersToSummit,
    String idAttendance,
  ) async {
    if (isLoading) return;
    isLoading = true;
    if (teachersToSummit.isEmpty) {
      isLoading = false;
      return;
    }

    final teacher = teachersToSummit.first;
    //Recorremos todos los teahcers que se van a subir
    //tenemos que cachar si alguno da error por si no se pudo quitar de local o no se pudo sibur a la api
    try {
      //intentamos quitar al teacher de ISAR
      await removeTeacherToLocalStorageCallBack(teacher);
    } on Exception catch (_) {
      //Si no se puedo tenemos que mostrar un Mensaje
      isLoading = false;
      return;
    }
    try {
      //intentamos Subir el teacher
      final teacherSummit = await teacherSummitToAttendanceCallBack(
        idAttendance,
        teacher.id.toString(),
      );

      summitOneTeacher(teacherSummit, idAttendance);
      summitTeahcers(teachersToSummit, idAttendance);

      // state = {...state, idAttendance: state}
    } on TeacherSummitError catch (e) {
      summitOneTeacher(e.teahcer, idAttendance);
      summitTeahcers(teachersToSummit, idAttendance);
    } on CustomError catch (e) {
      logoutCallBack(e.message);
    } on Exception catch (_) {
      logoutCallBack('Error no controlado');
    }

    return;
  }

  void summitOneTeacher(Teacher teacherToSummit, String idAttendance) {
    if (state[idAttendance] != null) {
      final teacherOnState = state[idAttendance]!.any(
        (element) => element.id == teacherToSummit.id,
      );
      if (teacherOnState) {
        final indexTeacherOld = state[idAttendance]!.indexWhere(
          (element) => element.id == teacherToSummit.id,
        );
        final newState = state[idAttendance]!;

        if (indexTeacherOld != newState.length) {
          newState.replaceRange(indexTeacherOld, indexTeacherOld + 1, [
            teacherToSummit,
          ]);

          state = {...state, idAttendance: newState};
          isLoading = false;
          return;
        }
        newState.replaceRange(indexTeacherOld - 1, indexTeacherOld, [
          teacherToSummit,
        ]);

        state = {...state, idAttendance: newState};
        isLoading = false;
        return;
      }
      state = {
        ...state,
        idAttendance: [teacherToSummit, ...state[idAttendance]!],
      };
      isLoading = false;
      return;
    }
    state = {
      ...state,
      idAttendance: [teacherToSummit],
    };
    isLoading = false;
    return;
  }
}
