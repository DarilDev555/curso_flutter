class EventDayResponseCseiio {
  final int id;
  final int eventId;
  final int numDay;
  final DateTime dateDayEvent;
  final String startTime;
  final String endTime;

  EventDayResponseCseiio({
    required this.id,
    required this.eventId,
    required this.numDay,
    required this.dateDayEvent,
    required this.startTime,
    required this.endTime,
  });

  factory EventDayResponseCseiio.fromJson(Map<String, dynamic> json) =>
      EventDayResponseCseiio(
        id: json["id"],
        eventId: json["event_id"],
        numDay: json["num_day"],
        dateDayEvent: DateTime.parse(json["date_day_event"]),
        startTime: json["start_time"],
        endTime: json["end_time"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "event_id": eventId,
    "num_day": numDay,
    "date_day_event":
        "${dateDayEvent.year.toString().padLeft(4, '0')}-${dateDayEvent.month.toString().padLeft(2, '0')}-${dateDayEvent.day.toString().padLeft(2, '0')}",
    "start_time": startTime,
    "end_time": endTime,
  };
}
