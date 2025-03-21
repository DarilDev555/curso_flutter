import 'package:app_cseiio/config/const/environment.dart';
import 'package:app_cseiio/domain/datasources/events/event_days_datasource.dart';
import 'package:app_cseiio/domain/entities/event_day.dart';
import 'package:app_cseiio/infrastructure/mappers/event_day_mapper.dart';
import 'package:app_cseiio/infrastructure/models/api_cseiio/event/event_day_response_cseiio.dart';
import '../../models/api_cseiio/event/event_days_response_cseiio.dart';
import 'package:dio/dio.dart';

class EventDaysDatasourceImpl extends EventDaysDatasource {
  final String accessToken;
  final Dio dio;

  EventDaysDatasourceImpl({required this.accessToken})
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
  Future<EventDay> getEventDay(String idEventDay) async {
    final response = await dio.get('/eventDay/$idEventDay');
    final EventDayResponseCseiio eventDayResponseCseiio =
        EventDayResponseCseiio.fromJson(response.data);
    return EventDayMapper.eventDayCseiioToEntity(eventDayResponseCseiio);
  }

  @override
  Future<List<EventDay>> getEventDaysToEvent(String idEvent) async {
    final response = await dio.get('/eventDaysToEvent/$idEvent');
    final EventDaysResponseCseiio eventDaysResponseCseiio =
        EventDaysResponseCseiio.fromJson(response.data);
    return eventDaysResponseCseiio.eventDays
        .map((e) => EventDayMapper.eventDayCseiioToEntity(e))
        .toList();
  }
}
