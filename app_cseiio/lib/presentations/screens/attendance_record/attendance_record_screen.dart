import '../../widgets/shared/custom_avatar_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/storage/local_teachers_provider.dart';
import '../../widgets/widgets.dart';
import 'attendance_scanner_qr.dart';

class AttendanceRecordScreen extends StatelessWidget {
  static const String name = 'attendance-record-screen';

  final int idAttendance;

  const AttendanceRecordScreen({super.key, required this.idAttendance});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: const CustomAvatarAppbar(),
        title: Text('Registro', style: TextStyle(color: colors.onPrimary)),
        backgroundColor: colors.primary,
      ),
      body: _ViewTeachers(colors: colors, idAttendance: idAttendance),
    );
  }
}

class _ViewTeachers extends ConsumerWidget {
  final int idAttendance;
  final ColorScheme colors;

  const _ViewTeachers({required this.colors, required this.idAttendance});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(15),
            ),
            width: double.infinity,
            height: 220,
            child: TeacherSlideshow(idAttendance: idAttendance),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              ref.read(localTeachersProvider).values.where((teacher) {
                if (teacher.idAttendance == idAttendance) {
                  ref
                      .read(localTeachersProvider.notifier)
                      .toggleSaveOrRemove(teacher);
                }
                return false;
              }).toList();
            },
            icon: const Icon(
              Icons.group_add_outlined,
              size: 30.0,
              color: Colors.white,
            ),
            label: const Text(
              'Registrar Asistencias',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 15),
          TextButtonQr(colors: colors, idAttendance: idAttendance),
        ],
      ),
    );
  }
}

class TextButtonQr extends ConsumerWidget {
  final int idAttendance;
  final ColorScheme colors;

  const TextButtonQr({
    super.key,
    required this.colors,
    required this.idAttendance,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.secondary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () async {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder:
                    (context) =>
                        AttendanceScannerQr(idAttendance: idAttendance),
              ),
            );

            // Teacher tempTeacher = await ref
            //     .read(getTeachersProvider.notifier)
            //     .getTeacher(id: '57');

            // tempTeacher.idAttendance = idAttendance;

            // await ref
            //     .read(localTeachersProvider.notifier)
            //     .toggleSaveOrRemove(tempTeacher);
          },
          icon: const Icon(
            Icons.person_add_alt_1_outlined,
            size: 30.0,
            color: Colors.white,
          ),
          label: const Text(
            'Agregar',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'ID del Profesor',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: Icon(Icons.person_outline, color: colors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
