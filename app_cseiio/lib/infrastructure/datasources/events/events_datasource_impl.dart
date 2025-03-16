import 'package:app_cseiio/config/const/environment.dart';
import 'package:app_cseiio/domain/datasources/events/events_datasource.dart';
import 'package:app_cseiio/domain/entities/event.dart';
import 'package:app_cseiio/infrastructure/mappers/event_mapper.dart';
import 'package:app_cseiio/infrastructure/models/api_cseiio/event/event_responce_cseiio.dart';
import 'package:app_cseiio/infrastructure/models/api_cseiio/event/events_responce_cseiio.dart';
import 'package:dio/dio.dart';

class EventsDatasourceImpl extends EventsDatasource {
  final String accessToken;
  final Dio dio;

  EventsDatasourceImpl({required this.accessToken})
    : dio = Dio(
        BaseOptions(
          baseUrl: Environment.apiUrl,
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Accept': 'application/json',
          },
        ),
      );

  @override
  Future<Event> getEventById(String id) async {
    final response = await dio.get('/event/$id');
    final EventResponceCseiio eventReponseCseiio = EventResponceCseiio.fromJson(
      response.data,
    );
    return EventMapper.eventCseiioToEntity(eventReponseCseiio);
  }

  @override
  Future<List<Event>> getEvents({
    required String month,
    required String year,
  }) async {
    final response = await dio.get(
      '/event',
      queryParameters: {'month': month, 'year': year},
    );
    final eventsCseiioResponse = EventsCseiioResponse.fromJson(response.data);

    final List<Event> events =
        eventsCseiioResponse.events
            .map((e) => EventMapper.eventCseiioToEntity(e))
            .toList();
    return events;
  }
}
