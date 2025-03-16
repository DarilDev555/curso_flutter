import 'package:app_cseiio/domain/entities/event.dart';
import 'package:app_cseiio/infrastructure/models/api_cseiio/event/event_responce_cseiio.dart';

class EventMapper {
  static Event eventCseiioToEntity(EventResponceCseiio eventResponceCseiio) =>
      Event(
        id: eventResponceCseiio.id,
        name: eventResponceCseiio.name,
        startDate: eventResponceCseiio.startDate,
        endDate: eventResponceCseiio.endDate,
        description: eventResponceCseiio.description,
      );
}
