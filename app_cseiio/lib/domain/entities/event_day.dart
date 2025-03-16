class EventDay {
  final int id;
  final int eventId;
  final int numDay;
  final DateTime dateDayEvent;
  final DateTime startTime;
  final DateTime endTime;

  EventDay({
    required this.id,
    required this.eventId,
    required this.numDay,
    required this.dateDayEvent,
    required this.startTime,
    required this.endTime,
  });
}
