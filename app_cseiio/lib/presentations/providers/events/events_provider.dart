import '../../../domain/entities/event.dart';
import '../../errors/auth_errors.dart';
import '../auth/auth_provider.dart';
import 'event_days_provider.dart';
import 'events_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventsProvider = StateNotifierProvider<EventsNotifier, EventsState>((
  ref,
) {
  final fetchGetEvents = ref.watch(eventsRepositoryProvider).getEvents;
  final fetchGetEventById = ref.watch(eventsRepositoryProvider).getEventById;
  final logout = ref.watch(authProvider.notifier).logout;
  final fetchCreateEvent = ref.watch(eventsRepositoryProvider).createEvent;
  final resetEventToProvider =
      ref.watch(getEventDaysProvider.notifier).deleteEventToProvider;

  return EventsNotifier(
    fetchGetEvents: fetchGetEvents,
    fetchGetEventById: fetchGetEventById,
    logout: logout,
    createEventCallback: fetchCreateEvent,
    resetEventToProvider: resetEventToProvider,
  );
});

typedef EventCallback =
    Future<List<Event>> Function({required String month, required String year});

typedef EventByIdCallback = Future<Event> Function(String idEvent);
typedef ResetEventToProvider = Future<void> Function({required String idEvent});

typedef Logout = Future<void> Function([String? errorMessage]);

typedef CreateEvent =
    Future<Event> Function({
      String? idEvent,
      required String name,
      required String description,
      required DateTime inicialDate,
      required DateTime endDate,
      required List<DateTime> dates,
    });

class EventsNotifier extends StateNotifier<EventsState> {
  bool isLoading = false;

  final EventCallback fetchGetEvents;
  final EventByIdCallback fetchGetEventById;
  final Logout logout;
  final CreateEvent createEventCallback;
  final ResetEventToProvider resetEventToProvider;

  EventsNotifier({
    required this.fetchGetEvents,
    required this.fetchGetEventById,
    required this.logout,
    required this.createEventCallback,
    required this.resetEventToProvider,
  }) : super(EventsState(months: []));

  Future<void> loadEvents({required String month, required String year}) async {
    if (isLoading) return;
    isLoading = true;

    if (state.months.contains('$month-$year')) {
      isLoading = false;
      return;
    }

    state = state.copyWith(isLoading: true);
    final List<Event> events = await fetchGetEvents(month: month, year: year);
    if (events.isEmpty) {
      state = state.copyWith(isLoading: false);
      isLoading = false;
      return;
    }
    List<String> newMonths = state.months;
    newMonths.add('$month-$year');

    state = state.copyWith(
      events: [...state.events, ...events],
      months: newMonths,
      isLoading: false,
    );
    isLoading = false;
    return;
  }

  Future<void> addNewEvent(Event event, {bool isEditEvent = false}) async {
    if (isLoading) return;
    isLoading = true;
    if (isEditEvent) {
      state = state.copyWith(
        events: state.events.map((e) => e.id == event.id ? event : e).toList(),
      );
      await resetEventToProvider(idEvent: event.id);
      isLoading = false;
      return;
    }
    final eventDate = '${event.startDate.month}-${event.startDate.year}';
    if (state.months.contains(eventDate)) {
      state = state.copyWith(
        events: [...state.events, event],
        lastEventCreate: event.startDate,
      );
      isLoading = false;
      return;
    }
    state = state.copyWith(lastEventCreate: event.startDate);
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
    List<String> newMonths = state.months;
    newMonths.add('$month-$year');

    state = state.copyWith(
      events: [...state.events, ...events],
      months: newMonths,
      isLoading: false,
    );
    isLoading = false;
    return;
  }

  Future<Map<String, dynamic>?> createEvent({
    String? idEvent,
    required String name,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required List<DateTime> dates,
  }) async {
    try {
      final event = await createEventCallback(
        idEvent: idEvent,
        name: name,
        description: description,
        inicialDate: startDate,
        endDate: endDate,
        dates: dates,
      );
      state.copyWith(lastEventCreate: event.startDate);
      return {"event": event};
    } on FormErrorsStrings catch (e) {
      return e.errors;
    } on CustomError catch (e) {
      return {"eunexpectedError": e.message};
    } on Exception catch (e) {
      logout('Error no controlado');
      //poner el logout
    }
    return null;
  }
}

class EventsState {
  final List<Event> events;
  final List<String> months;
  final bool isLoading;
  final DateTime? lastEventCreate;

  EventsState({
    List<Event>? events,
    required this.months,
    this.isLoading = true,
    this.lastEventCreate,
  }) : events = events ?? const [];

  EventsState copyWith({
    List<Event>? events,
    List<String>? months,
    bool? isLoading,
    DateTime? lastEventCreate,
  }) {
    return EventsState(
      events: events ?? this.events,
      months: months ?? this.months,
      isLoading: isLoading ?? this.isLoading,
      lastEventCreate: lastEventCreate ?? this.lastEventCreate,
    );
  }
}
