import 'package:tinycolor2/tinycolor2.dart';

import '../../../config/helpers/human_formats.dart';
import '../../../domain/entities/attendance.dart';
import '../../../domain/entities/teacher.dart';
import '../../providers/attendance/attendance_provider.dart';
import '../../providers/auth/auth_provider.dart';
import '../../providers/storage/local_teachers_provider.dart';
import '../../providers/teachers/teachers_to_attendance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/shared/custom_icon_button.dart';
import '../../widgets/widgets.dart';
import 'attendance_scanner_qr.dart';

class AttendanceRecordScreen extends ConsumerStatefulWidget {
  static const String name = 'attendance-record-screen';

  final int idAttendance;

  const AttendanceRecordScreen({super.key, required this.idAttendance});

  @override
  AttendanceRecordScreenState createState() => AttendanceRecordScreenState();
}

class AttendanceRecordScreenState
    extends ConsumerState<AttendanceRecordScreen> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    ref
        .read(teachersToAttendanceProvider.notifier)
        .loadTeachers(idAttendance: widget.idAttendance.toString());
    ref
        .read(getAttendanceProvider.notifier)
        .getAttendance(widget.idAttendance.toString());

    ref.read(localTeachersProvider.notifier).loadTeachers(widget.idAttendance);

    scrollController.addListener(() {
      if ((scrollController.position.pixels + 200) >=
          scrollController.position.maxScrollExtent) {
        ref
            .read(teachersToAttendanceProvider.notifier)
            .loadTeachers(idAttendance: widget.idAttendance.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final teachers =
        ref.watch(teachersToAttendanceProvider)[widget.idAttendance.toString()];
    final accessToken = ref.watch(authProvider).user!.token;
    final attendance =
        ref.watch(getAttendanceProvider)[widget.idAttendance.toString()];
    final teachersLocal = ref.watch(localTeachersProvider)[widget.idAttendance];

    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(
                Icons.refresh_rounded,
                color: Colors.white,
                size: 30,
              ),
              onPressed:
                  () => ref
                      .read(teachersToAttendanceProvider.notifier)
                      .reloadTeachersToApi(
                        idAttendance: widget.idAttendance.toString(),
                      ),
            ),
          ),
        ],
        titleSpacing: 10,
        toolbarHeight: 100,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            TextFrave(
              text:
                  (attendance == null)
                      ? 'Registro'
                      : '${attendance.name} \n${HumanFormats.hourFormatToDatetime(attendance.attendanceTime, list: false)}',
              fontSize: 20,
              color: TinyColor.fromString('#f5e8ec').color,
              maxLines: 3,
            ),
          ],
        ),
        backgroundColor: colors.primary,
      ),
      body: _ViewTeachers(
        colors: colors,
        idAttendance: widget.idAttendance,
        accessToken: accessToken,
        attendance: attendance,
        teachers: teachers,
        size: size,
        controller: scrollController,
        summitCallBack:
            (teachersLocal == null || teachersLocal.isEmpty)
                ? null
                : () {
                  ref
                      .read(teachersToAttendanceProvider.notifier)
                      .summitTeahcers(
                        teachersLocal,
                        widget.idAttendance.toString(),
                      );
                },
      ),
    );
  }
}

class _ViewTeachers extends StatelessWidget {
  final int idAttendance;
  final ColorScheme colors;
  final List<Teacher>? teachers;
  final String accessToken;
  final Attendance? attendance;
  final Size size;
  final ScrollController controller;
  final void Function()? summitCallBack;

  const _ViewTeachers({
    required this.teachers,
    required this.accessToken,
    required this.attendance,
    required this.colors,
    required this.idAttendance,
    required this.size,
    required this.controller,
    required this.summitCallBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: size.height * 0.50,
            child:
                (teachers != null && attendance != null)
                    ? ListView.builder(
                      controller: controller,
                      itemCount: teachers!.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: 110,
                          width: double.infinity,
                          child: _TeacherRegisterCard(
                            accessToken: accessToken,
                            teacher: teachers![index],
                            attendanceRegister: (attendance!.attendanceTime.add(
                              const Duration(minutes: 5),
                            )),
                            // attendanceRegister: ,
                          ),
                        );
                      },
                    )
                    : const Center(child: CircularProgressIndicator()),
          ),
        ),
        _ScanerQrSection(
          size: size,
          idAttendance: idAttendance,
          colors: colors,
          summitCallBack: summitCallBack,
        ),
      ],
    );
  }
}

