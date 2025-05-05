class UserRegisterFormIsValidResponseCseiio {
  final List<String> userName;
  final List<String> email;
  final List<String> password;

  UserRegisterFormIsValidResponseCseiio({
    required this.userName,
    required this.email,
    required this.password,
  });

  factory UserRegisterFormIsValidResponseCseiio.fromJson(
    Map<String, dynamic> json,
  ) => UserRegisterFormIsValidResponseCseiio(
    userName:
        json['userName'] != null
            ? List<String>.from(json["userName"].map((x) => x))
            : [],
    email:
        json['email'] != null
            ? List<String>.from(json["email"].map((x) => x))
            : [],
    password:
        json['password'] != null
            ? List<String>.from(json["password"].map((x) => x))
            : [],
  );

  Map<String, dynamic> toJson() => {
    "userName": List<dynamic>.from(userName.map((x) => x)),
    "email": List<dynamic>.from(email.map((x) => x)),
    "password": List<dynamic>.from(password.map((x) => x)),
  };
}
