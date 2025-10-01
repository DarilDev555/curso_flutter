import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tinycolor2/tinycolor2.dart';
import '../../../config/helpers/human_formats.dart';
import '../../../domain/entities/entities.dart';
import '../../providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/events/event_create_from_provider.dart';
import '../../providers/events/event_days_provider.dart';
import '../../providers/events/invitation_code_event_provider.dart';
import '../../widgets/shared/attendace_title.dart';
import '../../widgets/shared/custom_appbar.dart';
import '../../widgets/shared/text_frave.dart';

class EventDaysScreen extends ConsumerWidget {
  static const name = 'event-days-screen';
  final String idEvent;

  const EventDaysScreen({super.key, required this.idEvent});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(getEventDaysProvider.notifier).loadEventDays(idEvent: idEvent);
    final user = ref.watch(authProvider).user!;
    final colors = Theme.of(context).colorScheme;
    final Size screenSize = MediaQuery.of(context).size;
    final event = ref.watch(getEventDaysProvider)[idEvent];

    return Scaffold(
      body:
          (event != null)
              ? Stack(
                children: [
                  Container(
                    height: screenSize.height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          event.background.withValues(
                            alpha: 0.9,
                          ), // Primera parte (más oscura)
                          event.background.withValues(
                            alpha: 0.1,
                          ), // Segunda parte (más clara)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                      ),
                    ),
                  ),

                  // Contenido
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // AppBar personalizado con botón de regreso
                      const AppBarCustom(
                        title: Text(
                          'Evento',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // Información del evento
                      _InfoEvent(
                        event: event,
                        colors: colors,
                        isManager: user.role.name == 'Manager',
                      ),
                      // Separador visual entre la info del evento y los días
                      // Lista de días del evento
                      Expanded(
                        child: _ListEventDays(
                          user: user,
                          eventColor: event.background,
                          eventDays: event.eventdays!,
                          event: event,
                        ),
                      ),
                    ],
                  ),
                ],
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}

class _ListEventDays extends StatelessWidget {
  final List<EventDay> eventDays;
  final Color eventColor;
  final User user;
  final Event event;
  const _ListEventDays({
    required this.user,
    required this.eventDays,
    required this.eventColor,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        itemCount: eventDays.length,
        itemBuilder: (context, index) {
          final eventDay = eventDays[index];
          return GestureDetector(
            onTap: () {
              if (user.role.name == 'Manager') {
                context.push('/attendance-screen/${eventDay.id}/${event.id}');
              }
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ExpansionTile(
                enabled: (user.role.name != 'Manager'),
                leading: CircleAvatar(
                  backgroundColor: eventColor.withValues(alpha: 0.8),
                  child: Text(
                    '${eventDay.numDay}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(
                  'Día ${eventDay.numDay} - ${HumanFormats.formatDate(eventDay.dateDayEvent, nameDay: true)}',
                ),
                subtitle: Text(
                  'Horario: ${eventDay.startTime} - ${eventDay.endTime}',
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
                children:
                    (user.role.name == 'Register' ||
                            user.role.name == 'Teacher')
                        ? [
                          if (eventDay.attendances != null)
                            ...eventDay.attendances!.map((
                              Attendance attendance,
                            ) {
                              return GestureDetector(
                                onTap: () {
                                  if (user.role.name == 'Register') {
                                    context.push(
                                      '/attendance-record-screen?idAttendance=${attendance.id}&idEvent=${event.id}',
                                    );
                                  }
                                  if (attendance.register == null) {
                                    // Mostrar QR para registro de asistencia
                                    showDialog(
                                      context: context,
                                      builder:
                                          (_) => QrAttendanceDialog(
                                            size: size,
                                            user: user,
                                            attendance: attendance,
                                          ),
                                    );
                                  } else {
                                    // Mostrar información del registro existente
                                    showDialog(
                                      context: context,
                                      builder:
                                          (_) => InfoRegisterAttendanceDialog(
                                            attendance: attendance,
                                          ),
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AttendanceTile(
                                    attendance: attendance,
                                    colorBackground:
                                        TinyColor.fromColor(
                                          eventColor,
                                        ).darken(5).color,
                                    isUser: false,
                                  ),
                                ),
                              );
                            })
                          else
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Sin días registrados'),
                            ),
                        ]
                        : [],
              ),
            ),
          );
        },
      ),
    );
  }
}

class InfoRegisterAttendanceDialog extends StatelessWidget {
  final Attendance attendance;
  const InfoRegisterAttendanceDialog({super.key, required this.attendance});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 24),
                SizedBox(width: 8),
                Text(
                  'Asistencia Registrada',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 20),
            const SizedBox(height: 10),
            _InfoRow(
              icon: Icons.event,
              label: 'Asistencia:',
              value: attendance.name,
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.access_time,
              label: 'Hora de registro:',
              value: HumanFormats.formatTimeForSumitApi(
                attendance.register!.registerTime,
              ),
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.calendar_today,
              label: 'Fecha de registro:',
              value: HumanFormats.formatDate(attendance.register!.registerTime),
            ),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.location_on,
              label: 'Estado:',
              value:
                  (attendance.register!.registerTime.isBefore(
                        attendance.attendanceTime.copyWith(
                          minute: attendance.attendanceTime.minute + 5,
                        ),
                      ))
                      ? 'Presente'
                      : 'Ausente',
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QrAttendanceDialog extends StatelessWidget {
  const QrAttendanceDialog({
    super.key,
    required this.size,
    required this.user,
    required this.attendance,
  });

  final Size size;
  final User user;
  final Attendance attendance;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: size.width * 0.8,
        height: size.height * 0.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Escanea para registrar asistencia',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: size.width * 0.6,
              height: size.width * 0.6,
              padding: const EdgeInsets.all(16),
              child: QrImageView(
                data: user.id,
                version: QrVersions.auto,
                backgroundColor: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoEvent extends ConsumerWidget {
  final Event event;
  final bool isManager;
  const _InfoEvent({
    required this.colors,
    required this.event,
    required this.isManager,
  });

  final ColorScheme colors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      event.name,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ref.watch(eventCreateFromProvider);

                      ref
                          .read(eventCreateFromProvider.notifier)
                          .editEvent(
                            event,
                            isEditEventCreatedWithAttendance: true,
                          );
                      context.go('/event-create-update-screen');
                    },
                    icon: const Icon(Icons.edit_square),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                event.description,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, color: colors.primary),
                  const SizedBox(width: 8),
                  Text(
                    '${HumanFormats.formatDate(event.startDate)} - ${HumanFormats.formatDate(event.endDate)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              (isManager)
                  ? TextButton.icon(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        TinyColor.fromColor(
                          event.background,
                        ).setOpacity(0.5).color,
                      ),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          final size = MediaQuery.of(context).size;
                          ref
                              .read(invitationCodeEventProvider.notifier)
                              .genereteCode(event.id);

                          return InvitationCodeEventDialog(
                            size: size,
                            event: event,
                          );
                        },
                      );
                    },
                    label: const TextFrave(
                      text: 'Generar codigo para asignacion',
                    ),
                    icon: const Icon(Icons.link_rounded),
                  )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class InvitationCodeEventDialog extends ConsumerWidget {
  final Size size;
  final Event event;

  const InvitationCodeEventDialog({
    super.key,
    required this.size,
    required this.event,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codes = ref.watch(invitationCodeEventProvider);
    final code = codes[event.id];
    return (code != null)
        ? Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header con gradiente
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        event.background.withValues(alpha: 0.9),
                        event.background.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.qr_code_2_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Código de Registro',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Contenido principal
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Descripción mejorada
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: event.background.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: event.background,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Comparte este código QR o el código de texto para que los usuarios puedan registrarse al evento',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Código QR mejorado
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: event.background.withValues(alpha: 0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: event.background.withValues(alpha: 0.1),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // QR Code
                            Container(
                              width: size.width * 0.4,
                              height: size.width * 0.4,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: QrImageView(
                                data: code,
                                version: QrVersions.auto,
                                size: size.width * 0.4,
                                backgroundColor: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Código de texto
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.tag,
                                    color: event.background,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    code,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      // Aquí podrías agregar funcionalidad de copiar
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Código copiado al portapapeles',
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.copy,
                                      color: event.background,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Botones de acción
                      Row(
                        children: [
                          // Botón compartir
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[300]!),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    // Funcionalidad de compartir
                                    Navigator.pop(context);
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.share,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Compartir',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Botón cerrar
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: event.background,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: event.background.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () => Navigator.pop(context),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Entendido',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        : const Center(child: CircularProgressIndicator());
  }
}
