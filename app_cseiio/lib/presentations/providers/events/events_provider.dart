import '../../../domain/entities/event.dart';
import 'events_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getEventsProvider = StateNotifierProvider<EventsNotifier, EventsState>((
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

class EventsNotifier extends StateNotifier<EventsState> {
  bool isLoading = false;
  List<String> months = [];

  EventCallback fetchGetEvents;
  EventByIdCallback fetchGetEventById;

  EventsNotifier({
    required this.fetchGetEvents,
    required this.fetchGetEventById,
  }) : super(EventsState());

  Future<void> loadEvents({required String month, required String year}) async {
    if (isLoading) return;
    isLoading = true;

    if (months.contains('$month-$year')) {
      isLoading = false;
      return;
    }

    state = state.copyWith(isLoading: true);
    final List<Event> events = await fetchGetEvents(month: month, year: year);
    for (var event in events) {
      print(event.name);
    }
    if (events.isEmpty) {
      state = state.copyWith(isLoading: false);
      isLoading = false;
      return;
    }

    months.add('$month-$year');
    state = state.copyWith(
      events: [...state.events, ...events],
      isLoading: false,
    );
    isLoading = false;
    return;
  }

  Future<void> loadFirstEvents({
    required String month,
    required String year,
  }) async {
    if (isLoading || state.events.isNotEmpty) {
      return;
    }
    isLoading = true;
    final List<Event> events = await fetchGetEvents(month: month, year: year);

    if (events.isEmpty) {
      isLoading = false;
      state = state.copyWith(isLoading: false);
      return;
    }

    months.add('$month-$year');
    state = state.copyWith(
      events: [...state.events, ...events],
      isLoading: false,
    );
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

class EventsState {
  final List<Event> events;
  final bool isLoading;

  EventsState({List<Event>? events, this.isLoading = true})
    : events = events ?? const [];

  EventsState copyWith({List<Event>? events, bool? isLoading}) {
    return EventsState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
