import 'package:app_cseiio/infrastructure/datasources/events/events_datasource_impl.dart';
import 'package:app_cseiio/infrastructure/repositories/events/events_repository_impl.dart';
import 'package:app_cseiio/presentations/providers/auth/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventsRepositoryProvider = Provider((ref) {
  final String accessToken = ref.watch(authProvider).user!.token;

  return EventsRepositoryImpl(
    eventsDatasource: EventsDatasourceImpl(accessToken: accessToken),
  );
});
