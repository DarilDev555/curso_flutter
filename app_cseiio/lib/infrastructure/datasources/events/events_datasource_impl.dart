import '../../../config/const/environment.dart';
import '../../../config/helpers/human_formats.dart';
import '../../../domain/datasources/events/events_datasource.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/entities/event.dart';
import '../../../presentations/errors/auth_errors.dart';
import '../../mappers/errors_mapper.dart';
import '../../mappers/event_mapper.dart';
import '../../models/api_cseiio/errors/event_create_form_response_cseiio.dart';
import '../../models/api_cseiio/event/event_responce_cseiio.dart';
import '../../models/api_cseiio/event/events_responce_cseiio.dart';
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
            .map(EventMapper.eventCseiioToEntity)
            .toList();
    return events;
  }

  @override
  Future<Event> createEvent({
    String? idEvent,
    required String name,
    required String description,
    required DateTime inicialDate,
    required DateTime endDate,
    required List<DateTime> dates,
  }) async {
    try {
      final String method = (idEvent == null) ? 'POST' : 'PUT';
      final String url = (idEvent == null) ? '/event' : '/event/$idEvent';

      final respose = await dio.request(
        url,
        data: {
          "name": name,
          "start_date": HumanFormats.formatDateForSumitApi(inicialDate),
          "end_date": HumanFormats.formatDateForSumitApi(endDate),
          "description": description,
          "event_dates": dates.map(HumanFormats.formatDateForSumitApi).toList(),
        },
        options: Options(
          method: method,
          headers: {'Content-Type': 'application/json'},
        ),
      );

      final EventResponceCseiio eventResponceCseiio =
          EventResponceCseiio.fromJson(respose.data['event']);

      final event = EventMapper.eventCseiioToEntity(eventResponceCseiio);

      return event;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        //cambiar el EventCreateFormResponseCseiio por otro que de solo los errores
        final errorsCseiio = EventCreateFormResponseCseiio.fromJson(
          e.response?.data,
        );

        final errors = ErrorsMapper.errorsEventCreateFromCseiioToEntity(
          errorsCseiio,
        );

        throw FormErrorsStrings(
          errors: Map.fromEntries(
            errors.entries
                .where((entry) => entry.value is String)
                .map((entry) => MapEntry(entry.key, entry.value as String)),
          ),
        );
      }
      throw Exception();
    } on Exception catch (_) {
      throw Exception();
    }
  }

  @override
  Future<List<Event>> getEventsIncomplets() async {
    final response = await dio.get('/events/incomplete/cleanup');

    final eventsCseiioResponse = EventsCseiioResponse.fromJson(response.data);

    final List<Event> events =
        eventsCseiioResponse.events
            .map(EventMapper.eventCseiioToEntity)
            .toList();
    return events;
  }

  @override
  Future<Event> completeEvet({required Event event}) async {
    try {
      final request = buildEventPayload(event);

      final response = await dio.post(
        '/events/${event.id}/complete',
        data: request,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final EventResponceCseiio eventResponceCseiio =
          EventResponceCseiio.fromJson(response.data['event']);

      final newEvent = EventMapper.eventCseiioToEntity(eventResponceCseiio);

      return newEvent;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final message = e.response?.data['message'];
        throw CustomError(message: message);
      }
      throw Exception();
    } on Exception catch (_) {
      throw Exception();
    }
  }

  Map<String, dynamic> buildEventPayload(Event event) {
    return {
      "event_days":
          event.eventdays?.map((EventDay day) {
            return {
              'id': day.id,
              "num_day": day.numDay,
              "date_day_event":
                  "${day.dateDayEvent.year.toString().padLeft(4, '0')}-${day.dateDayEvent.month.toString().padLeft(2, '0')}-${day.dateDayEvent.day.toString().padLeft(2, '0')}",
              "start_time": HumanFormats.formatTimeForSumitApi(
                day.attendances!.first.attendanceTime,
              ),
              "end_time": HumanFormats.formatTimeForSumitApi(
                day.attendances!.last.attendanceTime,
              ),
              "attendances":
                  day.attendances?.map((a) {
                    return {
                      'id': a.id,
                      "name": a.name,
                      "descripcion": a.descripcion,
                      "attendance_time":
                          "${a.attendanceTime.year.toString().padLeft(4, '0')}-${a.attendanceTime.month.toString().padLeft(2, '0')}-${a.attendanceTime.day.toString().padLeft(2, '0')} ${a.attendanceTime.hour.toString().padLeft(2, '0')}:${a.attendanceTime.minute.toString().padLeft(2, '0')}:${a.attendanceTime.second.toString().padLeft(2, '0')}",
                    };
                  }).toList(),
            };
          }).toList(),
    };
  }

  @override
  Future<Event> updateEvent({required Event event}) async {
    try {
      final request = buildEventPayload(event);

      final response = await dio.put(
        '/event/${event.id}/updateEventWithEventDaysAndAttendance',
        data: request,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final EventResponceCseiio eventResponceCseiio =
          EventResponceCseiio.fromJson(response.data['event']);

      final newEvent = EventMapper.eventCseiioToEntity(eventResponceCseiio);

      return newEvent;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final message = e.response?.data['message'];
        throw CustomError(message: message);
      }
      throw Exception();
    } on Exception catch (_) {
      throw Exception();
    }
  }

  @override
  Future<Event> registerEventByInvitationCode({required String code}) async {
    try {
      final response = await dio.post(
        '/events/register-with-code',
        data: {'code': code},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final EventResponceCseiio eventResponceCseiio =
          EventResponceCseiio.fromJson(response.data['event']);

      final newEvent = EventMapper.eventCseiioToEntity(eventResponceCseiio);

      return newEvent;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final message = e.response?.data['message'];
        throw CustomError(message: message);
      }
      throw Exception();
    } on Exception catch (_) {
      throw Exception();
    }
  }
}
