import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/attendance.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/entities/event_day.dart';
import '../../errors/auth_errors.dart';
import 'event_create_from_provider.dart';

import 'events_provider.dart';
import 'events_repository_provider.dart';

final eventDaysFrom = StateNotifierProvider.autoDispose<
  EventDaysCreateFromNotifier,
  EventDaysCreateFromState
>((ref) {
  final completeEvent = ref.watch(eventsRepositoryProvider).completeEvet;
  final updateEventWithEventDaysAndAttendance =
      ref.watch(eventsRepositoryProvider).updateEvent;
  final dates = ref.watch(eventCreateFromProvider).daysEvent.value;
  final event = ref.watch(eventCreateFromProvider).event;
  final isEditEventCreatedWithAttendance =
      ref.watch(eventCreateFromProvider).isEditEventCreatedWithAttendance;

  final addNewEvent = ref.watch(eventsProvider.notifier).addNewEvent;

  return EventDaysCreateFromNotifier(
    completeEvent: completeEvent,
    updateEvent: updateEventWithEventDaysAndAttendance,
    dates: dates,
    event: event,
    addNewEventToProvider: addNewEvent,
    isEditEventCreatedWithAttendance: isEditEventCreatedWithAttendance,
  );
});

typedef CompleteEvent = Future<Event> Function({required Event event});
typedef UpdateEvent = Future<Event> Function({required Event event});
typedef AddNewEventToProvider =
    Future<void> Function(Event event, {bool isEditEvent});

class EventDaysCreateFromNotifier
    extends StateNotifier<EventDaysCreateFromState> {
  final CompleteEvent completeEvent;
  final UpdateEvent updateEvent;
  final List<DateTime> dates;
  final Event? event;
  final bool isEditEventCreatedWithAttendance;
  final AddNewEventToProvider addNewEventToProvider;

  EventDaysCreateFromNotifier({
    required this.completeEvent,
    required this.updateEvent,
    required this.dates,
    this.event,
    required this.isEditEventCreatedWithAttendance,
    required this.addNewEventToProvider,
  }) : super(
         EventDaysCreateFromState(
           event: event,
           isEditEventCreatedWithAttendance: isEditEventCreatedWithAttendance,
         ),
       );

  void createinicialState() {
    if (state.event == null) {
      return;
    }

    if (state.event!.eventdays == null) {
      return;
    }
    final List<EventDay> eventDays =
        state.event!.eventdays!.asMap().entries.map((entry) {
          final index = entry.key;
          final eventDay = entry.value;
          if (eventDay.attendances != null &&
              eventDay.attendances!.isNotEmpty) {
            return eventDay;
          }
          final newEventDay = eventDay.copyWith(
            attendances: [
              Attendance(
                id: '${event!.id}${index}700',
                name: 'Entrada',
                descripcion: 'Registro de entrada',
                attendanceTime: eventDay.dateDayEvent.copyWith(
                  hour: 7,
                  minute: 0,
                ),
              ),
              Attendance(
                id: '${event!.id}${index}1700',
                name: 'Salida',
                descripcion: 'Registro de salida',
                attendanceTime: eventDay.dateDayEvent.copyWith(
                  hour: 15,
                  minute: 0,
                ),
              ),
            ],
          );
          return newEventDay;
        }).toList();

    final newEvent = state.event!.copyWith(eventdays: eventDays);

    state = state.copyWith(event: newEvent);
    return;
  }

  void addAttendance(Attendance attendance, String idEventDay) {
    final event = state.event!;
    final newEvent = event.copyWith(
      eventdays:
          event.eventdays!.map((eventDay) {
            if (eventDay.id.toString() == idEventDay) {
              final newAttendance = attendance.copyWith(
                id:
                    '${event.id}${attendance.attendanceTime.hour}${attendance.attendanceTime.minute}',
              );
              if (eventDay.attendances == null) {
                return eventDay.copyWith(attendances: [newAttendance]);
              }
              final newAttendances = [...eventDay.attendances!, newAttendance];
              newAttendances.sort(
                (a, b) => a.attendanceTime.compareTo(b.attendanceTime),
              );
              return eventDay.copyWith(attendances: newAttendances);
            }
            return eventDay;
          }).toList(),
    );
    state = state.copyWith(event: newEvent);
    return;
  }

  void updateAttendance(Attendance attendance, String idEventDay) {
    final event = state.event!;
    final newEvent = event.copyWith(
      eventdays:
          event.eventdays!.map((eventDay) {
            if (eventDay.id.toString() != idEventDay) return eventDay;
            return eventDay.copyWith(
              attendances:
                  (eventDay.attendances != null)
                      ? eventDay.attendances!.map((attendanceState) {
                        return (attendanceState.id != attendance.id)
                            ? attendanceState
                            : attendance;
                      }).toList()
                      : [],
            );
          }).toList(),
    );
    state = state.copyWith(event: newEvent);
  }

  void removeAttendance(String attendanceId, String idDayEvent) {
    final event = state.event!;
    final newEvent = event.copyWith(
      eventdays:
          event.eventdays!.map((eventDay) {
            if (eventDay.id.toString() == idDayEvent) {
              if (eventDay.attendances == null ||
                  eventDay.attendances!.isEmpty) {
                return eventDay; // No hay asistencias que eliminar
              }
              final newAttendances =
                  eventDay.attendances!
                      .where((attendance) => attendance.id != attendanceId)
                      .toList();
              return eventDay.copyWith(attendances: newAttendances);
            }
            return eventDay;
          }).toList(),
    );
    state = state.copyWith(event: newEvent);
  }

  Future<void> onFormSumit() async {
    if (state.isSumit) return;
    state = state.copyWith(isSumit: true);
    try {
      final event =
          (state.isEditEventCreatedWithAttendance)
              ? await updateEvent(event: state.event!)
              : await completeEvent(event: state.event!);

      // si el evento ya esta solo remplazarlo
      await addNewEventToProvider(
        event,
        isEditEvent: state.isEditEventCreatedWithAttendance,
      );

      state = state.copyWith(
        error: null,
        isSumit: false,
        event: event,
        eventCreated: true,
      );
    } on CustomError catch (e) {
      state = state.copyWith(error: e.message);
      await Future.delayed(const Duration(milliseconds: 800));
      state = state.copyWith(error: null, isSumit: false);
    }
  }
}

class EventDaysCreateFromState {
  final bool isSumit;
  final Event? event;
  final String? error;
  final bool eventCreated;
  final bool isEditEventCreatedWithAttendance;

  EventDaysCreateFromState({
    this.isSumit = false,
    required this.event,
    this.error,
    this.eventCreated = false,
    this.isEditEventCreatedWithAttendance = false,
  });

  EventDaysCreateFromState copyWith({
    bool? isSumit,
    Event? event,
    String? error,
    String? idAttendanceEditing,
    bool? eventCreated,
    bool? isEditEventCreatedWithAttendance,
  }) {
    return EventDaysCreateFromState(
      isSumit: isSumit ?? this.isSumit,
      event: event ?? this.event,
      error: error ?? this.error,
      eventCreated: eventCreated ?? this.eventCreated,
      isEditEventCreatedWithAttendance:
          isEditEventCreatedWithAttendance ??
          this.isEditEventCreatedWithAttendance,
    );
  }

  @override
  String toString() {
    return '''
    isSumit: $isSumit,
    error: $error.
    ''';
  }
}
