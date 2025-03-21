import 'package:app_cseiio/domain/entities/event_day.dart';
import 'package:app_cseiio/infrastructure/models/api_cseiio/event/event_day_response_cseiio.dart';

class EventDayMapper {
  static EventDay eventDayCseiioToEntity(
    EventDayResponseCseiio eventDayResponseCseiio,
  ) {
    return EventDay(
      id: eventDayResponseCseiio.id,
      eventId: eventDayResponseCseiio.eventId,
      numDay: eventDayResponseCseiio.numDay,
      dateDayEvent: eventDayResponseCseiio.dateDayEvent,
      startTime: eventDayResponseCseiio.startTime,
      endTime: eventDayResponseCseiio.endTime,
    );
  }
}
