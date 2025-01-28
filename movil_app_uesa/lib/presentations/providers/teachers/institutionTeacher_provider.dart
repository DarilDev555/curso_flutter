import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movil_app_uesa/domain/entities/institution.dart';
import 'package:movil_app_uesa/presentations/providers/teachers/teachers_repository_provider.dart';

final getinstitutionTeacherProvider = StateNotifierProvider<
    InstitutionTeacherMapNotifier, Map<String, Institution>>(
  (ref) {
    final getInstitutoionTeacher =
        ref.watch(teacherRepositoryProvider).getInstitutionTeacher;

    return InstitutionTeacherMapNotifier(
        getInstitutoionTeacher: getInstitutoionTeacher);
  },
);

typedef GetInstitutoionTeacherCallback = Future<Institution> Function(
    {String id});

class InstitutionTeacherMapNotifier
    extends StateNotifier<Map<String, Institution>> {
  final GetInstitutoionTeacherCallback getInstitutoionTeacher;

  InstitutionTeacherMapNotifier({
    required this.getInstitutoionTeacher,
  }) : super({});

  Future<void> loadInstitution(String teacherId) async {
    if (state[teacherId] != null) return;

    print('peticion institutos');
    final institution = await getInstitutoionTeacher(id: teacherId);

    state = {...state, teacherId: institution};
  }
}
