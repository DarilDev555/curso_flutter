import 'package:app_cseiio/presentations/widgets/shared/custom_avatar_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_cseiio/presentations/providers/storage/local_teachers_provider.dart';
import 'package:app_cseiio/presentations/providers/teachers/teachers_provider.dart';
import 'package:app_cseiio/presentations/widgets/widgets.dart';

class AttendanceRecordScreen extends StatelessWidget {
  static const String name = 'attendance-record-screen';

  const AttendanceRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(leading: CustomAvatarAppbar(), title: Text('Registro')),
      body: _ViewTeachers(colors: colors),
    );
  }
}

class _ViewTeachers extends StatelessWidget {
  const _ViewTeachers({required this.colors});

  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              decoration: BoxDecoration(color: colors.surface),
              width: double.infinity,
              height: 250,
              child: const TechearSlideshow(),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(colors.onPrimary),
                ),
                onPressed: () {},
                icon: const Icon(Icons.group_add_outlined, size: 30.0),
                label: const Text(
                  'Registrar Asistencias',
                  textScaler: TextScaler.linear(1.2),
                ),
              ),
            ),
          ),
          TextButtonQr(colors: colors),
        ],
      ),
    );
  }
}

class TextButtonQr extends ConsumerStatefulWidget {
  const TextButtonQr({super.key, required this.colors});

  final ColorScheme colors;

  @override
  TextButtonQrState createState() => TextButtonQrState();
}

class TextButtonQrState extends ConsumerState<TextButtonQr> {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(0),
          child: ElevatedButton.icon(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(widget.colors.onPrimary),
            ),
            onPressed: () async {
              final tempTeacher = await ref
                  .read(getTeachersProvider.notifier)
                  .getTeacher(id: controller.text);

              await ref
                  .read(localTecahersProvider.notifier)
                  .toggleSaveOrRemove(tempTeacher);
            },
            icon: const Icon(Icons.person_add_alt_1_outlined, size: 30.0),
            label: const Text('Agregar', textScaler: TextScaler.linear(1.2)),
          ),
        ),
        Form(child: TextFormField(controller: controller)),
      ],
    );
  }
}
