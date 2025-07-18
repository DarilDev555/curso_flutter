import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/attendance.dart';
import 'attendance_repository_provider.dart';

final getAttendanceProvider =
    StateNotifierProvider<AttendanceNotifier, Map<String, Attendance>>((ref) {
      final attendanceCallBack =
          ref.watch(attendanceRepositoryProvider).getAttendance;

      return AttendanceNotifier(attendanceCallBack: attendanceCallBack);
    });

typedef AttendanceCallBack = Future<Attendance> Function(String idAttendance);

class AttendanceNotifier extends StateNotifier<Map<String, Attendance>> {
  final AttendanceCallBack attendanceCallBack;
  bool isLoading = false;

  AttendanceNotifier({required this.attendanceCallBack}) : super({});

  Future<void> getAttendance(String idAttendance) async {
    if (isLoading) return;
    isLoading = true;

    if (state[idAttendance] != null) {
      isLoading = false;
      return;
    }

    final Attendance attendance = await attendanceCallBack(idAttendance);

    state = {...state, idAttendance: attendance};
    isLoading = false;
    return;
  }
}
