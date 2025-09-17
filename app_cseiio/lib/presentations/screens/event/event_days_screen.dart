import 'package:go_router/go_router.dart';
import 'package:tinycolor2/tinycolor2.dart';

import '../../../config/helpers/human_formats.dart';
import '../../../domain/entities/entities.dart';
import '../../providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/events/event_create_from_provider.dart';
import '../../providers/events/event_days_provider.dart';
import '../../widgets/shared/attendace_title.dart';
import '../../widgets/shared/custom_appbar.dart';

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
                      _ListEventDays(
                        user: user,
                        eventColor: event.background,
                        eventDays: event.eventdays!,
                        event: event,
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
    return Expanded(
      child: Container(
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
                      (user.role.name == 'Register')
                          ? [
                            if (eventDay.attendances != null)
                              ...eventDay.attendances!.map((attendande) {
                                return GestureDetector(
                                  onTap: () {
                                    context.push(
                                      '/attendance-record-screen?idAttendance=${attendande.id}',
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AttendanceTile(
                                      attendance: attendande,
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
                  Text(
                    event.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
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
                    icon: Icon(Icons.edit_square),
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
            ],
          ),
        ),
      ),
    );
  }
}
