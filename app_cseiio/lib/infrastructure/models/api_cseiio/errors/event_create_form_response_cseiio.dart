class EventCreateFormResponseCseiio {
  final String? name;
  final String? startDate;
  final String? endDate;
  final String? description;
  final String? dates;

  EventCreateFormResponseCseiio({
    this.name,
    this.startDate,
    this.endDate,
    this.description,
    this.dates,
  });

  factory EventCreateFormResponseCseiio.fromJson(Map<String, dynamic> json) =>
      EventCreateFormResponseCseiio(
        name: json["name"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        description: json["description"],
        dates: json['event_dates'],
      );

  Map<String, dynamic> toJson() => {
    "name": name,
    "start_date": startDate,
    "end_date": endDate,
    "description": description,
    'event_dates': dates,
  };
}
