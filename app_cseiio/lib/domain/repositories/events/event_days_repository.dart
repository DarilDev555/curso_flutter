import '../../entities/entities.dart';

abstract class EventDaysRepository {
  Future<Event> getEventDaysToEvent(String idEvent);

  Future<EventDay> getEventDay(String idEventDay);
}
