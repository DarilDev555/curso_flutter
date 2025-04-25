import '../../../domain/datasources/events/event_days_datasource.dart';
import '../../../domain/entities/event_day.dart';
import '../../../domain/repositories/events/event_days_repository.dart';

class EventDaysRespositoryImpl extends EventDaysRepository {
  final EventDaysDatasource eventDaysDatasource;

  EventDaysRespositoryImpl({required this.eventDaysDatasource});

  @override
  Future<EventDay> getEventDay(String idEventDay) {
    return eventDaysDatasource.getEventDay(idEventDay);
  }

  @override
  Future<List<EventDay>> getEventDaysToEvent(String idEvent) {
    return eventDaysDatasource.getEventDaysToEvent(idEvent);
  }
}
