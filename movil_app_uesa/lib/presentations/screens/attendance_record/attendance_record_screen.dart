import 'package:flutter/material.dart';
import 'package:movil_app_uesa/presentations/widgets/widgets.dart';

class AttendanceRecordScreen extends StatelessWidget {
  static const String name = 'attendance-record-screen';

  const AttendanceRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: _ViewTeachers(colors: colors),
    );
  }
}

class _ViewTeachers extends StatelessWidget {
  const _ViewTeachers({
    required this.colors,
  });

  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: Container(
              decoration: BoxDecoration(color: colors.surface),
              width: double.infinity,
              height: 250,
              child: TechearSlideshow(),
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
                icon: const Icon(
                  Icons.person_add_alt_1_outlined,
                  size: 30.0,
                ),
                label: const Text(
                  'Agregar',
                  textScaler: TextScaler.linear(1.2),
                ),
              ),
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
                icon: const Icon(
                  Icons.group_add_outlined,
                  size: 30.0,
                ),
                label: const Text(
                  'Registrar Asistencias',
                  textScaler: TextScaler.linear(1.2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
