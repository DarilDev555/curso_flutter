import '../api_cseiio.dart';

class CodeInvitationEventResponseCseiio {
  final String? message;
  final InvitationCodeResponseCseiio? invitationCode;
  final EventResponceCseiio? eventResponceCseiio;

  CodeInvitationEventResponseCseiio({
    this.message,
    this.invitationCode,
    this.eventResponceCseiio,
  });

  factory CodeInvitationEventResponseCseiio.fromJson(
    Map<String, dynamic> json,
  ) => CodeInvitationEventResponseCseiio(
    message: json["message"],
    invitationCode:
        json["invitation_code"] == null
            ? null
            : InvitationCodeResponseCseiio.fromJson(json["invitation_code"]),
    eventResponceCseiio:
        json["event"] == null
            ? null
            : EventResponceCseiio.fromJson(json["event"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "invitation_code": invitationCode?.toJson(),
    "event": eventResponceCseiio?.toJson(),
  };
}

class InvitationCodeResponseCseiio {
  final String? code;
  final DateTime? expiresAt;
  final int? maxUses;
  final dynamic usedCount;

  InvitationCodeResponseCseiio({
    this.code,
    this.expiresAt,
    this.maxUses,
    this.usedCount,
  });

  factory InvitationCodeResponseCseiio.fromJson(Map<String, dynamic> json) =>
      InvitationCodeResponseCseiio(
        code: json["code"],
        expiresAt:
            json["expires_at"] == null
                ? null
                : DateTime.parse(json["expires_at"]),
        maxUses: json["max_uses"],
        usedCount: json["used_count"],
      );

  Map<String, dynamic> toJson() => {
    "code": code,
    "expires_at": expiresAt?.toIso8601String(),
    "max_uses": maxUses,
    "used_count": usedCount,
  };
}
