import '../../../config/helpers/human_formats.dart';
import '../../providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/events/event_days_provider.dart';
import '../../providers/events/events_provider.dart';
import 'package:go_router/go_router.dart';

class EventDaysScreen extends ConsumerWidget {
  static const name = 'event-days-screen';
  final String idEvent;
  final String? mounth;
  final String? year;

  const EventDaysScreen({
    super.key,
    required this.idEvent,
    this.mounth,
    this.year,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user!;

    if (mounth != null && year != null) {
      ref
          .read(getEventsProvider.notifier)
          .loadEvents(month: mounth!, year: year!);

      ref.read(getEventDaysProvider.notifier).loadEventDays(idEvent: idEvent);
    }

    final events = ref.watch(getEventsProvider);
    final event =
        events.where((e) => e.id == idEvent).isNotEmpty
            ? events.firstWhere((e) => e.id == idEvent)
            : null;

    final eventDays = ref.watch(getEventDaysProvider)[idEvent] ?? [];
    final colors = Theme.of(context).colorScheme;
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body:
          event == null
              ? const Center(child: CircularProgressIndicator())
              : Stack(
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
                            alpha: 0.6,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 30,
                          horizontal: 8,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Evento',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Información del evento
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  event.description,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color: colors.primary,
                                    ),
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
                      ),

                      // Separador visual entre la info del evento y los días

                      // Lista de días del evento
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ListView.builder(
                            itemCount: eventDays.length,
                            itemBuilder: (context, index) {
                              final eventDay = eventDays[index];
                              return GestureDetector(
                                onTap: () {
                                  if (user.role.name == 'Register') {
                                    context.push(
                                      '/attendance-record-screen?idEventDay=${eventDay.id}&idEvent=${event.id}',
                                    );
                                  }
                                  if (user.role.name == 'Manager') {
                                    context.push(
                                      '/attendance-screen/${eventDay.id}',
                                    );
                                  }
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 4,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: event.background
                                          .withValues(alpha: 0.8),
                                      child: Text(
                                        '${eventDay.numDay}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
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
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
    );
  }
}
