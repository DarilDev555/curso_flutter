import '../../entities/event.dart';
import '../../entities/event_day.dart';

abstract class EventDaysDatasource {
  Future<Event> getEventDaysToEvent(String idEvent);

  Future<EventDay> getEventDay(String idEventDay);
}
