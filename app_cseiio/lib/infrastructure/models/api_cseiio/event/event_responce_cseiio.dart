class EventResponceCseiio {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final String description;

  EventResponceCseiio({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.description,
  });

  factory EventResponceCseiio.fromJson(Map<String, dynamic> json) =>
      EventResponceCseiio(
        id: json["id"],
        name: json["name"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "start_date":
        "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "end_date":
        "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
    "description": description,
  };
}
