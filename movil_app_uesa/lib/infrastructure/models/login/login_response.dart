// To parse this JSON data, do
//
//     final teacherInstitutionResponse = teacherInstitutionResponseFromJson(jsonString);

import 'dart:convert';

import 'package:movil_app_uesa/infrastructure/models/login/user_role_login_response.dart';

LoginResponse teacherInstitutionResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String teacherInstitutionResponseToJson(LoginResponse data) =>
    json.encode(data.toJson());

class LoginResponse {
  final UserResponseAU user;
  final String accessToken;
  final String tokenType;

  LoginResponse({
    required this.user,
    required this.accessToken,
    required this.tokenType,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        user: UserResponseAU.fromJson(json["user"]),
        accessToken: json["access_token"],
        tokenType: json["token_type"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "access_token": accessToken,
        "token_type": tokenType,
      };
}
