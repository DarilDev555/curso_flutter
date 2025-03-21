import 'event_day_response_cseiio.dart';

class EventDaysResponseCseiio {
  final List<EventDayResponseCseiio> eventDays;

  EventDaysResponseCseiio({required this.eventDays});

  factory EventDaysResponseCseiio.fromJson(Map<String, dynamic> json) =>
      EventDaysResponseCseiio(
        eventDays: List<EventDayResponseCseiio>.from(
          json["event_day"].map((x) => EventDayResponseCseiio.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "event_day": List<dynamic>.from(eventDays.map((x) => x.toJson())),
  };
}
