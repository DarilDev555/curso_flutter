import '../../entities/invitation_code_event.dart';

abstract class CodeInvitationEventRepository {
  Future<InvitationCodeEvent> getCodeInitationEvent(
    String id, {
    required int durationHours,
    int maxUsers,
  });
}
