import '../../../config/helpers/human_formats.dart';
import '../../../domain/entities/attendance.dart';
import '../../providers/auth/auth_provider.dart';
import '../event/event_days_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tinycolor2/tinycolor2.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/entities/event_day.dart';
import '../../../domain/entities/institution.dart';
import '../../../domain/entities/teacher.dart';
import '../../providers/teachers/teacher_details_provider.dart';
import '../../providers/teachers/teachers_provider.dart';

class TeacherDetailScreen extends ConsumerStatefulWidget {
  static const name = 'teacher-detail-screen';
  final String idTeacher;

  const TeacherDetailScreen({super.key, required this.idTeacher});

  @override
  TeacherDetailScreenState createState() => TeacherDetailScreenState();
}

class TeacherDetailScreenState extends ConsumerState<TeacherDetailScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(teacherDetailsProvider.notifier).loadEvents(widget.idTeacher);
    scrollController.addListener(() {
      if ((scrollController.position.pixels + 200) >=
          scrollController.position.maxScrollExtent) {
        ref.read(teacherDetailsProvider.notifier).loadEvents(widget.idTeacher);
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accessToken = ref.watch(authProvider).user!.token;
    final teacher = ref
        .watch(getTeachersProvider)
        .firstWhere((t) => t.id.toString() == widget.idTeacher);
    final data = ref.watch(teacherDetailsProvider)[widget.idTeacher];

    if (data == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final Institution institution = data['institution'];
    final List<Event> events = List<Event>.from(data['events']);

    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          _TeacherAppBar(teacher: teacher, accessToken: accessToken),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _PersonalInfoSection(teacher: teacher),
                  const SizedBox(height: 24),
                  _InstitutionSection(institution: institution),
                  const SizedBox(height: 24),
                  _EventsSection(events: events),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TeacherAppBar extends StatelessWidget {
  final Teacher teacher;
  final String accessToken;

  const _TeacherAppBar({required this.teacher, required this.accessToken});

  @override
  Widget build(BuildContext context) {
    final fullName =
        '${teacher.paternalLastName} ${teacher.maternalLastName} ${teacher.firstName}';

    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          fullName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        background: Stack(
          children: [
            Container(
              color: const Color.fromARGB(
                255,
                65,
                157,
                165,
              ).withValues(alpha: 0.4),
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child:
                    teacher.avatar != null && teacher.avatar!.isNotEmpty
                        ? Image.network(
                          teacher.avatar!,
                          headers: {"Authorization": "Bearer $accessToken"},
                          fit: BoxFit.cover,
                        )
                        : Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PersonalInfoSection extends StatelessWidget {
  final Teacher teacher;

  const _PersonalInfoSection({required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información personal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _InfoRow(icon: Icons.email, label: 'Correo', value: teacher.email),
            _InfoRow(
              icon: Icons.fingerprint,
              label: 'CURP',
              value: teacher.curp,
            ),
            _InfoRow(
              icon: Icons.how_to_vote,
              label: 'Código electoral',
              value: teacher.electoralCode,
            ),
            _InfoRow(
              icon: Icons.transgender,
              label: 'Género',
              value: teacher.gender,
            ),
            _InfoRow(
              icon: Icons.calendar_today,
              label: 'Registro',
              value: teacher.dateRegister.toLocal().toString().split(' ')[0],
            ),
          ],
        ),
      ),
    );
  }
}

class _InstitutionSection extends StatelessWidget {
  final Institution institution;

  const _InstitutionSection({required this.institution});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Institución',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: institution.background.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.school,
                    color: institution.background,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        institution.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Código: ${institution.code}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EventsSection extends StatelessWidget {
  final List<Event> events;

  const _EventsSection({required this.events});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Eventos',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...events.map((event) => _EventCard(event: event)),
      ],
    );
  }
}

class _EventCard extends StatelessWidget {
  final Event event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap:
          () => context.pushNamed(
            EventDaysScreen.name,
            queryParameters: {
              'event': event.id,
              'mounth': '${event.startDate.month}',
              'year': '${event.startDate.year}',
            },
          ),

      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: event.background.withValues(alpha: 1),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ExpansionTile(
            title: Text(
              event.name,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Text(
                        'INICIO',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        HumanFormats.formatDate(
                          event.startDate,
                          nameDay: true,
                          abreviado: true,
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Icon(
                      Icons.arrow_forward,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                  ),
                  Column(
                    children: [
                      const Text(
                        'FIN',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        HumanFormats.formatDate(
                          event.endDate,
                          nameDay: true,
                          abreviado: true,
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            children: [
              if (event.eventdays != null && event.eventdays!.isNotEmpty)
                ...event.eventdays!.map(
                  (eventDay) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _EventDayTile(
                      eventDay: eventDay,
                      colorBackground: event.background,
                    ),
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Sin días registrados'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventDayTile extends StatelessWidget {
  final EventDay eventDay;
  final Color colorBackground;

  const _EventDayTile({required this.eventDay, required this.colorBackground});

  @override
  Widget build(BuildContext context) {
    final Color color = TinyColor.fromColor(
      colorBackground,
    ).toColor().lighten(20);

    return ExpansionTile(
      shape: RoundedRectangleBorder(
        // Forma cuando está expandido
        borderRadius: BorderRadius.circular(16.0),
      ),
      collapsedShape: RoundedRectangleBorder(
        // Forma cuando está colapsado
        borderRadius: BorderRadius.circular(8.0),
      ),
      backgroundColor: color,
      collapsedBackgroundColor: color,
      title: Text(
        'Día ${eventDay.numDay} - ${HumanFormats.formatDate(eventDay.dateDayEvent, nameDay: true)}',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        'Horario: ${HumanFormats.timeStringToDateTimeFormat(eventDay.startTime)} - ${HumanFormats.timeStringToDateTimeFormat(eventDay.endTime)}',
      ),
      children: [
        if (eventDay.attendances != null && eventDay.attendances!.isNotEmpty)
          ...eventDay.attendances!.map(
            (att) => _AttendanceTile(
              attendance: att,
              colorBackground: colorBackground,
            ),
          )
        else
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Sin asistencias registradas'),
          ),
      ],
    );
  }
}

class _AttendanceTile extends StatelessWidget {
  final Attendance attendance;
  final int toleranceMinutes = 10; // Tolerancia de 10 minutos
  final Color colorBackground;

  const _AttendanceTile({
    required this.attendance,
    required this.colorBackground,
  });

  // Método para determinar el estado de la asistencia
  String _getAttendanceStatus() {
    if (attendance.register == null) return 'no_registered';

    final registerTime = attendance.register!.registerTime;
    final attendanceTime = attendance.attendanceTime;
    final difference = registerTime.difference(attendanceTime).inMinutes;

    if (difference <= toleranceMinutes && difference >= -toleranceMinutes) {
      return 'on_time';
    } else if (registerTime.isAfter(
      attendanceTime.add(Duration(minutes: toleranceMinutes)),
    )) {
      return 'late';
    } else {
      return 'on_time'; // Llegó antes del tiempo con tolerancia
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _getAttendanceStatus();
    final formattedAttendanceTime = HumanFormats.formateHour(
      attendance.attendanceTime.toString(),
    );
    final formattedRegisterTime =
        attendance.register != null
            ? HumanFormats.formateHour(
              attendance.register!.registerTime.toString(),
            )
            : null;
    final Color color = TinyColor.fromColor(
      colorBackground,
    ).toColor().lighten(30);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 1,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icono según estado
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getStatusIcon(status),
                    color: _getStatusColor(status),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    attendance.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (attendance.descripcion.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  attendance.descripcion,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hora programada',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      formattedAttendanceTime,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      status == 'no_registered' ? 'Estado' : 'Hora de registro',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    if (status == 'no_registered')
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Sin registro',
                          style: TextStyle(color: Colors.red[500]),
                        ),
                      )
                    else
                      Text(
                        formattedRegisterTime!,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: _getStatusColor(status),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (status != 'no_registered')
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status == 'on_time' ? 'A tiempo' : 'Con retraso',
                    style: TextStyle(
                      color: _getStatusColor(status),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Métodos auxiliares
  Color _getStatusColor(String status) {
    switch (status) {
      case 'on_time':
        return Colors.green;
      case 'late':
        return Colors.orange;
      case 'no_registered':
      default:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'on_time':
        return Icons.check_circle;
      case 'late':
        return Icons.watch_later;
      case 'no_registered':
      default:
        return Icons.error_outline;
    }
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blue.shade800),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
