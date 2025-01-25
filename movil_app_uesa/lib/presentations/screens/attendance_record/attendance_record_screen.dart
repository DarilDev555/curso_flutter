import 'dart:math';

import 'package:flutter/material.dart';
import 'package:movil_app_uesa/presentations/widgets/widgets.dart';
import 'dart:math' show Random;

class AttendanceRecordScreen extends StatelessWidget {
  static const String name = 'attendance-record-screen';

  const AttendanceRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: Container(
              decoration: BoxDecoration(color: colors.surface),
              width: double.infinity,
              height: 300,
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

class Page extends StatelessWidget {
  final random = Random();
  late final int avatarId;

  Page({
    super.key,
  }) {
    avatarId = random.nextInt(100);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: InkWell(
        onDoubleTap: () {
          print('as');
        },
        child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        'https://randomuser.me/api/portraits/men/$avatarId.jpg'),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFrave(
                  text: 'Clave',
                  maxLines: 1,
                  color: colors.onPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                TextFrave(
                  text: '25S4SAD4SA5D',
                  maxLines: 1,
                  color: colors.onPrimary,
                  fontSize: 15,
                ),
                TextFrave(
                  text: 'Nombre',
                  maxLines: 1,
                  color: colors.onPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                TextFrave(
                  text: 'Nombre Apellido',
                  maxLines: 1,
                  color: colors.onPrimary,
                  fontSize: 15,
                ),
                TextFrave(
                  text: 'Institucción',
                  maxLines: 1,
                  color: colors.onPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                TextFrave(
                  text: 'Unidad de Estudios Superiores de Alotepec',
                  maxLines: 1,
                  color: colors.onPrimary,
                  fontSize: 15,
                ),
              ],
            )),
      ),
    );
  }
}
