import 'package:app_cseiio/domain/entities/event.dart';
import 'package:app_cseiio/presentations/providers/events/events_provider.dart';
import 'package:app_cseiio/presentations/widgets/shared/custom_avatar_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventsScreen extends ConsumerStatefulWidget {
  static const name = 'events-screen';
  const EventsScreen({super.key});

  @override
  EventsScreenState createState() => EventsScreenState();
}

class EventsScreenState extends ConsumerState<EventsScreen> {
  final CalendarController _calendarController = CalendarController();

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

  @override
  Widget build(BuildContext context) {
    final events = ref.watch(getEventsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: CustomAvatarAppbar(),
        title: const Text('Eventos'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SfCalendar(
            controller: _calendarController,
            onViewChanged: (viewChangedDetails) {
              ref
                  .read(getEventsProvider.notifier)
                  .loadEvents(
                    month: _calendarController.displayDate!.month.toString(),
                    year: _calendarController.displayDate!.year.toString(),
                  );
            },
            view: CalendarView.month,
            onTap: (calendarTapDetails) {
              print(calendarTapDetails.targetElement);
              if (calendarTapDetails.appointments!.isEmpty ||
                  calendarTapDetails.targetElement !=
                      CalendarElement.appointment) {
                return;
              }
              final Event meeting =
                  calendarTapDetails.appointments!.first as Event;

              context.push('/event-days-screen/${meeting.id}');

              return;
            },
            dataSource: MeetingDataSource(
              //events['${_calendarController.displayDate!.month}-${_calendarController.displayDate!.year}']!,
              events,
            ),
            headerStyle: CalendarHeaderStyle(
              backgroundColor: Colors.transparent,
              textStyle: TextStyle(fontSize: 25),
            ),
            monthViewSettings: MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
              showAgenda: true,
              agendaItemHeight: 60,
              dayFormat: 'EEE  ',
              agendaStyle: AgendaStyle(
                appointmentTextStyle: TextStyle(
                  fontSize: 17,
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
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
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return true;
  }
}
