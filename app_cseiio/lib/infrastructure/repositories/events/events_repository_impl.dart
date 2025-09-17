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

  @override
  Future<Event> createEvent({
    String? idEvent,
    required String name,
    required String description,
    required DateTime inicialDate,
    required DateTime endDate,
    required List<DateTime> dates,
  }) {
    return eventsDatasource.createEvent(
      idEvent: idEvent,
      name: name,
      description: description,
      inicialDate: inicialDate,
      endDate: endDate,
      dates: dates,
    );
  }

  @override
  Future<List<Event>> getEventsIncomplets() {
    return eventsDatasource.getEventsIncomplets();
  }

  @override
  Future<Event> completeEvet({required Event event}) {
    return eventsDatasource.completeEvet(event: event);
  }

  @override
  Future<Event> updateEvent({required Event event}) {
    return eventsDatasource.updateEvent(event: event);
  }
}
