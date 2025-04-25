import '../../../domain/entities/institution.dart';
import 'institutions_respository_proveder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getInstitutionsProvider =
    StateNotifierProvider<InstitutionsNotifier, List<Institution>>((ref) {
      final getInstitutionsCallback =
          ref.watch(institutionsRepositoryProvider).getInstitution;

      return InstitutionsNotifier(
        fetchgetInstitutions: getInstitutionsCallback,
      );
    });

typedef InstitutionCallBack = Future<List<Institution>> Function({int page});

class InstitutionsNotifier extends StateNotifier<List<Institution>> {
  int currentPage = 0;
  bool isLoading = false;
  int ultimaPeticon = 10;
  InstitutionCallBack fetchgetInstitutions;

  InstitutionsNotifier({required this.fetchgetInstitutions}) : super([]);

  Future<void> loadInstitutions() async {
    if (isLoading) return;
    isLoading = true;
    final List<Institution> institutions = await fetchgetInstitutions(
      page: currentPage,
    );

    if (institutions.isEmpty) {
      isLoading = false;
      return;
    }

    if (institutions.length == 10 && ultimaPeticon == 10) {
      currentPage++;
      ultimaPeticon = institutions.length;
      state = [...state, ...institutions];
      isLoading = false;
      return;
    }
    if (institutions.length > ultimaPeticon) {
      for (var i = ultimaPeticon; i < institutions.length; i++) {
        state = [...state, institutions[i]];
      }

      ultimaPeticon = institutions.length;
      isLoading = false;
      institutions.length == 10 ? currentPage++ : 0;
      return;
    }
    // ultima ueron 10 pero la entrega son menores
    if (ultimaPeticon == 10) {
      state = [...state, ...institutions];

      ultimaPeticon = institutions.length;
      isLoading = false;
      return;
    }
    isLoading = false;
  }
}
