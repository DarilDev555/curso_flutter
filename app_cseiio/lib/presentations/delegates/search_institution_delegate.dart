import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/entities.dart';

typedef SearchCallback =
    Future<List<Institution>> Function({String? name, String? code});

class SearchInstitutionsDelegate extends SearchDelegate<Institution?> {
  final SearchCallback searchCallback;
  List<Institution> inicialInstitutions;

  StreamController<List<Institution>> debounceInstitution =
      StreamController.broadcast();

  StreamController<bool> isLoadingStream = StreamController.broadcast();

  Timer? _debounceTimer;

  SearchInstitutionsDelegate({
    required this.searchCallback,
    required this.inicialInstitutions,
  });

  void _clearStreams() {
    debounceInstitution.close();
    isLoadingStream.close();
  }

  void _onChageQuery(String query) {
    isLoadingStream.add(true);
    if (_debounceTimer?.isActive ?? false) return _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final institutions = await searchCallback(name: query);
      debounceInstitution.add(institutions);
      inicialInstitutions = institutions;
      isLoadingStream.add(false);
    });
  }

  Widget buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: inicialInstitutions,
      stream: debounceInstitution.stream,
      builder: (context, snapshot) {
        final institutions = snapshot.data ?? [];
        if (institutions.isEmpty) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }

        return ListView.builder(
          itemCount: institutions.length,
          itemBuilder: (context, index) {
            final institution = institutions[index];
            return _InstitutionCard(
              institution: institution,
              onInstitutionSelected: (context, movie) {
                _clearStreams();
                close(context, movie);
              },
            );
          },
        );
      },
    );
  }

  @override
  // TODO: implement searchFieldLabel
  String? get searchFieldLabel => 'Buscar institucion';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return const CircularProgressIndicator(strokeAlign: -4);
          }
          return FadeIn(
            animate: query.isNotEmpty,
            child: IconButton(
              onPressed: () => query = '',
              icon: const Icon(Icons.clear),
            ),
          );
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        _clearStreams();
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onChageQuery(query);
    return buildResultsAndSuggestions();
  }
}

class _InstitutionCard extends StatelessWidget {
  final Institution institution;
  final Function onInstitutionSelected;

  const _InstitutionCard({
    required this.institution,
    required this.onInstitutionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(
          Icons.school,
          color: institution.background.withValues(alpha: 0.5),
          size: 40,
        ),
        title: Text(
          institution.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${institution.location.city}, ${institution.location.state}",
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          onInstitutionSelected(context, institution);
        },
      ),
    );
  }
}
