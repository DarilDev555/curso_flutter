import 'package:app_cseiio/domain/entities/event.dart';
import 'package:app_cseiio/presentations/providers/events/events_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getEventsProvider = StateNotifierProvider<EventsNotifier, List<Event>>((
  ref,
) {
  final fetchGetEvents = ref.watch(eventsRepositoryProvider).getEvents;

  return EventsNotifier(fetchGetEvents: fetchGetEvents);
});

typedef EventCallback =
    Future<List<Event>> Function({required String month, required String year});

class EventsNotifier extends StateNotifier<List<Event>> {
  bool isLoading = false;
  List<String> months = [];

  EventCallback fetchGetEvents;

  EventsNotifier({required this.fetchGetEvents}) : super([]);

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
}
