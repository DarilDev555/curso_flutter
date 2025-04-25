import '../../../domain/entities/event.dart';
import 'events_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getEventsProvider = StateNotifierProvider<EventsNotifier, List<Event>>((
  ref,
) {
  final fetchGetEvents = ref.watch(eventsRepositoryProvider).getEvents;
  final fetchGetEventById = ref.watch(eventsRepositoryProvider).getEventById;

  return EventsNotifier(
    fetchGetEvents: fetchGetEvents,
    fetchGetEventById: fetchGetEventById,
  );
});

typedef EventCallback =
    Future<List<Event>> Function({required String month, required String year});

typedef EventByIdCallback = Future<Event> Function(String idEvent);

class EventsNotifier extends StateNotifier<List<Event>> {
  bool isLoading = false;
  List<String> months = [];

  EventCallback fetchGetEvents;
  EventByIdCallback fetchGetEventById;

  EventsNotifier({
    required this.fetchGetEvents,
    required this.fetchGetEventById,
  }) : super([]);

  Future<void> loadEvents({required String month, required String year}) async {
    if (isLoading) return;

    isLoading = true;

    if (months.contains('$month-$year')) {
      isLoading = false;
      return;
    }

    final List<Event> events = await fetchGetEvents(month: month, year: year);

    if (events.isEmpty) {
      isLoading = false;
      return;
    }

    state = [...state, ...events];
    months.add('$month-$year');
    isLoading = false;
    return;
  }

  // Future<void> loadEventById({required String idEvent}) async {
  //   if (isLoading) return;
  //   isLoading = false;

  //   if (state.any((event) => event.id == idEvent)) {
  //     isLoading = false;
  //     return;
  //   }

  //   final Event? event = await fetchGetEventById(idEvent);

  //   if (event == null) {
  //     isLoading = false;
  //     return;
  //   }

  //   state = [...state, event];
  //   isLoading = false;
  //   return;
  // }
}
