class RegisterResponseCseiio {
  final int id;
  final int attendanceTeacherId;
  final int userId;
  final DateTime registerTime;
  final DateTime createdAt;

  RegisterResponseCseiio({
    required this.id,
    required this.attendanceTeacherId,
    required this.userId,
    required this.registerTime,
    required this.createdAt,
  });

  factory RegisterResponseCseiio.fromJson(Map<String, dynamic> json) =>
      RegisterResponseCseiio(
        id: json["id"],
        attendanceTeacherId: json["attendance_teacher_id"],
        userId: json["user_id"],
        registerTime: DateTime.parse(json["register_time"]),
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "attendance_teacher_id": attendanceTeacherId,
    "user_id": userId,
    "register_time": registerTime.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
  };
}
