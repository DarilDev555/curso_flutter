import '../../../domain/entities/event.dart';
import '../../providers/auth/auth_provider.dart';
import '../../providers/events/events_incomplete_provider.dart';
import '../../providers/events/events_provider.dart';
import 'event_days_screen.dart';
import '../../widgets/shared/custom_avatar_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../providers/events/event_days_provider.dart';

class EventsScreen extends ConsumerStatefulWidget {
  static const name = 'events-screen';
  const EventsScreen({super.key});

  @override
  EventsScreenState createState() => EventsScreenState();
}

class EventsScreenState extends ConsumerState<EventsScreen> {
  final CalendarController _calendarController = CalendarController();
  bool _isCalendarView = true;

  @override
  void initState() {
    super.initState();
    final DateTime? date = ref.read(eventsProvider).lastEventCreate;
    _calendarController.selectedDate = date ?? DateTime.now();
    _calendarController.displayDate = date ?? DateTime.now();
    ref
        .read(eventsProvider.notifier)
        .loadFirstEvents(
          month: DateTime.now().month.toString(),
          year: DateTime.now().year.toString(),
        );
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _toggleView() {
    setState(() {
      _isCalendarView = !_isCalendarView;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ref.listen(eventsProvider, (previous, next) {
    //   if (previous?.lastEventCreate != next.lastEventCreate) {
    //     _calendarController.selectedDate = next.lastEventCreate;
    //     _calendarController.displayDate = next.lastEventCreate;
    //   }
    // });
    final stateEvents = ref.watch(eventsProvider);
    final events = stateEvents.events;
    final isLoading = stateEvents.isLoading;
    final user = ref.watch(authProvider).user;
    return Scaffold(
      appBar: AppBar(
        leading: const CustomAvatarAppbar(),
        title: const Text('Eventos'),
        actions: [
          (user != null && user.role.name == 'Manager')
              ? IconButton(
                onPressed: () {
                  ref
                      .read(incompleteEventsProvider.notifier)
                      .loadEventsIncomplets();
                  context.push('/events-incomplete-screen');
                },
                icon: Icon(Icons.create_new_folder),
              )
              : const SizedBox.shrink(),
          IconButton(
            icon: Icon(_isCalendarView ? Icons.list : Icons.calendar_month),
            onPressed: _toggleView,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child:
              _isCalendarView
                  ? Stack(
                    children: [
                      if (isLoading)
                        Container(
                          color: Colors.black12,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      SfCalendar(
                        showDatePickerButton: true,
                        showTodayButton: true,
                        headerDateFormat: 'MMMM',
                        controller: _calendarController,
                        onViewChanged: (viewChangedDetails) {
                          Future.microtask(() {
                            ref
                                .read(eventsProvider.notifier)
                                .loadEvents(
                                  month:
                                      _calendarController.displayDate!.month
                                          .toString(),
                                  year:
                                      _calendarController.displayDate!.year
                                          .toString(),
                                );
                          });
                        },
                        view: CalendarView.month,
                        showNavigationArrow: true,
                        onTap: (calendarTapDetails) {
                          if (calendarTapDetails.appointments == null) return;
                          if (calendarTapDetails.appointments!.isEmpty ||
                              calendarTapDetails.targetElement !=
                                  CalendarElement.appointment) {
                            return;
                          }
                          final Event meeting =
                              calendarTapDetails.appointments!.first as Event;
                          ref
                              .read(getEventDaysProvider.notifier)
                              .loadEventDays(idEvent: meeting.id);
                          context.pushNamed(
                            EventDaysScreen.name,
                            queryParameters: {'event': meeting.id},
                          );
                        },
                        dataSource: MeetingDataSource(events),
                        headerStyle: const CalendarHeaderStyle(
                          backgroundColor: Colors.transparent,
                          textStyle: TextStyle(fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                        monthViewSettings: const MonthViewSettings(
                          appointmentDisplayMode:
                              MonthAppointmentDisplayMode.appointment,
                          showAgenda: true,
                          agendaItemHeight: 60,
                          dayFormat: 'EEE  ',
                          agendaStyle: AgendaStyle(
                            appointmentTextStyle: TextStyle(
                              fontSize: 17,
                              overflow: TextOverflow.visible,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(
                            event.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${event.startDate} - ${event.endDate}',
                          ),
                          trailing: Icon(Icons.event, color: event.background),
                          onTap: () {
                            ref
                                .read(getEventDaysProvider.notifier)
                                .loadEventDays(idEvent: event.id);
                            context.push('/event-days-screen/${event.id}');
                          },
                        ),
                      );
                    },
                  ),
        ),
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Event> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].startDate;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].endDate;
  }

  @override
  String getSubject(int index) {
    return appointments![index].name;
  }

  @override
  Color getColor(int index) {
    final color = (appointments![index] as Event).background;
    return color;
  }

  @override
  bool isAllDay(int index) {
    return true;
  }
}
