import '../api_cseiio.dart';

class TeacherResponseCseiio {
  final int id;
  final int institutionId;
  final int? userId;
  final String firstName;
  final String paternalLastName;
  final String maternalLastName;
  final String gender;
  final String electoralCode;
  final String email;
  final String curp;
  final DateTime dateRegister;
  final String? avatar;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<AttendanceResponseCseiio>? attendances;

  TeacherResponseCseiio({
    required this.id,
    required this.institutionId,
    required this.userId,
    required this.firstName,
    required this.paternalLastName,
    required this.maternalLastName,
    required this.gender,
    required this.electoralCode,
    required this.email,
    required this.curp,
    required this.dateRegister,
    required this.avatar,
    required this.createdAt,
    required this.updatedAt,
    this.attendances,
  });

  factory TeacherResponseCseiio.fromJson(Map<String, dynamic> json) =>
      TeacherResponseCseiio(
        id: json["id"],
        institutionId: json["institution_id"],
        userId: json["user_id"],
        firstName: json["first_name"],
        paternalLastName: json["paternal_last_name"],
        maternalLastName: json["maternal_last_name"],
        gender: json["gender"],
        electoralCode: json["electoral_code"],
        email: json["email"],
        curp: json["curp"],
        dateRegister: DateTime.parse(json["date_register"]),
        avatar: json["avatar"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        attendances:
            json["attendances"] != null
                ? List<AttendanceResponseCseiio>.from(
                  json["attendances"].map(
                    (x) => AttendanceResponseCseiio.fromJson(x),
                  ),
                )
                : null,
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "institution_id": institutionId,
    "user_id": userId,
    "first_name": firstName,
    "paternal_last_name": paternalLastName,
    "maternal_last_name": maternalLastName,
    "gender": gender,
    "electoral_code": electoralCode,
    "email": email,
    "curp": curp,
    "date_register":
        "${dateRegister.year.toString().padLeft(4, '0')}-${dateRegister.month.toString().padLeft(2, '0')}-${dateRegister.day.toString().padLeft(2, '0')}",
    "avatar": avatar,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "attendances":
        attendances != null
            ? List<dynamic>.from(attendances!.map((x) => x.toJson()))
            : null,
  };
}
