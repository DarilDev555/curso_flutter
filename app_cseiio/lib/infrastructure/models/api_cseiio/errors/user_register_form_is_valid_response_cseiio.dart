class UserRegisterFormIsValidResponseCseiio {
  final List<String> userName;
  final List<String> email;
  final List<String> password;
  final List<String> firstName;
  final List<String> paternalLastName;
  final List<String> maternalLastName;
  final List<String> gender;
  final List<String> electoralCode;
  final List<String> curp;
  final List<String> institutionId;

  UserRegisterFormIsValidResponseCseiio({
    required this.userName,
    required this.email,
    required this.password,
    required this.firstName,
    required this.paternalLastName,
    required this.maternalLastName,
    required this.gender,
    required this.electoralCode,
    required this.curp,
    required this.institutionId,
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
    firstName:
        json['firstName'] != null
            ? List<String>.from(json["firstName"].map((x) => x))
            : [],
    paternalLastName:
        json['paternalLastName'] != null
            ? List<String>.from(json["paternalLastName"].map((x) => x))
            : [],
    maternalLastName:
        json['maternalLastName'] != null
            ? List<String>.from(json["maternalLastName"].map((x) => x))
            : [],
    gender:
        json['gender'] != null
            ? List<String>.from(json["gender"].map((x) => x))
            : [],
    electoralCode:
        json['electoralCode'] != null
            ? List<String>.from(json["electoralCode"].map((x) => x))
            : [],
    curp:
        json['curp'] != null
            ? List<String>.from(json["curp"].map((x) => x))
            : [],
    institutionId:
        json['institution_id'] != null
            ? List<String>.from(json["institution_id"].map((x) => x))
            : [],
  );

  Map<String, dynamic> toJson() => {
    "userName": List<dynamic>.from(userName.map((x) => x)),
    "email": List<dynamic>.from(email.map((x) => x)),
    "password": List<dynamic>.from(password.map((x) => x)),
    "firstName": List<dynamic>.from(firstName.map((x) => x)),
    "paternalLastName": List<dynamic>.from(paternalLastName.map((e) => e)),
    "maternalLastName": List<dynamic>.from(maternalLastName.map((e) => e)),
    "gender": List<dynamic>.from(gender.map((e) => e)),
    "electoralCode": List<dynamic>.from(electoralCode.map((e) => e)),
    "curp": List<dynamic>.from(curp.map((e) => e)),
    "institutionId": List<dynamic>.from(institutionId.map((e) => e)),
  };
}
