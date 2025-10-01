import '../../domain/entities/invitation_code_event.dart';
import '../models/api_cseiio/event/code_invitation_event_response_cseiio.dart';

class InvitationCodeEventMapper {
  static InvitationCodeEvent invitationCodeEvent(
    InvitationCodeResponseCseiio invitationCodeResponseCseiio,
  ) {
    return InvitationCodeEvent(
      code: invitationCodeResponseCseiio.code!,
      expiresAt: invitationCodeResponseCseiio.expiresAt,
      maxUses: invitationCodeResponseCseiio.maxUses,
      usedCount: invitationCodeResponseCseiio.usedCount,
    );
  }
}
