import '../../../domain/datasources/events/code_invitation_event_datasource.dart';
import '../../../domain/entities/invitation_code_event.dart';
import '../../../domain/repositories/events/code_invitation_event_repository.dart';

class CodeInvitationEventRepositoryImpl extends CodeInvitationEventRepository {
  final CodeInvitationEventDatasource codeInvitationEventDatasource;

  CodeInvitationEventRepositoryImpl({
    required this.codeInvitationEventDatasource,
  });

  @override
  Future<InvitationCodeEvent> getCodeInitationEvent(
    String id, {
    required int durationHours,
    int? maxUsers,
  }) {
    return codeInvitationEventDatasource.getCodeInitationEvent(
      id,
      durationHours: durationHours,
    );
  }
}
