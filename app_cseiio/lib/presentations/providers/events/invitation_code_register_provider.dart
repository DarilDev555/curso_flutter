import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import '../../../domain/entities/event.dart';
import '../../errors/auth_errors.dart';
import '../../inputs/invitation_code.dart';
import 'events_repository_provider.dart';

final registerTeacherByInvCodeProvider = StateNotifierProvider.autoDispose<
  InvitationCodeRegisterNotifier,
  InvitationCodeRegisterState
>((ref) {
  final registerEventCallBack =
      ref.watch(eventsRepositoryProvider).registerEventByInvitationCode;
  return InvitationCodeRegisterNotifier(registerEvent: registerEventCallBack);
});

typedef RegisterEvent = Future<Event> Function({required String code});

class InvitationCodeRegisterNotifier
    extends StateNotifier<InvitationCodeRegisterState> {
  final RegisterEvent registerEvent;

  InvitationCodeRegisterNotifier({required this.registerEvent})
    : super(InvitationCodeRegisterState());

  void onInvitationCodeChange(String value) {
    final newCode = InvitationCode.dirty(value);
    state = state.copyWith(code: newCode, isValid: Formz.validate([newCode]));
  }

  void changeQrScanner() {
    state = state.copyWith(isQrActivate: !state.isQrActivate);
  }

  void onFormSumit() async {
    if (state.isSumit) return;
    state = state.copyWith(isSumit: true, isFormPosted: true);
    final newCode = InvitationCode.dirty(state.code.value);
    final isValid = Formz.validate([newCode]);
    if (!isValid) {
      state = state.copyWith(code: newCode, isValid: isValid, isSumit: false);
      return;
    }

    try {
      final eventResponse = await registerEvent(code: state.code.value);

      state = state.copyWith(event: eventResponse, isSumit: false);
      return;
    } on CustomError catch (e) {
      state = state.copyWith(error: e.message, isSumit: false);
      return;
    }
  }
}

class InvitationCodeRegisterState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final bool isSumit;
  final bool isQrActivate;
  final InvitationCode code;
  final String? error;
  final Event? event;

  InvitationCodeRegisterState({
    this.isPosting = false,
    this.isFormPosted = true,
    this.isValid = false,
    this.isSumit = false,
    this.isQrActivate = false,
    this.code = const InvitationCode.pure(),
    this.error,
    this.event,
  });

  InvitationCodeRegisterState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    bool? isSumit,
    bool? isQrActivate,
    InvitationCode? code,
    String? error,
    Event? event,
  }) {
    return InvitationCodeRegisterState(
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
      isSumit: isSumit ?? this.isSumit,
      isQrActivate: isQrActivate ?? this.isQrActivate,
      code: code ?? this.code,
      error: error ?? this.error,
      event: event ?? this.event,
    );
  }
}
