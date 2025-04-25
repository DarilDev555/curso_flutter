import '../../../domain/entities/event.dart';
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
    _calendarController.selectedDate = DateTime.now();
    _calendarController.displayDate = DateTime.now();
    ref
        .read(getEventsProvider.notifier)
        .loadEvents(
          month: DateTime.now().month.toString(),
          year: DateTime.now().year.toString(),
        );
    super.initState();
  }

  void _toggleView() {
    setState(() {
      _isCalendarView = !_isCalendarView;
    });
  }

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(getEventsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const CustomAvatarAppbar(),
        title: const Text('Eventos'),
        actions: [
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
                  ? SfCalendar(
                    headerDateFormat: 'MMMM',
                    controller: _calendarController,
                    onViewChanged: (viewChangedDetails) {
                      ref
                          .read(getEventsProvider.notifier)
                          .loadEvents(
                            month:
                                _calendarController.displayDate!.month
                                    .toString(),
                            year:
                                _calendarController.displayDate!.year
                                    .toString(),
                          );
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
