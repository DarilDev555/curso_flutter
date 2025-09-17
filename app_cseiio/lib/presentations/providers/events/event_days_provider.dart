import '../../../domain/entities/entities.dart';
import 'event_days_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getEventDaysProvider =
    StateNotifierProvider<EventDaysNotifier, Map<String, Event>>((ref) {
      final fetchgetEventDays =
          ref.watch(eventDaysRepositoryProvider).getEventDaysToEvent;
      return EventDaysNotifier(fetchGetEventDays: fetchgetEventDays);
    });

typedef EventDaysCallback = Future<Event> Function(String idEvent);

class EventDaysNotifier extends StateNotifier<Map<String, Event>> {
  bool isLoanding = false;
  EventDaysCallback fetchGetEventDays;

  EventDaysNotifier({required this.fetchGetEventDays}) : super({});

  Future<void> loadEventDays({required String idEvent}) async {
    if (isLoanding) return;
    isLoanding = true;

    if (state[idEvent] != null) {
      isLoanding = false;
      return;
    }

    final Event event = await fetchGetEventDays(idEvent);

    if (event.eventdays == null || event.eventdays == []) {
      isLoanding = false;
      return;
    }

    final eventOrdered = event.copyWith(
      eventdays:
          event.eventdays
            ?..sort((a, b) => a.dateDayEvent.compareTo(b.dateDayEvent)),
    );

    state = {...state, idEvent: eventOrdered};
    isLoanding = false;
    return;
  }

  Future<void> deleteEventToProvider({required String idEvent}) async {
    if (isLoanding) return;
    isLoanding = true;
    final newState = state;
    newState.remove(idEvent);
    state = newState;
    isLoanding = false;
    return;
  }
}
