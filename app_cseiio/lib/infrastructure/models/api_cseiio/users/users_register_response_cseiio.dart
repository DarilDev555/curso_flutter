import 'user_response_cseiio.dart';

class UsersRegisterResponseCseiio {
  final List<UserResponseCseiio> users;

  UsersRegisterResponseCseiio({required this.users});

  factory UsersRegisterResponseCseiio.fromJson(Map<String, dynamic> json) =>
      UsersRegisterResponseCseiio(
        users: List<UserResponseCseiio>.from(
          json["users"].map((x) => UserResponseCseiio.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "users": List<dynamic>.from(users.map((x) => x.toJson())),
  };
}
