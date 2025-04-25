class Register {
  final int id;
  final int attendanceTeacherId;
  final int userId;
  final DateTime registerTime;
  final DateTime createdAt;

  Register({
    required this.id,
    required this.attendanceTeacherId,
    required this.userId,
    required this.registerTime,
    required this.createdAt,
  });
}
