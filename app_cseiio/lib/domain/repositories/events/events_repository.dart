import '../../entities/event.dart';

abstract class EventsRepository {
  Future<List<Event>> getEvents({required String month, required String year});

  Future<Event> getEventById(String id);

  Future<Event> createEvent({
    String? idEvent,
    required String name,
    required String description,
    required DateTime inicialDate,
    required DateTime endDate,
    required List<DateTime> dates,
  });

  Future<List<Event>> getEventsIncomplets();

  Future<Event> completeEvet({required Event event});

  Future<Event> updateEvent({required Event event});

  Future<Event> registerEventByInvitationCode({required String code});
}
