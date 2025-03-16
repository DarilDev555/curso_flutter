import '../../entities/event.dart';

abstract class EventsRepository {
  Future<List<Event>> getEvents({required String month, required String year});

  Future<Event> getEventById(String id);
}
