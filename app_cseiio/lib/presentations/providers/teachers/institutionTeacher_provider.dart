import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_cseiio/domain/entities/institution.dart';
import 'package:app_cseiio/presentations/providers/teachers/teachers_repository_provider.dart';

final getinstitutionTeacherProvider_sinfuncionamiento = StateNotifierProvider<
  InstitutionTeacherMapNotifier,
  Map<String, Institution>
>((ref) {
  final getInstitutoionTeacher =
      ref.watch(teacherRepositoryProvider).getInstitutionTeacher;

  return InstitutionTeacherMapNotifier(
    getInstitutoionTeacher: getInstitutoionTeacher,
  );
});

typedef GetInstitutoionTeacherCallback =
    Future<Institution> Function({String id});

class InstitutionTeacherMapNotifier
    extends StateNotifier<Map<String, Institution>> {
  final GetInstitutoionTeacherCallback getInstitutoionTeacher;

  bool isLoading = false;

  InstitutionTeacherMapNotifier({required this.getInstitutoionTeacher})
    : super({});

  Future<void> loadInstitution(String teacherId) async {
    if (isLoading) return;
    if (state[teacherId] != null) return;

    isLoading = true;
    print('peticion institutos');
    final institution = await getInstitutoionTeacher(id: teacherId);

    isLoading = false;
    state = {...state, teacherId: institution};
  }
}
