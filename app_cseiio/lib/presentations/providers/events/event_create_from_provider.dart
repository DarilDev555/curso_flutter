// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import '../../../domain/entities/entities.dart';
import '../../inputs/days_event.dart';
import '../../inputs/inputs.dart';
import 'events_provider.dart';

final eventCreateFromProvider = StateNotifierProvider.autoDispose<
  EventCreateFromNotifier,
  EventCreateFromState
>((ref) {
  final fetchCreateEvent = ref.watch(eventsProvider.notifier).createEvent;
  return EventCreateFromNotifier(createEventCallback: fetchCreateEvent);
});

typedef CreateEvent =
    Future<Map<String, dynamic>?> Function({
      String? idEvent,
      required String name,
      required String description,
      required DateTime startDate,
      required DateTime endDate,
      required List<DateTime> dates,
    });

class EventCreateFromNotifier extends StateNotifier<EventCreateFromState> {
  final CreateEvent createEventCallback;

  EventCreateFromNotifier({required this.createEventCallback})
    : super(EventCreateFromState());

  void inicialStateWithEvent(Event event) {
    state = state.copyWith(
      name: Name.pure(event.name),
      description: Description.pure(event.description),
      daysEvent: DaysEvent.pure(
        event.eventdays?.map((e) => e.dateDayEvent).toList(),
      ),
    );
  }

  void onNameChange(String value) {
    final newName = Name.dirty(value);
    state = state.copyWith(
      name: newName,
      isValid: Formz.validate([newName, state.description, state.daysEvent]),
    );
  }

  void onDescriptionChange(String value) {
    final newDescription = Description.dirty(value);
    state = state.copyWith(
      description: newDescription,
      isValid: Formz.validate([state.name, newDescription, state.daysEvent]),
    );
  }

  void onDaysEventChange(List<DateTime> value) {
    final newDaysEvent = DaysEvent.dirty(value);
    state = state.copyWith(
      daysEvent: newDaysEvent,
      isValid: Formz.validate([newDaysEvent, state.name, state.description]),
    );
  }

  _touchEveryField() {
    final name = Name.dirty(state.name.value);
    final description = Description.dirty(state.description.value);
    final daysEvent = DaysEvent.dirty(state.daysEvent.value);

    state = state.copyWith(
      isFormPosted: true,
      name: name,
      description: description,
      daysEvent: daysEvent,
      isValid: Formz.validate([name, description, daysEvent]),
    );
  }

  void onFormSumit() async {
    _touchEveryField();

    if (!state.isValid && !(state.isSumit)) return;

    state = state.copyWith(isSumit: true);

    final errors = await createEventCallback(
      idEvent: state.idEvent,
      name: state.name.value,
      description: state.description.value,
      startDate: state.daysEvent.value.first,
      endDate: state.daysEvent.value.last,
      dates: state.daysEvent.value,
    );

    if (errors != null && !errors.containsKey('event')) {
      state = state.copyWith(
        errors: errors as Map<String, String>?,
        isSumit: false,
      );
      return;
    }

    final newEvent = errors?['event'] as Event?;

    if (state.idEvent == newEvent?.id) {
      final eventCombinated = combineEvents(state.event!, newEvent!);
      final eventOrdered = eventCombinated.copyWith(
        eventdays:
            eventCombinated.eventdays
              ?..sort((a, b) => a.dateDayEvent.compareTo(b.dateDayEvent)),
      );
      state = state.copyWith(
        errors: {},
        isValidEvent: true,
        isCheckingEvent: false,
        isSumit: false,
        event: eventOrdered,
        idEvent: null,
      );
      return;
    }

    final eventOrdered = newEvent?.copyWith(
      eventdays:
          newEvent.eventdays
            ?..sort((a, b) => a.dateDayEvent.compareTo(b.dateDayEvent)),
    );
    state = state.copyWith(
      errors: {},
      isValidEvent: true,
      isCheckingEvent: false,
      isSumit: false,
      event: eventOrdered,
    );
  }

  void continueCreateEvent(Event event) {
    state = state.copyWith(
      errors: {},
      isValidEvent: true,
      isCheckingEvent: false,
      isSumit: false,
      event: event,
    );
  }

