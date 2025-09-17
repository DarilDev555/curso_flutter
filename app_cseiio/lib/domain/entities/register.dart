class Register {
  final String id;
  final String attendanceTeacherId;
  final String userId;
  final DateTime registerTime;

  Register({
    required this.id,
    required this.attendanceTeacherId,
    required this.userId,
    required this.registerTime,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "attendance_teacher_id": attendanceTeacherId,
    "user_id": userId,
    "register_time": registerTime.toIso8601String(),
  };
}
