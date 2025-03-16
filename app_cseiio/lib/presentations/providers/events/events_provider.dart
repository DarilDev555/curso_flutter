import 'package:app_cseiio/domain/entities/event.dart';
import 'package:app_cseiio/presentations/providers/events/events_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getEventsProvider =
    StateNotifierProvider<EventsNotifier, Map<String, List<Event>>>((ref) {
      final fetchGetEvents = ref.watch(eventsRepositoryProvider).getEvents;

      return EventsNotifier(fetchGetEvents: fetchGetEvents);
    });

typedef EventCallback =
    Future<List<Event>> Function({required String month, required String year});

class EventsNotifier extends StateNotifier<Map<String, List<Event>>> {
  bool isLoading = false;

  EventCallback fetchGetEvents;

  EventsNotifier({required this.fetchGetEvents}) : super({});

  Future<void> loadEvents({required String month, required String year}) async {
    if (isLoading) return;

    isLoading = true;
    final List<Event> events = await fetchGetEvents(month: month, year: year);

    if (events.isEmpty) {
      isLoading = false;
      return;
    }

    state = {'$month-$year': events};
    isLoading = false;
    return;
  }
}
