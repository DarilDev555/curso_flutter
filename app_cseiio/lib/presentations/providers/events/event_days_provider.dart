import '../../../domain/entities/event_day.dart';
import 'event_days_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getEventDaysProvider =
    StateNotifierProvider<EventDaysNotifier, Map<String, List<EventDay>>>((
      ref,
    ) {
      final fetchgetEventDays =
          ref.watch(eventDaysRepositoryProvider).getEventDaysToEvent;
      return EventDaysNotifier(fetchGetEventDays: fetchgetEventDays);
    });

typedef EventDaysCallback = Future<List<EventDay>> Function(String idEvent);

class EventDaysNotifier extends StateNotifier<Map<String, List<EventDay>>> {
  bool isLoanding = false;
  EventDaysCallback fetchGetEventDays;

  EventDaysNotifier({required this.fetchGetEventDays}) : super({});

  Future<void> loadEventDays({required String idEvent}) async {
    if (isLoanding) return;

    isLoanding = true;

    if (state.containsKey(idEvent)) {
      isLoanding = false;
      return;
    }

    final List<EventDay> eventDays = await fetchGetEventDays(idEvent);

    if (eventDays.isEmpty) {
      isLoanding = false;
      return;
    }

    state = {...state, idEvent: eventDays};
    isLoanding = false;
    return;
  }
}
