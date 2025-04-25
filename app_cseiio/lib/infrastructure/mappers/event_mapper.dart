import '../../domain/entities/event.dart';
import 'event_day_mapper.dart';
import '../models/api_cseiio/event/event_responce_cseiio.dart';

class EventMapper {
  static Event eventCseiioToEntity(EventResponceCseiio eventResponceCseiio) =>
      Event(
        id: eventResponceCseiio.id,
        name: eventResponceCseiio.name,
        startDate: eventResponceCseiio.startDate,
        endDate: eventResponceCseiio.endDate,
        description: eventResponceCseiio.description,
        eventdays:
            eventResponceCseiio.eventDays
                ?.map(EventDayMapper.eventDayCseiioToEntity)
                .toList(),
      );
}
