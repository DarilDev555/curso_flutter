import '../../entities/event_day.dart';

abstract class EventDaysDatasource {
  Future<List<EventDay>> getEventDaysToEvent(String idEvent);

  Future<EventDay> getEventDay(String idEventDay);
}
