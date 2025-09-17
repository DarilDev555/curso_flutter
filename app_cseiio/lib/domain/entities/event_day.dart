import 'attendance.dart';

class EventDay {
  final int id;
  final int eventId;
  final int numDay;
  final DateTime dateDayEvent;
  final String startTime;
  final String endTime;
  final List<Attendance>? attendances;

  EventDay({
    this.id = -1,
    this.eventId = -1,
    required this.numDay,
    required this.dateDayEvent,
    required this.startTime,
    required this.endTime,
    this.attendances,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "event_id": eventId,
    "num_day": numDay,
    "date_day_event":
        "${dateDayEvent.year.toString().padLeft(4, '0')}-${dateDayEvent.month.toString().padLeft(2, '0')}-${dateDayEvent.day.toString().padLeft(2, '0')}",
    "start_time": startTime,
    "end_time": endTime,
    "attendance":
        attendances != null
            ? List<dynamic>.from(attendances!.map((x) => x.toJson()))
            : null,
  };

  EventDay copyWith({
    int? id,
    int? eventId,
    int? numDay,
    DateTime? dateDayEvent,
    String? startTime,
    String? endTime,
    List<Attendance>? attendances,
  }) {
    return EventDay(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      numDay: numDay ?? this.numDay,
      dateDayEvent: dateDayEvent ?? this.dateDayEvent,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      attendances: attendances ?? this.attendances,
    );
  }
}
