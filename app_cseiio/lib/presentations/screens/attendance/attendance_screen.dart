import '../../../domain/entities/attendance.dart';
import '../../providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/teacher.dart';
import '../../providers/teachers/teachers_to_attendance_or_event_providers.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  static const String name = 'attendance-screen';
  final String idEventDay;

  const AttendanceScreen({super.key, required this.idEventDay});

  @override
  AttendanceScreenState createState() => AttendanceScreenState();
}

class AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    ref
        .read(getTeachersAndAttendanceToEventDayProvider.notifier)
        .loadTeachers(widget.idEventDay);

    controller.addListener(() {
      if ((controller.position.pixels + 200) >=
          controller.position.maxScrollExtent) {
        ref
            .read(getTeachersAndAttendanceToEventDayProvider.notifier)
            .loadTeachers(widget.idEventDay);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teachersState = ref.watch(getTeachersAndAttendanceToEventDayProvider);
    final teachers = teachersState[widget.idEventDay];
    final String accessToken = ref.watch(authProvider).user!.token;

    return Scaffold(
      appBar: AppBar(
        title: Text('Asistencia de Docentes - Día ${widget.idEventDay}'),
      ),
      body:
          teachers == null
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: teachers.length,
                controller: controller,
                itemBuilder: (context, index) {
                  final teacher = teachers[index];
                  return TeacherAttendanceCard(
                    teacher: teacher,
                    accessToken: accessToken,
                  );
                },
              ),
    );
  }
}

class TeacherAttendanceCard extends StatelessWidget {
  final Teacher teacher;
  final String accessToken;

  const TeacherAttendanceCard({
    super.key,
    required this.teacher,
    required this.accessToken,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información del profesor
            Row(
              children: [
                // Avatar del profesor
                CircleAvatar(
                  radius: 30,
                  child:
                      teacher.avatar != null
                          ? Image.network(
                            teacher.avatar!,
                            headers: {'Authorization': 'Bearer $accessToken'},
                          )
                          : Image.asset('assets/default_avatar.png'),
                ),
                const SizedBox(width: 16),
                // Nombre del profesor
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${teacher.firstName} ${teacher.paternalLastName} ${teacher.maternalLastName}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        teacher.email,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Indicadores de asistencia
            if (teacher.attendance != null && teacher.attendance!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Asistencias:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          teacher.attendance!.map((attendance) {
                            return AttendanceIndicator(attendance: attendance);
                          }).toList(),
                    ),
                  ),
                ],
              )
            else
              const Text(
                'No hay asistencias registradas',
                style: TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}

class AttendanceIndicator extends StatelessWidget {
  final Attendance attendance;

  const AttendanceIndicator({super.key, required this.attendance});

  Color _getAttendanceColor() {
    if (attendance.register == null) {
      return Colors.red; // No asistió
    }

    final registerTime = attendance.register!.registerTime;
    final attendanceTime = attendance.attendanceTime;

    // Consideramos tardanza si llegó más de 5 minutos tarde
    const toleranceMinutes = 5;
    final difference = registerTime.difference(attendanceTime);

    if (difference.inMinutes <= toleranceMinutes) {
      return Colors.green; // Asistió a tiempo
    } else {
      return Colors.orange; // Asistió con tardanza
    }
  }

  String _getTooltipText() {
    if (attendance.register == null) {
      return 'No asistió: ${attendance.name}';
    }

    final registerTime = attendance.register!.registerTime;
    final attendanceTime = attendance.attendanceTime;
    final difference = registerTime.difference(attendanceTime);

    if (difference.inMinutes <= 0) {
      return 'Asistió a tiempo: ${attendance.name}';
    } else {
      return 'Asistió con ${difference.inMinutes} min de retraso: ${attendance.name}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: _getTooltipText(),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: _getAttendanceColor(),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );
  }
}
