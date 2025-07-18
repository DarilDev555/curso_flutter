// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:tinycolor2/tinycolor2.dart';

import '../../../config/helpers/human_formats.dart';
import '../../../domain/entities/attendance.dart';
import '../../../domain/entities/event.dart';
import '../../providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/teacher.dart';
import '../../providers/events/event_days_provider.dart';
import '../../providers/teachers/teachers_and_attendance_to_event_day_providers.dart';
import '../../widgets/shared/text_frave.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  static const String name = 'attendance-screen';
  final String idEventDay;
  final String idEvent;

  const AttendanceScreen({
    super.key,
    required this.idEventDay,
    required this.idEvent,
  });

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
    final event = ref.watch(getEventDaysProvider)[widget.idEvent];
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Asistencia de Docentes - Día ${widget.idEventDay}'),
      // ),
      body:
          teachers == null
              ? const Center(child: CircularProgressIndicator())
              : Container(
                color: TinyColor.fromString('#ead1d9').color,

                child:
                    (event != null)
                        ? CustomScrollView(
                          slivers: [
                            SliverAppBar(
                              iconTheme: const IconThemeData(
                                color: Colors.white,
                                size: 32,
                              ),
                              title: TextFrave(
                                text: event.name,
                                color: Colors.white,
                                fontSize: 25,
                              ),
                              centerTitle: true,
                              backgroundColor:
                                  TinyColor.fromString('#88163a').color,
                              expandedHeight: 220,
                              pinned: true,
                              flexibleSpace: FlexibleSpaceBar(
                                // title: TextFrave(text: event.name),
                                background: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        TinyColor.fromString('#971840').color,
                                        TinyColor.fromString('#ead1d9').color,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: _InfoEvent(
                                    colors: colors,
                                    event: event,
                                  ),
                                ),
                              ),
                            ),

                            SliverList.builder(
                              itemCount: teachers.length,
                              itemBuilder:
                                  (context, index) => TeacherAttendanceCard(
                                    teacher: teachers[index],
                                    accessToken: accessToken,
                                  ),
                            ),

                            // SliverGrid.builder(
                            //   gridDelegate:
                            //       const SliverGridDelegateWithFixedCrossAxisCount(
                            //         crossAxisCount: 2,
                            //         mainAxisExtent: 800,
                            //         mainAxisSpacing: 8,
                            //         crossAxisSpacing: 8,
                            //       ),
                            //   itemCount: teachers.length,
                            //   itemBuilder: (context, index) {
                            //     final teacher = teachers[index];
                            //     final heigth = (index % 2 == 0) ? 300.0 : 600.0;
                            //     return Container(
                            //       height: heigth,
                            //       child: TeacherAttendanceCard(
                            //         teacher: teacher,
                            //         accessToken: accessToken,
                            //       ),
                            //     );
                            //   },
                            // // ),
                            // SliverPadding(
                            //   padding: const EdgeInsets.all(8),
                            //   sliver: SliverGrid(
                            //     gridDelegate: SliverQuiltedGridDelegate(
                            //       crossAxisCount: 8,
                            //       mainAxisSpacing: 4,
                            //       crossAxisSpacing: 4,
                            //       repeatPattern: QuiltedGridRepeatPattern.same,

                            //       pattern: [
                            //         // QuiltedGridTile(2, 2),
                            //         // QuiltedGridTile(1, 1),
                            //         // QuiltedGridTile(1, 1),
                            //         // QuiltedGridTile(1, 2),

                            //         // QuiltedGridTile(2, 2),
                            //         // QuiltedGridTile(1, 1),
                            //         // QuiltedGridTile(1, 1),
                            //         // QuiltedGridTile(1, 2),
                            //         QuiltedGridTile(3, 1),
                            //         QuiltedGridTile(3, 1),
                            //         QuiltedGridTile(3, 1),
                            //         QuiltedGridTile(3, 1),

                            //         QuiltedGridTile(3, 1),
                            //         QuiltedGridTile(3, 1),
                            //         QuiltedGridTile(3, 1),
                            //         QuiltedGridTile(3, 1),
                            //       ],
                            //     ),
                            //     delegate: SliverChildBuilderDelegate(
                            //       (context, index) => Container(
                            //         color: Colors.amber,
                            //         child: Text('${index}'),
                            //       ),
                            //       childCount: 20,
                            //     ),
                            //   ),
                            // ),
                          ],
                        )
                        : const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
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
        padding: const EdgeInsets.all(8),
        child: ExpansionTile(
          // leading:
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child:
                    teacher.avatar != null
                        ? Image.network(
                          height: 80,
                          teacher.avatar!,
                          headers: {'Authorization': 'Bearer $accessToken'},
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.image_not_supported_rounded,
                              color: TinyColor.fromString('#b65d79').color,
                            );
                          },
                        )
                        : Image.asset('assets/default_avatar.png'),
              ),
              Text(
                '${teacher.firstName} ${teacher.paternalLastName} ${teacher.maternalLastName}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Indicadores de asistencia
              if (teacher.attendance != null && teacher.attendance!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            teacher.attendance!.map((attendance) {
                              return AttendanceIndicator(
                                attendance: attendance,
                              );
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

          children:
              (teacher.attendance != null)
                  ? teacher.attendance!
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _InfoAttendanceTeacher(attendance: e),
                        ),
                      )
                      .toList()
                  : [],
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

class _InfoAttendanceTeacher extends StatelessWidget {
  final Attendance attendance;
  const _InfoAttendanceTeacher({required this.attendance});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          SizedBox(height: 50, width: 50, child: _getAttendanceIcon()),

          SizedBox(
            width: 200,
            height: 50,
            child: TextFrave(
              text: attendance.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          SizedBox(
            width: 105,
            height: 50,
            child: TextFrave(
              text: HumanFormats.justhourFormatToDatetime(
                attendance.attendanceTime,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 105,
            height: 50,
            child: TextFrave(
              text: HumanFormats.justhourFormatToDatetime(
                attendance.register?.registerTime,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Icon _getAttendanceIcon() {
    if (attendance.register == null) {
      return const Icon(Icons.cancel, color: Colors.red); // No asistió
    }

    final registerTime = attendance.register!.registerTime;
    final attendanceTime = attendance.attendanceTime;

    // Consideramos tardanza si llegó más de 5 minutos tarde
    const toleranceMinutes = 5;
    final difference = registerTime.difference(attendanceTime);

    if (difference.inMinutes <= toleranceMinutes) {
      return const Icon(
        Icons.check_circle,
        color: Colors.green,
      ); // Asistió a tiempo
    } else {
      return const Icon(
        Icons.watch_later,
        color: Colors.amber,
      ); // Asistió con tardanza
    }
  }
}

class _InfoEvent extends StatelessWidget {
  final Event event;
  const _InfoEvent({required this.colors, required this.event});

  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   event.name,
            //   style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            // ),
            const SizedBox(height: 50),
            Text(
              event.description,
              style: const TextStyle(fontSize: 22, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today, color: colors.primary, size: 50),
                const SizedBox(width: 8),
                Text(
                  '${HumanFormats.formatDate(event.startDate)} - ${HumanFormats.formatDate(event.endDate)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
