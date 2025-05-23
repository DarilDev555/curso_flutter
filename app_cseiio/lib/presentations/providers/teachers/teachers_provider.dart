import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/teacher.dart';
import '../../errors/auth_errors.dart';
import '../auth/auth_provider.dart';
import 'teachers_repository_provider.dart';

//Provider
final getTeachersProvider =
    StateNotifierProvider<TeachersNotifier, List<Teacher>>((ref) {
      final fetchgetTeachers2 =
          ref.watch(teacherRepositoryProvider).getTeachers;

      final getTeacherByIdCallback =
          ref.read(teacherRepositoryProvider).getTeacherById;

      final logout = ref.read(authProvider.notifier).logout;

      return TeachersNotifier(
        fetchgetTeachers: fetchgetTeachers2,
        getTeacherByIdCallback: getTeacherByIdCallback,
        logoutCallBack: logout,
      );
    });

typedef TeachersCallback = Future<List<Teacher>> Function({int page});
typedef GetTeacherByIdCallback = Future<Teacher> Function({required String id});
typedef LogoutCallBack = Future<void> Function([String? errorMessage]);

//Notifier
class TeachersNotifier extends StateNotifier<List<Teacher>> {
  int currentPage = 0;
  bool isLoading = false;
  int ultimaPeticon = 10;
  TeachersCallback fetchgetTeachers;
  GetTeacherByIdCallback getTeacherByIdCallback;
  LogoutCallBack logoutCallBack;

  TeachersNotifier({
    required this.fetchgetTeachers,
    required this.getTeacherByIdCallback,
    required this.logoutCallBack,
  }) : super([]);

  Future<void> loadTeachers() async {
    if (isLoading) return;

    isLoading = true;

    try {
      final List<Teacher> teachers = await fetchgetTeachers(page: currentPage);

      if (teachers.isEmpty) {
        isLoading = false;
        return;
      }

      if (teachers.length == 10 && ultimaPeticon == 10) {
        currentPage++;
        ultimaPeticon = teachers.length;
        state = [...state, ...teachers];
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
        state = [...state, ...teachers];

        ultimaPeticon = teachers.length;
        isLoading = false;
        return;
      }
      isLoading = false;
    } on CustomError catch (e) {
      logoutCallBack(e.message);
    } on Exception catch (_) {
      logoutCallBack('Error no controlado');
    }
  }

  Future<Teacher> getTeacher({required String id}) async {
    return getTeacherByIdCallback(id: id);
  }
}
