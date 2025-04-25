import '../api_cseiio.dart';

class EventResponceCseiio {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final List<EventDayResponseCseiio>? eventDays;

  EventResponceCseiio({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.description,
    this.eventDays,
  });

  factory EventResponceCseiio.fromJson(Map<String, dynamic> json) =>
      EventResponceCseiio(
        id: json["id"].toString(),
        name: json["name"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        description: json["description"],
        eventDays:
            json["event_days"] != null
                ? List<EventDayResponseCseiio>.from(
                  json["event_days"].map(
                    (x) => EventDayResponseCseiio.fromJson(x),
                  ),
                )
                : null,
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "start_date":
        "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "end_date":
        "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
    "description": description,
    "event_days":
        eventDays != null
            ? List<dynamic>.from(eventDays!.map((x) => x.toJson()))
            : null,
  };
}
