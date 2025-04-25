import 'teachers_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/event.dart';

final teacherDetailsProvider =
    StateNotifierProvider<TeacherDetailsNotifier, Map<String, dynamic>>((ref) {
      final fetchgetTeacherDetails =
          ref.watch(teacherRepositoryProvider).getTeacherDetails;

      return TeacherDetailsNotifier(
        fetchgetTeacherDetails: fetchgetTeacherDetails,
      );
    });

typedef TeacherDetailsCallback =
    Future<Map<String, dynamic>> Function({required String id, int page});

class TeacherDetailsNotifier extends StateNotifier<Map<String, dynamic>> {
  Map<String, int> currentPage = {};
  bool isLoading = false;
  int ultimaPeticon = 10;
  TeacherDetailsCallback fetchgetTeacherDetails;

  TeacherDetailsNotifier({required this.fetchgetTeacherDetails}) : super({});

  Future<void> loadEvents(String id) async {
    if (isLoading) return;

    isLoading = true;

    currentPage[id] = currentPage[id] ?? 0;

    final Map<String, dynamic> teacherDetails = await fetchgetTeacherDetails(
      id: id,
      page: currentPage[id]!,
    );

    if (teacherDetails.isEmpty) {
      isLoading = false;
      return;
    }

    final List<Event> newEvents = teacherDetails['events'] as List<Event>;

    final Map<String, dynamic> newState = Map<String, dynamic>.from(state);

    final oldEvents = List<Event>.from(newState[id]?['events'] ?? []);

    /// IF 1: Exactamente 10 eventos y fue la primera vez también con 10
    if (newEvents.length == 10 && ultimaPeticon == 10) {
      currentPage[id] = currentPage[id]! + 1;
      ultimaPeticon = newEvents.length;

      newState[id] = {
        'institution':
            newState[id]?['institution'] ?? teacherDetails['institution'],
        'events': [...oldEvents, ...teacherDetails['events']],
      };
      state = newState;

      isLoading = false;
      return;
    }

    /// IF 2: Recibimos más eventos que la última vez
    if (newEvents.length > ultimaPeticon) {
      newState[id] = {
        'institution':
            newState[id]?['institution'] ?? teacherDetails['institution'],

        'events': [...oldEvents, ...teacherDetails['events']],
      };
      state = newState;

      ultimaPeticon = newEvents.length;
      if (newEvents.length == 10) {
        currentPage[id] = currentPage[id]! + 1;
      }

      isLoading = false;
      return;
    }

    /// IF 3: Última petición fue de 10, pero esta ya no
    if (ultimaPeticon == 10) {
      newState[id] = {
        'institution':
            newState[id]?['institution'] ?? teacherDetails['institution'],
        'events': [...oldEvents, ...teacherDetails['events']],
      };
      state = newState;

      ultimaPeticon = newEvents.length;
      isLoading = false;
      return;
    }

    isLoading = false;
  }
}