  void returnToScreen() {
    state = state.copyWith(isSumit: false, isValid: false, isValidEvent: false);
  }

  void editEvent(Event event, {bool isEditEventCreatedWithAttendance = false}) {
    state = state.copyWith(
      idEvent: event.id,
      name: Name.pure(event.name),
      description: Description.pure(event.description),
      daysEvent: DaysEvent.pure(
        event.eventdays!.map((e) => e.dateDayEvent).toList(),
      ),
      event: event,
      isSumit: false,
      isValid: false,
      isValidEvent: false,
      isEditEventCreatedWithAttendance: isEditEventCreatedWithAttendance,
    );
  }

  Event combineEvents(Event oldEvent, Event newEvent) {
    List<EventDay> newEventDays = [];

    Map<DateTime, EventDay> mapOld = {};

    for (var eventDayOld in oldEvent.eventdays!) {
      DateTime justDateOld = DateTime(
        eventDayOld.dateDayEvent.year,
        eventDayOld.dateDayEvent.month,
        eventDayOld.dateDayEvent.day,
      );
      mapOld[justDateOld] = eventDayOld;
    }

    int indexNumDay = 1;
    for (var eventDayNew in newEvent.eventdays!) {
      DateTime justDateNew = DateTime(
        eventDayNew.dateDayEvent.year,
        eventDayNew.dateDayEvent.month,
        eventDayNew.dateDayEvent.day,
      );

      if (mapOld.containsKey(justDateNew)) {
        newEventDays.add(mapOld[justDateNew]!.copyWith(numDay: indexNumDay));
        indexNumDay++;
      } else {
        newEventDays.add(eventDayNew.copyWith(numDay: indexNumDay));
        indexNumDay++;
      }
    }

    return newEvent.copyWith(eventdays: newEventDays);
  }
}

class EventCreateFromState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final bool isValidEvent;
  final bool isCheckingEvent;
  final bool isSumit;
  final bool isEditEvent;
  final bool isEditEventCreatedWithAttendance;
  final String? idEvent;
  final Name name;
  final Description description;
  final DaysEvent daysEvent;
  final Map<String, String>? errors;
  final Event? event; // AGREGAR EL EVENTO CON ISCOMPLETE

  EventCreateFromState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.isValidEvent = false,
    this.isCheckingEvent = false,
    this.isSumit = false,
    this.isEditEvent = false,
    this.isEditEventCreatedWithAttendance = false,
    this.idEvent,
    this.name = const Name.pure(),
    this.description = const Description.pure(),
    this.daysEvent = const DaysEvent.pure(),
    this.errors,
    this.event,
  });

  EventCreateFromState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    bool? isValidEvent,
    bool? isCheckingEvent,
    bool? isSumit,
    bool? isEditEvent,
    bool? isEditEventCreatedWithAttendance,
    String? idEvent,
    Name? name,
    Description? description,
    DaysEvent? daysEvent,
    Map<String, String>? errors,
    Event? event,
  }) {
    return EventCreateFromState(
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
      isValidEvent: isValidEvent ?? this.isValidEvent,
      isCheckingEvent: isCheckingEvent ?? this.isCheckingEvent,
      isSumit: isSumit ?? this.isSumit,
      isEditEvent: isEditEvent ?? this.isEditEvent,
      idEvent: idEvent ?? this.idEvent,
      isEditEventCreatedWithAttendance:
          isEditEventCreatedWithAttendance ??
          this.isEditEventCreatedWithAttendance,
      name: name ?? this.name,
      description: description ?? this.description,
      daysEvent: daysEvent ?? this.daysEvent,
      errors: errors ?? this.errors,
      event: event ?? this.event,
    );
  }

  @override
  String toString() {
    return '''
    isPosting: $isPosting,
    isFormPosted: $isFormPosted,
    isValid: $isValid,
    isValidEvent: $isValidEvent,
    isCheckingEvent: $isCheckingEvent,
    isSumit: $isSumit,
    idEvent: $idEvent,
    isEditEventCreatedWithAttendance: $isEditEventCreatedWithAttendance,
    name: $name, 
    description: $description, 
    daysEvent: $daysEvent    
    errors: $errors
    event: $event
    ''';
  }
}
