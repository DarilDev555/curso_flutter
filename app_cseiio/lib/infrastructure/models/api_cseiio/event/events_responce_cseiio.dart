import 'event_responce_cseiio.dart';

class EventsCseiioResponse {
  final List<EventResponceCseiio> events;

  EventsCseiioResponse({required this.events});

  factory EventsCseiioResponse.fromJson(Map<String, dynamic> json) =>
      EventsCseiioResponse(
        events: List<EventResponceCseiio>.from(
          json["events"].map((x) => EventResponceCseiio.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "events": List<dynamic>.from(events.map((x) => x.toJson())),
  };
}