class _TeacherRegisterCard extends StatelessWidget {
  final Teacher teacher;
  final String accessToken;
  final DateTime attendanceRegister;
  const _TeacherRegisterCard({
    required this.teacher,
    required this.accessToken,
    required this.attendanceRegister,
  });

  @override
  Widget build(BuildContext context) {
    final Color color =
        (teacher.attendanceRegister == null)
            ? Colors.red
            : (teacher.attendanceRegister!.isAfter(attendanceRegister))
            ? Colors.orange
            : Colors.green;

    return Card(
      surfaceTintColor: color,
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Hero(
                tag: 'teacher-${teacher.id}',
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: TinyColor.fromString('#971840').color,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      filterQuality: FilterQuality.none,
                      teacher.avatar ??
                          'https://static.thenounproject.com/png/1669490-200.png',
                      fit: BoxFit.cover,
                      headers: {"Authorization": "Bearer $accessToken"},
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress != null) {
                          return Center(
                            child: CircularProgressIndicator(
                              value:
                                  loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                            ),
                          );
                        }
                        return child;
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image_not_supported_rounded,
                          size: 30,
                          color: TinyColor.fromString('#b65d79').color,
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFrave(
                      text:
                          '${teacher.id}  ${teacher.firstName} ${teacher.paternalLastName} ${teacher.maternalLastName}',
                      color: TinyColor.fromString('#5b0e26').color,
                    ),
                    const SizedBox(height: 4),
                    TextFrave(
                      text: teacher.email,
                      fontSize: 15,
                      color: TinyColor.fromString('#791333').color,
                    ),
                  ],
                ),
              ),
              (teacher.attendanceRegister != null)
                  ? TextFrave(
                    text:
                        '  ◉ ${HumanFormats.justhourFormatToDatetime(teacher.attendanceRegister!)}',
                    color: TinyColor.fromString('#5b0e26').color,
                  )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanerQrSection extends StatelessWidget {
  final Size size;
  final int idAttendance;
  final ColorScheme colors;
  final void Function()? summitCallBack;

  const _ScanerQrSection({
    required this.size,
    required this.idAttendance,
    required this.colors,
    required this.summitCallBack,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height * 0.3,
      width: double.infinity,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(15),
            ),
            width: size.width * 0.75,
            height: double.infinity,
            child: TeacherSlideshow(
              idAttendance: idAttendance,
              heightAvatar: size.width * 0.17,
              widthAvatar: size.width * 0.17,
              viewHourRegister: true,
              margin: EdgeInsets.symmetric(vertical: size.height * 0.05),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconButton(
                  background: TinyColor.fromString('#187397').color,
                  colorLabel: TinyColor.fromString('#d1e3ea').color,
                  label: 'Subir',
                  width: size.width * 0.2,

                  icon: Icon(
                    Icons.upload_rounded,
                    color: TinyColor.fromString('#d1e3ea').color,
                  ),
                  callback: summitCallBack,
                ),
                // _SummitsTeachersToApi(colors: colors, idAttendance: idAttendance),
                const SizedBox(height: 15),
                CustomIconButton(
                  width: size.width * 0.2,
                  background: TinyColor.fromString('#168864').color,
                  colorLabel: TinyColor.fromString('#d1eae2').color,
                  label: 'Agregar',
                  icon: Icon(
                    Icons.qr_code_scanner_rounded,
                    color: TinyColor.fromString('#d1eae2').color,
                  ),
                  callback: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder:
                            (context) =>
                                AttendanceScannerQr(idAttendance: idAttendance),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // const Divider(),
        ],
      ),
    );
  }
}





// const SizedBox(height: 10),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: TextFormField(
//             decoration: InputDecoration(
//               labelText: 'ID del Profesor',
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               prefixIcon: Icon(Icons.person_outline, color: colors.primary),
//             ),
//           ),
//         ),