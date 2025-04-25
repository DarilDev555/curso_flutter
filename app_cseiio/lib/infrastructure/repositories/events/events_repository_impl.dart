import '../../../domain/datasources/events/events_datasource.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/repositories/events/events_repository.dart';

class EventsRepositoryImpl extends EventsRepository {
  final EventsDatasource eventsDatasource;

  EventsRepositoryImpl({required this.eventsDatasource});

  @override
  Future<Event> getEventById(String id) {
    return eventsDatasource.getEventById(id);
  }

  @override
  Future<List<Event>> getEvents({required String month, required String year}) {
    return eventsDatasource.getEvents(month: month, year: year);
  }
}
