import 'package:app_cseiio/domain/datasources/events/event_days_datasource.dart';
import 'package:app_cseiio/domain/entities/event_day.dart';

class EventDaysDatasourceImpl extends EventDaysDatasource {
  @override
  Future<EventDay> getEventDay(String idEventDay) {
    // TODO: implement getEventDay
    throw UnimplementedError();
  }

  @override
  Future<List<EventDay>> getEventDaysToEvent(String idEvent) {
    // TODO: implement getEventDaysToEvent
    throw UnimplementedError();
  }
}
