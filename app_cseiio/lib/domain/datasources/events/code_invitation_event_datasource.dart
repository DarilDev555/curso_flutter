import '../../entities/invitation_code_event.dart';

abstract class CodeInvitationEventDatasource {
  Future<InvitationCodeEvent> getCodeInitationEvent(
    String id, {
    required int durationHours,
    int maxUsers,
  });
}
