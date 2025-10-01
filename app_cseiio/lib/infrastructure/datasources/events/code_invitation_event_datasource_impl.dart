import 'package:dio/dio.dart';

import '../../../config/const/environment.dart';
import '../../../domain/datasources/events/code_invitation_event_datasource.dart';
import '../../../domain/entities/invitation_code_event.dart';
import '../../mappers/invitation_code_event_mapper.dart';
import '../../models/api_cseiio/event/code_invitation_event_response_cseiio.dart';

class CodeInvitationEventDatasourceImpl extends CodeInvitationEventDatasource {
  final String accessToken;
  final Dio dio;

  CodeInvitationEventDatasourceImpl({required this.accessToken})
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
  Future<InvitationCodeEvent> getCodeInitationEvent(
    String eventId, {
    required int durationHours,
    int? maxUsers,
  }) async {
    try {
      final response = await dio.post(
        '/events/$eventId/generate-invitation-code',
        data: {'duration_hours': durationHours, 'max_uses': maxUsers},
      );

      final CodeInvitationEventResponseCseiio
      codeInvitationEventResponseCseiio =
          CodeInvitationEventResponseCseiio.fromJson(response.data);

      return InvitationCodeEventMapper.invitationCodeEvent(
        codeInvitationEventResponseCseiio.invitationCode!,
      );

      // return InvitationCodeEvent.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to generate invitation code: $e');
    }
  }
}
