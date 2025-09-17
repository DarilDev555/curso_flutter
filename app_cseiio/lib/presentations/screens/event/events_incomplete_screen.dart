import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/events/event_create_from_provider.dart';
import '../../providers/events/events_incomplete_provider.dart';

class IncompleteEventsScreen extends ConsumerWidget {
  static const name = 'events-incomplete-screen';

  const IncompleteEventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(eventCreateFromProvider, (previous, next) {
      if (previous == null) return;
      if (!previous.isValidEvent && next.isValidEvent) {
        if (context.mounted) {
          context.go('/event-days-create-update-screen');
        }
      }
    });
    final events = ref.watch(incompleteEventsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Eventos Incompletos')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Seleccione un evento incompleto para continuar con su creación o inicie uno nuevo desde cero.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child:
                events == null
                    ? const Center(child: CircularProgressIndicator())
                    : events.isEmpty
                    ? const Center(
                      child: Text(
                        'No hay eventos incompletos',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                    : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: events.length,
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: event.background.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: event.background.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            onTap: () {
                              ref
                                  .read(eventCreateFromProvider.notifier)
                                  .continueCreateEvent(event);
                            },
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: event.background.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: event.background,
                                  width: 2,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                event.name.isNotEmpty
                                    ? event.name[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  color: event.background,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              event.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (event.description.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        event.description,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ),
                                  Text(
                                    '${_formatDate(event.startDate)} - ${_formatDate(event.endDate)}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                // Aquí irá tu lógica para eliminar
                              },
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/event-create-update-screen'),
        tooltip: 'Crear nuevo evento', // Misma ruta que arriba
        child: const Icon(Icons.add),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
