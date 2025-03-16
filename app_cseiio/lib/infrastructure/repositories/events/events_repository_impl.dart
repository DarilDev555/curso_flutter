import 'package:app_cseiio/domain/datasources/events/events_datasource.dart';
import 'package:app_cseiio/domain/entities/event.dart';
import 'package:app_cseiio/domain/repositories/events/events_repository.dart';

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
