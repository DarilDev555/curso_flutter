class InvitationCodeEvent {
  final String code;
  final DateTime? expiresAt;
  final int? maxUses;
  final int? usedCount;

  InvitationCodeEvent({
    required this.code,
    this.expiresAt,
    this.maxUses,
    this.usedCount,
  });
}
