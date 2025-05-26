import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/entities.dart';
import 'institutions_respository_proveder.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchInstitutionsProvider =
    StateNotifierProvider<SearchInstitutionsNotifier, List<Institution>>((ref) {
      final institutionRepository = ref.read(institutionsRepositoryProvider);
      return SearchInstitutionsNotifier(
        searchInstitutions: institutionRepository.searchInstitutions,
        ref: ref,
      );
    });

typedef SearchCallback =
    Future<List<Institution>> Function({String? name, String? code});

class SearchInstitutionsNotifier extends StateNotifier<List<Institution>> {
  final SearchCallback searchInstitutions;
  final Ref ref;

  SearchInstitutionsNotifier({
    required this.searchInstitutions,
    required this.ref,
  }) : super([]);

  Future<List<Institution>> searchInstitutionByQuery({
    String? name,
    String? code,
  }) async {
    final List<Institution> institutions = await searchInstitutions(
      name: name,
      code: code,
    );
    ref
        .read(searchQueryProvider.notifier)
        .update((state) => name ?? code ?? '');

    state = institutions;
    return state;
  }
}
