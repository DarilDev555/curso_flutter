import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../domain/entities/event.dart';
import '../../../domain/entities/user.dart';
import '../../providers/auth/auth_provider.dart';
import '../../providers/events/invitation_code_event_provider.dart';
import '../../providers/events/invitation_code_register_provider.dart';
import '../../widgets/shared/custom_text_form_field.dart';
import '../../widgets/shared/update_create_image_avatar.dart';

class MenuTeacherDashboardScreen extends ConsumerStatefulWidget {
  const MenuTeacherDashboardScreen({super.key});

  @override
  MenuTeacherDashboardScreenState createState() =>
      MenuTeacherDashboardScreenState();
}

class MenuTeacherDashboardScreenState
    extends ConsumerState<MenuTeacherDashboardScreen> {
  late User user;

  @override
  void initState() {
    super.initState();
    user = ref.read(authProvider).user!;
    final isProfilePicture = user.profilePicture == 'img/teachers/default.png';

    if (isProfilePicture) {
      Future.microtask(() {
        if (!mounted) return;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const UpdateCreateImageAvatar(isFirstPicture: true),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Text(
          'Dashboard del Profesor',
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),

        // Menu Options
        Row(
          children: [
            Expanded(
              child: _MenuCard(
                title: 'Eventos',
                icon: Icons.event,
                onTap: () {
                  context.push('/events-screen');
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _MenuCard(
                title: 'Registrarse a Evento',
                icon: Icons.add_circle,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => const DialogCode(),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Current Event (if any)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.play_circle_filled, color: Colors.orange.shade700),
                  const SizedBox(width: 8),
                  Text(
                    'Evento en Curso',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Congreso de Tecnología 2024',
                style: TextStyle(fontSize: 14, color: Colors.orange.shade800),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // Navigate to current event screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade700,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Ir al Evento'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Upcoming Events Section
        Text(
          'Eventos Cercanos',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Events Swiper
        SizedBox(
          width: 400,
          height: 200,
          child: Swiper(
            itemCount: _sampleEvents.length,
            itemBuilder: (context, index) {
              final event = _sampleEvents[index];
              return Container(
                decoration: BoxDecoration(
                  color: event.background.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: event.background),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: event.background,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.description,
                        style: const TextStyle(fontSize: 14),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: event.background,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${event.startDate.day}/${event.startDate.month}/${event.startDate.year}',
                            style: TextStyle(
                              fontSize: 12,
                              color: event.background,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Sample events for demo
  final List<Event> _sampleEvents = [
    Event(
      id: '1',
      name: 'Conferencia de IA',
      startDate: DateTime.now().add(const Duration(days: 5)),
      endDate: DateTime.now().add(const Duration(days: 6)),
      description:
          'Una conferencia sobre inteligencia artificial y machine learning.',
    ),
    Event(
      id: '2',
      name: 'Workshop de Flutter',
      startDate: DateTime.now().add(const Duration(days: 10)),
      endDate: DateTime.now().add(const Duration(days: 10)),
      description:
          'Taller práctico sobre desarrollo de aplicaciones móviles con Flutter.',
    ),
    Event(
      id: '3',
      name: 'Seminario de Ciberseguridad',
      startDate: DateTime.now().add(const Duration(days: 15)),
      endDate: DateTime.now().add(const Duration(days: 16)),
      description: 'Seminario sobre las últimas tendencias en ciberseguridad.',
    ),
    Event(
      id: '4',
      name: 'Hackathon 2024',
      startDate: DateTime.now().add(const Duration(days: 20)),
      endDate: DateTime.now().add(const Duration(days: 22)),
      description: 'Competencia de programación de 48 horas.',
    ),
    Event(
      id: '5',
      name: 'Congreso de Innovación',
      startDate: DateTime.now().add(const Duration(days: 25)),
      endDate: DateTime.now().add(const Duration(days: 27)),
      description: 'Congreso sobre innovación tecnológica y emprendimiento.',
    ),
  ];
}

class _MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _MenuCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DialogCode extends ConsumerStatefulWidget {
  const DialogCode({super.key});

  @override
  ConsumerState<DialogCode> createState() => _DialogCodeState();
}

class _DialogCodeState extends ConsumerState<DialogCode> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registerTeacherToEventForm = ref.watch(
      registerTeacherByInvCodeProvider,
    );

    // Sincronizar el controller con el estado del provider
    if (controller.text != registerTeacherToEventForm.code.value) {
      controller.text = registerTeacherToEventForm.code.value;
      // Mover el cursor al final del texto
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    }

    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Registrarse a Evento',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Contenedor animado para el scanner QR
            AnimatedContainer(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              curve: Curves.fastOutSlowIn,
              duration: const Duration(milliseconds: 500),
              width: registerTeacherToEventForm.isQrActivate ? 250 : 0,
              height: registerTeacherToEventForm.isQrActivate ? 250 : 0,
              child:
                  registerTeacherToEventForm.isQrActivate
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: MobileScanner(
                          scanWindow: Rect.fromCenter(
                            center: const Offset(0, 0),
                            width: 500,
                            height: 500,
                          ),
                          placeholderBuilder:
                              (context) => Container(
                                color: Colors.grey[100],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          onDetect: (barcodes) {
                            final value = barcodes.barcodes.firstOrNull;
                            if (value == null) return;
                            if (value.displayValue == null) return;

                            // Actualizar el provider Y el controller
                            final scannedCode = value.displayValue!;
                            ref
                                .read(registerTeacherByInvCodeProvider.notifier)
                                .onInvitationCodeChange(scannedCode);

                            // Actualizar el controller directamente
                            controller.text = scannedCode;
                            controller.selection = TextSelection.fromPosition(
                              TextPosition(offset: scannedCode.length),
                            );

                            // Opcional: Cerrar el scanner automáticamente después de escanear
                            // ref
                            //     .read(registerTeacherByInvCodeProvider.notifier)
                            //     .changeQrScanner();

                            // Opcional: Mostrar feedback visual
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(
                            //     content: Text('Código escaneado: $scannedCode'),
                            //     duration: const Duration(seconds: 2),
                            //     backgroundColor: Colors.green,
                            //   ),
                            // );
                          },
                        ),
                      )
                      : const SizedBox.shrink(),
            ),

            const SizedBox(height: 24),

            // Botón para activar/desactivar el scanner QR
            ElevatedButton.icon(
              onPressed: () {
                ref
                    .read(registerTeacherByInvCodeProvider.notifier)
                    .changeQrScanner();
              },
              icon: Icon(
                registerTeacherToEventForm.isQrActivate
                    ? Icons.close
                    : Icons.qr_code_scanner,
              ),
              label: Text(
                registerTeacherToEventForm.isQrActivate
                    ? 'Cerrar Scanner'
                    : 'Escanear Código QR',
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor:
                    registerTeacherToEventForm.isQrActivate
                        ? Colors.red[400]
                        : null,
              ),
            ),

            const SizedBox(height: 16),

            // Divider con "O"
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'O',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),

            const SizedBox(height: 16),

            // Campo de entrada manual
            CustomTextFormField(
              label: 'Código del Evento',
              keyboardType: TextInputType.text,
              controller: controller, // ✅ Usar el controller
              onChanged: (value) {
                // Actualizar el provider cuando el usuario escriba manualmente
                ref
                    .read(registerTeacherByInvCodeProvider.notifier)
                    .onInvitationCodeChange(value);
              },
              disableSpace: true,
              errorMessage:
                  registerTeacherToEventForm.isFormPosted
                      ? errorMessageToCheckUserApi(
                        errorMessage:
                            registerTeacherToEventForm.code.errorMessage,
                        errors: registerTeacherToEventForm.error,
                      )
                      : null,
              readOnly: registerTeacherToEventForm.isQrActivate,
              enable: !registerTeacherToEventForm.isQrActivate,
            ),

            const SizedBox(height: 24),

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed:
                        registerTeacherToEventForm.isSumit
                            ? null
                            : () {
                              ref
                                  .read(
                                    registerTeacherByInvCodeProvider.notifier,
                                  )
                                  .onFormSumit();

                              // if (result && context.mounted) {
                              //   Navigator.pop(context);
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     const SnackBar(
                              //       content: Text('¡Registrado exitosamente!'),
                              //       backgroundColor: Colors.green,
                              //     ),
                              //   );
                              // }
                            },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child:
                        registerTeacherToEventForm.isSumit
                            ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Text('Registrar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String? errorMessageToCheckUserApi({String? errors, String? errorMessage}) {
    return errorMessage ?? errors;
  }
}
