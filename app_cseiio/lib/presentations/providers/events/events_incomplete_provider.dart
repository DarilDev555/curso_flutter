import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/event.dart';
import 'events_repository_provider.dart';

final incompleteEventsProvider =
    StateNotifierProvider<EventsIncompleteNotifier, List<Event>?>((ref) {
      final fetchEventsIncomplete =
          ref.watch(eventsRepositoryProvider).getEventsIncomplets;

      return EventsIncompleteNotifier(eventCallback: fetchEventsIncomplete);
    });

typedef EventCallback = Future<List<Event>> Function();

class EventsIncompleteNotifier extends StateNotifier<List<Event>?> {
  final EventCallback eventCallback;
  bool isLoading = false;

  EventsIncompleteNotifier({required this.eventCallback}) : super(null);

  Future<void> loadEventsIncomplets() async {
    if (isLoading) return;
    isLoading = true;

    final List<Event> events = await eventCallback();
    if (events.isEmpty) {
      isLoading = false;
      state = [];
      return;
    }

    state = events;
    isLoading = false;
    return;
  }

  //loadEvents
}
