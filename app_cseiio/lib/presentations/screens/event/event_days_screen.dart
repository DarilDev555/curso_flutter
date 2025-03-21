import 'package:app_cseiio/domain/entities/event_day.dart';
import 'package:app_cseiio/presentations/providers/events/event_days_provider.dart';
import 'package:app_cseiio/presentations/providers/events/events_provider.dart';
import 'package:app_cseiio/presentations/widgets/shared/custom_avatar_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EventDaysScreen extends ConsumerWidget {
  static const name = 'event-days-screen';

  final String idEvent;

  const EventDaysScreen({super.key, required this.idEvent});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(getEventDaysProvider.notifier).loadEventDays(idEvent: idEvent);

    final event = ref
        .watch(getEventsProvider)
        .firstWhere((element) => element.id == idEvent);

    final eventDays = ref.watch(getEventDaysProvider)[idEvent];

    return Scaffold(
      appBar: AppBar(leading: CustomAvatarAppbar(), title: Text(event.name)),
      body: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            color: event.background,
          ),
          Container(
            height: 800,
            width: double.infinity,
            child: ListView.builder(
              itemCount: eventDays!.toList().length,
              itemBuilder:
                  (context, index) =>
                      Card(child: Text('${eventDays[index].numDay}')),
            ),
          ),
        ],
      ),
    );
  }
}
