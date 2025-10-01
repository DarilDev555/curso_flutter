import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/event.dart';
import '../../../domain/entities/invitation_code_event.dart';
import 'events_repository_provider.dart';
import 'invitation_code_event_repository_provider.dart';

final invitationCodeEventProvider = StateNotifierProvider<
  InvitationCodeEventNotifier,
  Map<String, String>
>((ref) {
  final getEventByInitationCode =
      ref.watch(eventsRepositoryProvider).registerEventByInvitationCode;

  final genereteCodeInvitationEvent =
      ref.watch(invitationCodeEventRepositoryProvider).getCodeInitationEvent;

  return InvitationCodeEventNotifier(
    generateCodeInv: genereteCodeInvitationEvent,
    getEventByInvitationCode: getEventByInitationCode,
  );
});

typedef GenerateCodeInv =
    Future<InvitationCodeEvent> Function(
      String id, {
      required int durationHours,
      int? maxUsers,
    });

typedef GetEventByInvitationCode =
    Future<Event> Function({required String code});

class InvitationCodeEventNotifier extends StateNotifier<Map<String, String>> {
  InvitationCodeEventNotifier({
    required this.generateCodeInv,
    required this.getEventByInvitationCode,
  }) : super({});
  final GenerateCodeInv generateCodeInv;
  final GetEventByInvitationCode getEventByInvitationCode;

  bool isLoading = false;

  Future<void> genereteCode(String idEvent, {int maxUsers = 168}) async {
    if (isLoading) return;
    isLoading = true;

    if (state.containsKey(idEvent)) {
      isLoading = false;
      return;
    }

    final InvitationCodeEvent code = await generateCodeInv(
      idEvent,
      durationHours: 168,
      maxUsers: maxUsers,
    );

    state = {...state, idEvent: code.code};
    isLoading = false;
    return;
  }

  Future<Event?> registerEventByInvCode(String code) async {
    if (isLoading) return null;
    isLoading = true;

    final event = await getEventByInvitationCode(code: code);

    isLoading = false;
    return event;
  }
}
